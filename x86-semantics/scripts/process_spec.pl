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
use lib qw( /home/sdasgup3/scripts-n-docs/scripts/perl/ );
use utils;
use lib qw( /home/sdasgup3/Github/x86_semantics_immm/x86-semantics/scripts/ );
use kutils;
use File::Find;
use File::chdir;
use Cwd;

=pod
This file is used to create the *spec.k files used for krpove.

perl create_spec.pl --file  <file> --strata_path <path to circuits>
  where file contains list of opcodes.
=cut

# Using GetOPtions
my $file        = "";
my $strata_path = "/home/sdasgup3/Github/strata-data/circuits";
my $instantiated_instr_path =
  "/home/sdasgup3/Github/strata-data/data-regs/instructions/";
my $specdir = "/home/sdasgup3/Github/binary-decompilation/x86-semantics/specs/";
my $derivedInstructions =
"/home/sdasgup3/Github/binary-decompilation/x86-semantics/derivedInstructions/";
my $help           = "";
my $stratum        = "";
my $readmod        = "";
my $createspec     = "";
my $postprocess    = "";
my $kprove         = "";
my $getoplist      = "";
my $all            = "";
my $genincludes    = "";
my $checksanity    = "";
my $gitdiff        = "";
my $gitadd         = "";
my $gitco         = "";
my $speconly       = "";
my $singlefiledefn = "";
my $nightlyrun     = "";
my $start          = "";
my $getimm         = "";
my $getimmdiff           = "";
my $getmem           = "";

GetOptions(
    "help"           => \$help,
    "file:s"         => \$file,
    "stratum"        => \$stratum,
    "readmod"        => \$readmod,
    "createspec"     => \$createspec,
    "getoplist"      => \$getoplist,
    "kprove"         => \$kprove,
    "postprocess"    => \$postprocess,
    "all"            => \$all,
    "genincludes"    => \$genincludes,
    "checksanity"    => \$checksanity,
    "gitdiff"        => \$gitdiff,
    "speconly"       => \$speconly,
    "gitadd"         => \$gitadd,
    "gitco"          => \$gitco,
    "singlefiledefn" => \$singlefiledefn,
    "getimm"         => \$getimm,
    "getimmdiff"     => \$getimmdiff,
    "getmem"         => \$getmem,
    "nightlyrun"     => \$nightlyrun,
    "start:s"        => \$start,
    "strata_path:s"  => \$strata_path,
) or die("Error in command line arguments\n");

##
my $sfp;
my $removeComment;
my $debugprint = 0;

if ( "" ne $singlefiledefn ) {

    my $singleFile = "x86-instructions-semantics.k";
    open( $sfp, ">", $singleFile ) or die "Can't open: $!";
    $removeComment = 0;

    print $sfp "requires \"x86-configuration.k\"" . "\n";
    print $sfp "requires \"x86-flag-checks-syntax.k\"" . "\n\n";
    print $sfp "module X86-INSTRUCTIONS-SEMANTICS" . "\n";
    print $sfp "  imports X86-CONFIGURATION" . "\n";
    print $sfp "  imports X86-FLAG-CHECKS-SYNTAX" . "\n";

    find( \&mergeToSingleFile, "instructions/" );

    #print $sfp "endmodule";
    #    close($sfp);

    #    $singleFile = "test2.k";
    #    open( $sfp, ">", $singleFile ) or die "Can't open: $!";
    $removeComment = 1;

    #    print $sfp "requires \"x86-configuration.k\"" . "\n\n";
    #    print $sfp "module X86-DERIVED-INSTRUCTIONS-SEMANTICS" . "\n";
    #    print $sfp "  imports X86-CONFIGURATION" . "\n";

    find( \&mergeToSingleFile, "derivedInstructions/" );

    print $sfp "endmodule";
    close($sfp);

    exit(0);
}

sub mergeToSingleFile {
    my $file = $_;
    if ( !( -f $file ) or ( $file !~ m/\.k$/ ) ) {
        return;
    }

    my $koutput = "$file";

    #print "Merging $koutput\n";

    open( my $fp, "<", $koutput ) or die "Can't open ::$koutput\:: $!";
    my @lines = <$fp>;

    for my $line (@lines) {
        if ( $line =~ m/^module (.*)/ ) {
            print $sfp "// " . lc($1) . "\n";
            next;
        }
        if ( $line =~ m/imports/ ) {
            next;
        }
        if ( $line =~ m/^requires "(.*\.k)"/ ) {
            next;
        }
        if ( $line =~ m/Autogenerated/ ) {
            next;
        }
        if ( $line =~ m/endmodule/ ) {
            print $sfp "\n";
            if ( $removeComment == 1 ) {
                last;
            }
            else {
                next;
            }
        }
        print $sfp $line;
    }
}

if ( "" ne $nightlyrun ) {

    if ( "" eq $start ) {
        $start = 0;
    }

    my $cmd = "";
    for ( my $i = $start ; $i <= 15 ; $i++ ) {
        my $file = "docs/relatedwork/strata/stratum_$i.txt";
        $cmd = $cmd . 
          "./scripts/process_spec.pl --file $file -all 1> $file.all.log 2>&1 ; ./scripts/run.pl --compile ; ";
    }

    execute($cmd, 1);
    exit(0);
}

if ("" ne $getimm) {
  kutils::getImmInstrs($debugprint, $getimmdiff);
  exit(0);
}

if ("" ne $getmem) {
  kutils::getMemInstrs();
  exit(0);
}


open( my $fp, "<", $file ) or die "cannot open: $!";
my @lines      = <$fp>;


## Git diff
if ( "" ne $gitdiff ) {
    for my $opcode (@lines) {
        chomp $opcode;
          
        if(0 == checkSuppOrManuallyGen($opcode, $debugprint)) {
          next;
        }

        my $koutput = "$derivedInstructions/x86-${opcode}.k";

        execute("git diff  $koutput");
    }
}

## Git add
if ( "" ne $gitadd ) {
    for my $opcode (@lines) {
        chomp $opcode;
         
        if(0 == checkSuppOrManuallyGen($opcode, $debugprint)) {
          next;
        }

        my $filesToAdd = "";
        my $specfile   = "$specdir/x86-semantics_${opcode}_spec.k";
        my $specout    = "$specdir/x86-semantics_${opcode}_spec.output";
        my $koutput    = "$derivedInstructions/x86-${opcode}.k";

        if ( $speconly eq "" ) {
            $filesToAdd = "$specfile $specout $koutput";
        }
        else {
            $filesToAdd = $specfile;
        }
        execute("git add $filesToAdd");
    }
}

## Git checkout
if ( "" ne $gitco ) {
    for my $opcode (@lines) {
        chomp $opcode;
        
        if(0 == checkSuppOrManuallyGen($opcode, $debugprint)) {
          next;
        }

        my $filesToRestore = "";
        my $specfile   = "$specdir/x86-semantics_${opcode}_spec.k";
        my $specout    = "$specdir/x86-semantics_${opcode}_spec.output";
        my $koutput    = "$derivedInstructions/x86-${opcode}.k";

        if ( $speconly eq "" ) {
            $filesToRestore = "$specfile $specout $koutput";
        }
        else {
            $filesToRestore = $specfile;
        }
        execute("git checkout $filesToRestore");
    }
}

## Create a spec file
if ( "" ne $createspec ) {
    for my $opcode (@lines) {
        chomp $opcode;

        if(0 == checkSuppOrManuallyGen($opcode, $debugprint)) {
          next;
        }

        kutils::createSpecFile( $opcode, $strata_path, $specdir,
            $instantiated_instr_path, $debugprint );
        print "\n";
    }
}

## Run krpove on spec file
if ( "" ne $kprove ) {
    for my $opcode (@lines) {
        chomp $opcode;

        if(0 == checkSuppOrManuallyGen($opcode, $debugprint)) {
          next;
        }

        kutils::runkprove( $opcode, $specdir, $debugprint );
        print "\n";
    }
}

## Post process
if ( "" ne $postprocess ) {
    for my $opcode (@lines) {
        chomp $opcode;

        if(0 == checkSuppOrManuallyGen($opcode, $debugprint)) {
          next;
        }

        kutils::postProcess( $opcode, $specdir, $derivedInstructions,
            $debugprint );
        print "\n";
    }
}

if ( "" ne $all ) {
    for my $opcode (@lines) {
        chomp $opcode;

        if(0 == checkSuppOrManuallyGen($opcode, $debugprint)) {
          next;
        }

        kutils::createSpecFile( $opcode, $strata_path, $specdir,
            $instantiated_instr_path, $debugprint );
        kutils::runkprove( $opcode, $specdir, $debugprint );
        kutils::postProcess( $opcode, $specdir, $derivedInstructions,
            $debugprint );
        print "\n";
    }
}

sub checkSuppOrManuallyGen {
  my $opcode = shift @_;
  my $debugprint = shift @_;

  my ( $isSupported, $reason ) =
    kutils::checkSupported( $opcode, $strata_path, $derivedInstructions,
      $debugprint );
  if ( 0 == $isSupported ) {
      utils::warnInfo("$opcode: $reason");
      return 0;
  }
  if ( "" ne $reason ) {
      utils::warnInfo("$opcode: $reason");
  }

  my $isManuallyGenerated =
    kutils::checkManuallyGenerated( $opcode, $debugprint );
  if ( 1 == $isManuallyGenerated ) {
      utils::warnInfo("$opcode: Manually Generated");
      return 0;
  }

  return 1;
}


if ( "" ne $checksanity ) {
    my @reqs    = ();
    my @imports = ();
    my @syntaxs = ();

    my @patterns = (
        "bitwidthMInt",             "plugInMask",
        "extractMask",              "zeroExtend",
        "signExtend",               "splitVectorHelper",
        "minFloat",                 "maxFloat",
        "Float2MInt\\\(MInt2Float", "MInt2Float\\\(Float2MInt",
        "_\\\\s+",                  "regstate",
    );

    my $antipattern = "convTo\|CF\|ZF\|SF\|PF\|OF\|AF";

    for my $opcode (@lines) {
        chomp $opcode;
        my ( $isSupported, $reason ) =
          kutils::checkSupported( $opcode, $strata_path, $derivedInstructions,
            $debugprint );
        if ( 0 == $isSupported ) {
            utils::warnInfo("$opcode: $reason");
            next;
        }
        if ( "" ne $reason ) {
            utils::warnInfo("$opcode: $reason");
        }

        my $koutput = "$derivedInstructions/x86-${opcode}.k";

        utils::info("$opcode: Check Sanity");
        for my $pattern (@patterns) {
            my $matches_ref = utils::myGrep( $pattern, "sdasgup3", $koutput );
            my @matches = @{$matches_ref};

            if ( ( $pattern eq "regstate" ) ) {
                if ( ( scalar(@matches) == 0 ) ) {
                    utils::failInfo("$pattern: $koutput");
                }
            }
            elsif ( scalar(@matches) > 0 ) {
                utils::failInfo("$pattern: $koutput");
            }
        }

        my $matches_ref = utils::myGrep( "\\|->", $antipattern, $koutput );
        my @matches = @{$matches_ref};
        if ( scalar(@matches) > 0 ) {
            utils::failInfo( "Scratch Pad:" . $koutput );
        }

        print "\n";
    }
}

## Get the stratum and num of instr of a particular circuit
if ( "" ne $stratum ) {
    if ( "" eq $strata_path ) {
        info(" Need-- strata_path ");
        exit(0);
    }

    #info(" Using strata_path = $strata_path ");
    for my $opcode (@lines) {
        chomp $opcode;
        my ( $depth, $count ) =
          kutils::find_stratum( $opcode, $strata_path, $debugprint );
        print " \n $opcode" . " \t " . $depth . " \t " . $count . " \n ";
    }
    exit(0);
}

## Get the read/write reg set
if ( "" ne $readmod ) {

    #info(" Using strata_path = $strata_path ");
    for my $opcode (@lines) {
        chomp $opcode;
        my ( $instr, $metadata, $rwset ) =
          kutils::getReadMod( $opcode, $instantiated_instr_path, $debugprint );
        print " \n $opcode" . " \n "
          . $instr . " \n "
          . $metadata . " \n "
          . $rwset . " \n ";
    }
    exit(0);
}

## Get all the registers involved in a circuit
if ( "" ne $getoplist ) {

    #info(" Using strata_path = $strata_path ");
    for my $opcode (@lines) {
        chomp $opcode;
        my $opList = kutils::getOpList( $opcode, $strata_path, $debugprint );
        print $opList;
    }
    exit(0);
}
