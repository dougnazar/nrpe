# generated automatically by aclocal 1.17 -*- Autoconf -*-

# Copyright (C) 1996-2024 Free Software Foundation, Inc.

# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

m4_ifndef([AC_CONFIG_MACRO_DIRS], [m4_defun([_AM_CONFIG_MACRO_DIRS], [])m4_defun([AC_CONFIG_MACRO_DIRS], [_AM_CONFIG_MACRO_DIRS($@)])])
# ===========================================================================
#    https://www.gnu.org/software/autoconf-archive/ax_check_link_flag.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_CHECK_LINK_FLAG(FLAG, [ACTION-SUCCESS], [ACTION-FAILURE], [EXTRA-FLAGS], [INPUT])
#
# DESCRIPTION
#
#   Check whether the given FLAG works with the linker or gives an error.
#   (Warnings, however, are ignored)
#
#   ACTION-SUCCESS/ACTION-FAILURE are shell commands to execute on
#   success/failure.
#
#   If EXTRA-FLAGS is defined, it is added to the linker's default flags
#   when the check is done.  The check is thus made with the flags: "LDFLAGS
#   EXTRA-FLAGS FLAG".  This can for example be used to force the linker to
#   issue an error when a bad flag is given.
#
#   INPUT gives an alternative input source to AC_LINK_IFELSE.
#
#   NOTE: Implementation based on AX_CFLAGS_GCC_OPTION. Please keep this
#   macro in sync with AX_CHECK_{PREPROC,COMPILE}_FLAG.
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#   Copyright (c) 2011 Maarten Bosmans <mkbosmans@gmail.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 6

AC_DEFUN([AX_CHECK_LINK_FLAG],
[AC_PREREQ(2.64)dnl for _AC_LANG_PREFIX and AS_VAR_IF
AS_VAR_PUSHDEF([CACHEVAR],[ax_cv_check_ldflags_$4_$1])dnl
AC_CACHE_CHECK([whether the linker accepts $1], CACHEVAR, [
  ax_check_save_flags=$LDFLAGS
  LDFLAGS="$LDFLAGS $4 $1"
  AC_LINK_IFELSE([m4_default([$5],[AC_LANG_PROGRAM()])],
    [AS_VAR_SET(CACHEVAR,[yes])],
    [AS_VAR_SET(CACHEVAR,[no])])
  LDFLAGS=$ax_check_save_flags])
AS_VAR_IF(CACHEVAR,yes,
  [m4_default([$2], :)],
  [m4_default([$3], :)])
AS_VAR_POPDEF([CACHEVAR])dnl
])dnl AX_CHECK_LINK_FLAGS

m4_include([macros/ax_nagios_get_distrib.m4])
m4_include([macros/ax_nagios_get_files.m4])
m4_include([macros/ax_nagios_get_inetd.m4])
m4_include([macros/ax_nagios_get_init.m4])
m4_include([macros/ax_nagios_get_os.m4])
m4_include([macros/ax_nagios_get_paths.m4])
m4_include([macros/ax_nagios_get_ssl.m4])
