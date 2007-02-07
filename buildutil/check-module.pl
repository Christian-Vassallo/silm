#!/usr/bin/perl
# -*- perl -*-
######################################################################
# check-module.pl -- Check that module directory has valid contents.
# Copyright (c) 2007 Tero Kivinen
# All Rights Reserved.
######################################################################
#         Program: check-module.pl
#	  $Source: /u/samba/nwn/bin/RCS/check-module.pl,v $
#	  Author : $Author: kivinen $
#
#	  (C) Tero Kivinen 2007 <kivinen@iki.fi>
#
#	  Creation          : 23:21 tammi 23 2007 kivinen
#	  Last Modification : 00:37 Jan 24 2007 kivinen
#	  Last check in     : $Date: 2007/01/23 22:38:36 $
#	  Revision number   : $Revision: 1.4 $
#	  State             : $State: Exp $
#	  Version	    : 1.115
#	  Edit time	    : 34 min
#
#	  Description       : Check that module directory has valid
#			      contents, this will verify all gff files,
#		      	      and check that module.ifo has valid contents.
#
#	  $Log: check-module.pl,v $
#	  Revision 1.4  2007/01/23 22:38:36  kivinen
#	  	Changed the default argument to be '*'.
#
#	  Revision 1.3  2007/01/23 22:34:40  kivinen
#	  	Added reference to the update-ifo.
#
#	  Revision 1.2  2007/01/23 22:27:37  kivinen
#	  	Added documentation.
#
#	  Revision 1.1  2007/01/23 22:22:51  kivinen
#	  	Created.
#
#	  $EndLog$
#
#
######################################################################
# initialization

require 5.6.0;
package CheckModule;
use strict;
use Getopt::Long;
use File::Glob ':glob';
use GffRead;
use Pod::Usage;

$Opt::verbose = 0;

######################################################################
# Get version information

open(PROGRAM, "<$0") || die "Cannot open myself from $0 : $!";
undef $/;
$Prog::program = <PROGRAM>;
$/ = "\n";
close(PROGRAM);
if ($Prog::program =~ /\$revision:\s*([\d.]*)\s*\$/i) {
    $Prog::revision = $1;
} else {
    $Prog::revision = "?.?";
}

if ($Prog::program =~ /version\s*:\s*([\d.]*\.)*([\d]*)\s/mi) {
    $Prog::save_version = $2;
} else {
    $Prog::save_version = "??";
}

if ($Prog::program =~ /edit\s*time\s*:\s*([\d]*)\s*min\s*$/mi) {
    $Prog::edit_time = $1;
} else {
    $Prog::edit_time = "??";
}

$Prog::version = "$Prog::revision.$Prog::save_version.$Prog::edit_time";
$Prog::progname = $0;
$Prog::progname =~ s/^.*\///g;

$| = 1;

######################################################################
# Read rc-file

if (defined($ENV{'HOME'})) {
    read_rc_file("$ENV{'HOME'}/.checkmodulerc");
}

######################################################################
# Option handling

Getopt::Long::Configure("no_ignore_case");

if (!GetOptions("config=s" => \$Opt::config,
		"verbose|v+" => \$Opt::verbose,
		"help|h" => \$Opt::help,
		"version|V" => \$Opt::version) || defined($Opt::help)) {
    usage();
}

if (defined($Opt::version)) {
    print("\u$Prog::progname version $Prog::version by Tero Kivinen.\n");
    exit(0);
}

while (defined($Opt::config)) {
    my($tmp);
    $tmp = $Opt::config;
    undef $Opt::config;
    if (-f $tmp) {
	read_rc_file($tmp);
    } else {
	die "Config file $Opt::config not found: $!";
    }
}

######################################################################
# Main loop

$| = 1;

my($i, $j, $name, $type, %areas, %area_resources, %resource_numbers);
my($module_ifo, $repute_fac);

if ($#ARGV == -1) {
    push(@ARGV, "*");
}

if (join(";", @ARGV) =~ /[*?]/) {
    my(@argv);
    foreach $i (@ARGV) {
	push(@argv, bsd_glob($i));
    }
    @ARGV = @argv;
}

%area_resources =
    ( trx => 1,
      trn => 2,
      are => 4,
      git => 8,
      gic => 16
      );

map {
    $resource_numbers{$area_resources{$_}} = $_;
} keys(%area_resources);

foreach $i (@ARGV) {
    my($gff);

    if (-d $i) {
        if ($Opt::verbose) {
            print("Found directory $i...\n");
        }
	push(@ARGV, bsd_glob($i . "/*"));
        next;
    }
    
    $type = lc($i);
    $type =~ s/^.*\.//g;
    $name = lc($i);
    $name =~ s/^.*\///g;
    $name =~ s/\..*$//g;

    if (defined($area_resources{$type})) {
        $areas{$name} = 0 if (!defined($areas{$name}));
        $areas{$name} |= $area_resources{$type};
    }

    next if ($type eq 'trx' || $type eq 'trn' ||
             $type eq 'ncs' || $type eq 'nss' ||
             $type eq '2da' || $type eq 'tlk' ||
             $type eq 'sef' || $type eq 'pfx' ||
             $type eq 'lfx' || $type eq 'bfx' ||
             $type eq 'ifx');

    if ($Opt::verbose) {
	print("Reading file $i...\n");
    }
    if ($i =~ /module.ifo$/) {
        $gff = GffRead::read('filename' => $i,
                             'check_recursion' => 1,
                             'return_errors' => 1);
    } else {
        $gff = GffRead::read('filename' => $i,
                             'check_recursion' => 1,
                             'no_store' => 1,
                             'return_errors' => 1);
    }
    if (!defined($gff)) {
        printf("Error parsing file $i, might be corrupted\n");
    }
    if ($Opt::verbose) {
	printf("Read done\n");
    }
    if ($i =~ /module\.ifo$/) {
	$gff->find(find_label => '/Mod_Area_list\[\d+\]/$',
		   proc => \&area_names);
        $module_ifo = 1;
    }
    if ($i =~ /repute\.fac$/) {
        $repute_fac = 1;
    }
}

if (!defined($module_ifo)) {
    print("No module.ifo in the module\n");
}

if (!defined($repute_fac)) {
    print("No repute.fac in the module\n");
}

foreach $i (keys %areas) {
    if ($areas{$i} != 31) {
        my(@list);
        for($j = 1; $j < 32; $j *= 2) {
            if (($areas{$i} & $j) == 0) {
                push(@list, $resource_numbers{$j});
            }
        }
        print("Area $i is missing some files: ", join(", ", @list), "\n");
    }
    if (!defined($CheckModule::area{$i})) {
        print("Area $i is not listed in the module.ifo\n");
    } else {
        $CheckModule::area{$i}++;
    }
}

foreach $i (keys %CheckModule::area) {
    if ($CheckModule::area{$i} != 2) {
        print("Area $i is listed in the module.ifo, " .
              "but no area files found\n");
    }
}

exit 0;

######################################################################
# Check conditional or action script in the dialog

sub area_names {
    my($gff, $full_label, $label, $value, $parent_gffs) = @_;
    my($name);
    $name = lc($$gff{Area_Name});
    if (!defined($name)) {
        print("Module.ifo has /Mod_Area_list/ entry without Area_Name: " .
              $full_label);
    }
    if ($Opt::verbose > 2) {
        print("Found area $name from module.ifo\n");
    }
    if (defined($CheckModule::area{$name})) {
        print("Found area $name twice from module.ifo\n");
    }
    $CheckModule::area{$name} = 1;
}

######################################################################
# Read rc file

sub read_rc_file {
    my($file) = @_;
    my($next, $space);
    
    if (open(RCFILE, "<$file")) {
	while (<RCFILE>) {
	    chomp;
	    while (/\\$/) {
		$space = 0;
		if (/\s+\\$/) {
		    $space = 1;
		}
		s/\s*\\$//g;
		$next = <RCFILE>;
		chomp $next;
		if ($next =~ s/^\s+//g) {
		    $space = 1;
		}
		if ($space) {
		    $_ .= " " . $next;
		} else {
		    $_ .= $next;
		}
	    }
	    if (/^\s*([a-zA-Z0-9_]+)\s*$/) {
		eval('$Opt::' . lc($1) . ' = 1;');
	    } elsif (/^\s*([a-zA-Z0-9_]+)\s*=\s*\"([^\"]*)\"\s*$/) {
		my($key, $value) = ($1, $2);
		$value =~ s/\\n/\n/g;
		$value =~ s/\\t/\t/g;
		eval('$Opt::' . lc($key) . ' = $value;');
	    } elsif (/^\s*([a-zA-Z0-9_]+)\s*=\s*(.*)\s*$/) {
		my($key, $value) = ($1, $2);
		$value =~ s/\\n/\n/g;
		$value =~ s/\\t/\t/g;
		eval('$Opt::' . lc($key) . ' = $value;');
	    }
	}
	close(RCFILE);
    }
}


######################################################################
# Usage

sub usage {
    Pod::Usage::pod2usage(0);
}

=head1 NAME

check-module - Checks module directory to see if it is ok. 

=head1 SYNOPSIS

check-module [B<--help>|B<-h>] [B<--version>|B<-V>] [B<--verbose>|B<-v>]
    [B<--config> I<config-file>]
    [I<filename> ...]

check-module B<--help>

=head1 DESCRIPTION

B<check-module> checks each files given to it, and if they are
directories, then files inside those directories, and checks if it is
valid module file. It will parse each gff file, and also verifies that
the area name lists in the module.ifo and files on the directory
match, and that each area has all required area files. If this program
prints error from the module.ifo, then you can use the B<update-ifo>
program to fix those errors.

If no arguments is given, then '*' is assumed.

=head1 OPTIONS

=over 4

=item B<--help> B<-h>

Prints out the usage information.

=item B<--version> B<-V>

Prints out the version information. 

=item B<--verbose> B<-v>

Enables the verbose prints. This option can be given multiple times,
and each time it enables more verbose prints. 

=item B<--config> I<config-file>

All options given by the command line can also be given in the
configuration file. This option is used to read another configuration
file in addition to the default configuration file. 

=back

=head1 EXAMPLES

    check-module temp0/*.*
    check-module -v temp0
    check-module

=head1 FILES

=over 6

=item ~/.checkmodulerc

Default configuration file.

=back

=head1 SEE ALSO

update-ifo(1), gffprint(1), Gff(3), and GffRead(3).

=head1 AUTHOR

Tero Kivinen <kivinen@iki.fi>.

=head1 HISTORY

This is using the B<gffprint> program as a template, but skip the
printing of the data, and instead only parses the gff files. Area file
list checking was copied fromt he fixupmodule.pl used in the cerea2
build process.
