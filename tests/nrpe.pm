package nrpe;
use strict;
use warnings;
use Exporter;
use Socket;
use Test::More;

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw( check_if_port_available check_if_ipv6_available supports_ssl
        switch_config_file launch_daemon restart_daemon kill_daemon ensure_daemon_running
        STATE_OK STATE_WARNING STATE_CRITICAL STATE_UNKNOWN
        $nrpe $checknrpe );

# these are exported by default.
our @EXPORT = qw( check_if_port_available check_if_ipv6_available supports_ssl
        switch_config_file launch_daemon restart_daemon kill_daemon ensure_daemon_running
        STATE_OK STATE_WARNING STATE_CRITICAL STATE_UNKNOWN
        $nrpe $checknrpe );

defined($ARGV[0]) or die "Usage: $0 <top build dir>";

my $top_builddir = $ARGV[0]; # shift @ARGV;
our $nrpe = "$top_builddir/src/nrpe";
our $checknrpe = "$top_builddir/src/check_nrpe --disable-syslog";
#our $checknrpe = "valgrind --leak-check=full --log-file=logs/valgrind-check-%p.log $top_builddir/src/check_nrpe --disable-syslog";
my $nrpe_pid = 0;

use constant {
    STATE_UNKNOWN => 3 << 8,
    STATE_CRITICAL => 2 << 8,
    STATE_WARNING => 1 << 8,
    STATE_OK => 0 << 8,
};

$SIG{INT}  = \&signal_handler;
$SIG{TERM} = \&signal_handler;

sub read_pid {
    open my $fh, '<', "run/nrpe.pid" or return 0;
    chomp( my $pid = <$fh> );
    return $pid
}

sub check_connection {
    if (socket(my $s, AF_INET, SOCK_STREAM, Socket::IPPROTO_TCP)) {
        my $a = connect($s, pack_sockaddr_in(40321, inet_aton("127.0.0.1")));
        close $s;
        return 1 if defined $a;
    }
    if (socket(my $s, AF_INET6, SOCK_STREAM, Socket::IPPROTO_TCP)) {
        my $a = connect($s, pack_sockaddr_in6(40321, Socket::inet_pton(AF_INET6, "::1")));
        close $s;
        return 1 if defined $a;
    }
    return 0;
}

sub check_if_ipv6_available {
    socket(my $s, AF_INET6, SOCK_STREAM, Socket::IPPROTO_TCP) || return 0;
    return 1;
}

sub check_if_port_available {
    BAIL_OUT('Something is already listening on our port 40321') if check_connection();
}

sub switch_config_file {
    my $filename = shift @_;
    unlink 'nrpe.cfg';
    symlink($filename, 'nrpe.cfg') || BAIL_OUT('Unable to update config symlink');
}

sub wait_for_daemon {
    my $counter = 0;
    while (!check_connection() && $counter < 15) {
        sleep(1);
        $counter++;
    }
    diag("Waiting $counter seconds for daemon") if $counter > 7;
}

sub launch_daemon {
    my @output = `$nrpe --daemon --dont-chdir --config nrpe.cfg`;
#    my @output = `valgrind --leak-check=full --log-file=logs/valgrind-%p.log $nrpe --daemon --dont-chdir --config nrpe.cfg`;
    my $pid = 0;

    my $counter = 0;
    while ( ($pid = read_pid()) == 0 && $counter < 10) {
        sleep(1);
        $counter++;
    }
    diag(@output);
    BAIL_OUT('Unable to get nrpe daemon pid') if $pid == 0;
    note("started daemon on $pid");
    $nrpe_pid = $pid;

    wait_for_daemon();
    return $pid
}

sub ensure_daemon_running {
    my $pid = read_pid() || BAIL_OUT('daemon is not running');
    kill 0, $pid || BAIL_OUT('daemon is not running');
    $nrpe_pid = $pid;
}

sub restart_daemon {
    if ($nrpe_pid > 0) {
        note("restarting daemon on $nrpe_pid");
        kill 'HUP', $nrpe_pid;
        sleep(1);
        wait_for_daemon();
    } else {
        diag('pid for nrpe daemon unknown');
    }
    return 0;
}

sub kill_daemon {
    if ($nrpe_pid > 0) {
        note("killing daemon on $nrpe_pid");
        kill 'TERM', $nrpe_pid;
        $nrpe_pid = 0;
        sleep(1);
    }
    return 0;
}

sub supports_ssl {
    my @output = `$nrpe --help`;
    return grep(m'^SSL/TLS Available', @output);
}





#END {
#    kill_daemon();
#}

sub signal_handler {
    kill_daemon();
}

1;
