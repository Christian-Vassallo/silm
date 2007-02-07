#!/usr/local/bin/perl
# -*- perl -*-
######################################################################
# Twoda.pm -- 2DA parser
# Copyright (c) 2004 Tero Kivinen
# All Rights Reserved.
######################################################################
#         Program: Twoda.pm
#	  $Source: /u/samba/nwn/perllib/RCS/Twoda.pm,v $
#	  Author : $Author: kivinen $
#
#	  (C) Tero Kivinen 2005 <kivinen@iki.fi>
#
#	  Creation          : 20:57 Jan  9 2005 kivinen
#	  Last Modification : 14:51 Jan 15 2005 kivinen
#	  Last check in     : $Date: 2005/02/05 14:32:15 $
#	  Revision number   : $Revision: 1.1 $
#	  State             : $State: Exp $
#	  Version	    : 1.42
#	  Edit time	    : 18 min
#
#	  Description       : 2DA parser
#
#	  $Log: Twoda.pm,v $
#	  Revision 1.1  2005/02/05 14:32:15  kivinen
#	  	Created.
#
#	  $EndLog$
#
#
######################################################################
# initialization

require 5.6.0;
package Twoda;
use strict;
use Carp;

######################################################################
# \@twoda = read($file)

sub read {
    my($file) = @_;
    my(@header, $line, @line, @twoda, $i);

    open(FILE, "<$file") || croak "Cannot open file $file : $!";
    $line = <FILE>;
    chomp $line;
    if ($line =~ /^2DA V2.0$/) {
	croak "Invalid first line of 2da file : $line";
    }
    $line = <FILE>;
    chomp $line;
    if ($line =~ /^$/) {
	croak "2nd line should be empty: $line";
    }
    $line = <FILE>;
    chomp $line;
    $line =~ s/[\r\n]//g;
    @header = split(/[ \t]+/, $line);
    $line = 0;
    while (<FILE>) {
	chomp;
	s/[\r\n]//g;
	next if (/^\s*$/);
	@line = split(/[ \t]+/, $_);
	if ($#line != $#header) {
	    croak "Number of items $#line on line $line differs from header $#header: $_";
	}
	for($i = 0; $i <= $#header; $i++) {
	    $twoda[$line]{$header[$i]} = $line[$i];
	}
	$line++;
    }
    close(FILE);
    return \@twoda;
}


######################################################################
# Return Success

1;

######################################################################
# EOF
######################################################################
