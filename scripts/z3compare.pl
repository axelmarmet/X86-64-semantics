#!/usr/bin/perl

# Common includes
use strict;
use warnings;
use Getopt::Long;
use File::Compare;
use File::Basename;
use File::chdir;
use Cwd;
use File::Path qw(make_path remove_tree);
use Env;

use lib qw( /home/sdasgup3/scripts-n-docs/scripts/perl/ );
use utils;
use lib qw( /home/sdasgup3/x86-semantics/scripts/ );
use kutils;

# Using GetOPtions
my @file   = ();
my @show   = ();
my $opcode = "";
my $debug  = "";

GetOptions(
    "file:s"   => \@file,
    "show:s"   => \@show,
    "opcode:s" => \$opcode,
    "debug"    => \$debug,
) or die("Error in command line arguments\n");

if ( ( $opcode eq "" ) or ( scalar(@file) < 2 ) ) {
    print "Provide --file and  --opcode args\n\n";
    exit(0);
}

# File Open
open( my $fp0, "<", $file[0] ) or die "cannot open: $file[0]: $!";
open( my $fp1, "<", $file[1] ) or die "cannot open: $file[1]: $!";
my @lines0 = <$fp0>;
my @lines1 = <$fp1>;

my $map0_ref = processLines( \@lines0 );
my $map1_ref = processLines( \@lines1 );

if ( "" ne $debug ) {
    utils::printMap( $map0_ref, "" );
    utils::printMap( $map1_ref, "" );
}

my $decls = qq(

$kutils::z3_decl_template

);

my $workfile = "/home/sdasgup3/Junk/LOCKER/$opcode.z3";
open( my $fp, ">", $workfile ) or die "cannot open: $workfile: $!";

print $fp $decls;

my %map0 = %{$map0_ref};
my %map1 = %{$map1_ref};

for my $key0 ( keys %map0 ) {
    if ( exists $map1{$key0} ) {
        my $rule0 = $map0{$key0};
        my $rule1 = $map1{$key0};

        my $writesize0 = 0;
        my $writesize1 = 0;
        if ( $rule0 =~ m/\((\d+) bytes\)/g ) {
            $writesize0 = $1;
            $rule0 =~ s/\(\d+ bytes\)\.//g;
        }
        if ( $rule1 =~ m/\((\d+) bytes\)/g ) {
            $writesize1 = $1;
            $rule1 =~ s/\(\d+ bytes\)\.//g;
        }

        if ( $writesize1 != $writesize0 ) {
            utils::failInfo("$opcode: write size mismatch");
        }

        print $fp "( echo \"$opcode::$key0\")\n";
        print $fp "(assert (not (=" . "\n"
          . $rule0 . "\n\n"
          . $rule1 . "\n"
          . ")))\n(check-sat)"
          . "\n\n\n\n";
    }
}

exit(0);

sub processLines {
    my $lines_ref = shift @_;
    my @lines     = @{$lines_ref};

    my %map = ();

    my $currRuleName       = "";
    my $appendRules        = 0;
    my $appendAddressRules = 0;
    for my $line (@lines) {
        chomp $line;
        $line = utils::trim($line);

        if ( $line eq "" ) {
            next;
        }

        if ( $line =~
m/maybe|must|required|read|write|Value|adress|sigfpe|sigbus|sigsegv|Formula|Hindex|code/g
          )
        {
            $appendRules        = 0;
            $appendAddressRules = 0;
            next;
        }

        # Normalize the rule
        $line =~ s/TMP_BV_(\d+)_\d+/TMP_BV_$1/g;
        $line =~ s/TMP_BOOL_\d+/TMP_BOOL/g;
        $line =~ s/%(\w+)/$1/g;

        if ( $line =~ m/Address (.*) was updated to/g ) {
            my $ruleName = "WA";
            my $rule     = $1;
            $map{$ruleName}     = $rule;
            $map{"WD"}          = "";
            $appendAddressRules = 1;
            $appendRules        = 0;

            $currRuleName = "WD";
        }
        elsif ( 1 == $appendAddressRules ) {
            my $ruleName = $currRuleName;
            $map{$ruleName} = $map{$ruleName} . "\n" . $line;
        }

        if ( $line =~ m/(\w+)\s*:\s*(.*)$/g ) {
            my $ruleName = $1;
            my $rule     = $2;

            $map{$ruleName}     = $rule;
            $currRuleName       = $ruleName;
            $appendRules        = 1;
            $appendAddressRules = 0;
        }
        elsif ( 1 == $appendRules ) {
            my $ruleName = $currRuleName;
            $map{$ruleName} = $map{$ruleName} . "\n" . $line;
        }
    }

    return \%map;
}
