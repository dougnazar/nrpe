#!/usr/bin/perl

use warnings;
use strict;
BEGIN {
    use File::Basename;
    use lib (dirname(__FILE__));
}

use Test::More tests => 5;
use nrpe;


my @output;

@output = `$nrpe -V`;
is($?, STATE_UNKNOWN, 'nrpe executes');
like($output[0], qr/NRPE - Nagios Remote Plugin Executor/, 'nrpe banner');

@output = `$checknrpe -V`;
is($?, STATE_UNKNOWN, 'check_nrpe executes');
like($output[0], qr/NRPE Plugin for Nagios/, 'check_nrpe banner');


@output = `$nrpe --daemon --dont-chdir --config configs/missing.cfg`;
is($?, STATE_CRITICAL, 'invalid config') || diag @output;



check_if_port_available();
switch_config_file("configs/normal.cfg");
launch_daemon();


done_testing();
