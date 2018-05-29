#!/usr/bin/perl

# Common includes
use strict;
use warnings;
use Getopt::Long;
use File::Compare;
use File::Basename;

#use File::chdir;
use Cwd;
use File::Path qw(make_path remove_tree);
use lib qw( /home/sdasgup3/scripts-n-docs/scripts/perl/ );
use utils;
use lib qw( /home/sdasgup3/x86-semantics/scripts/ );
use kutils;
use File::Find;

#use File::chdir;
use Cwd;
use threads;

# Using GetOPtions
my $kfile      = "";
my $opcode     = "";
my $type       = "";
my $help       = "";
my $debugprint = 0;

my %scheduleInstructionsList = (
    "xchgb_r8_r8"      => 1,
    "xchgb_r8_rh"      => 1,
    "xchgb_rh_r8"      => 1,
    "xchgb_rh_rh"      => 1,
    "xaddb_r8_r8"      => 1,
    "xaddb_r8_rh"      => 1,
    "xaddb_rh_r8"      => 1,
    "xaddb_rh_rh"      => 1,
    "xaddl_r32_r32"    => 1,
    "xaddq_r64_r64"    => 1,
    "xaddw_r16_r16"    => 1,
    "cmpxchgb_r8_r8"   => 1,
    "cmpxchgb_r8_rh"   => 1,
    "cmpxchgb_rh_r8"   => 1,
    "cmpxchgb_rh_rh"   => 1,
    "cmpxchgl_r32_r32" => 1,
    "cmpxchgq_r64_r64" => 1,
    "cmpxchgw_r16_r16" => 1,
);

my %opcodeSkipList = (    # Reason of manual generation
    "pdepq_r64_r64_r64" => 1,    # impractically huge strata formula.
    "pdepl_r32_r32_r32" => 1,
    "pextl_r32_r32_r32" => 1,    # Difficlt to write the semantics in handlers
    "pextq_r64_r64_r64" => 1,

    "movmskpd_r64_xmm"  => 1,    # Huge strata formula.
    "vmovmskpd_r64_xmm" => 1,
    "vmovmskpd_r64_ymm" => 1,
    "vmovmskpd_r32_xmm" => 1,
    "vmovmskpd_r32_ymm" => 1,
    "movmskpd_r32_xmm"  => 1,
    "xchgl_eax_r32"     => 1,    # Schedule instruction;
    "xchgl_r32_eax"     => 1,
    "xchgl_r32_r32"     => 1,
    "xchgq_r64_r64"     => 1,
    "xchgq_r64_rax"     => 1,
    "xchgq_rax_r64"     => 1,
    "xchgw_ax_r16"      => 1,
    "xchgw_r16_ax"      => 1,
    "xchgw_r16_r16"     => 1,

);

GetOptions(
    "help"     => \$help,
    "kfile:s"  => \$kfile,
    "type:s"   => \$type,
    "opcode:s" => \$opcode,
) or die("Error in command line arguments\n");

if ( "" eq $opcode or "" eq $kfile or "" eq $type ) {
    print("--opcode --kfile -type register/memory/immediate\n");
    exit(0);
}

## Skip generating K rule for opcodeSkipList
if ( exists $opcodeSkipList{$opcode} ) {

    #print "$opcode\tSkip\n";
    utils::info("$opcode: Skip");
    exit(0);
}

my $is_schedule = 0;

#if ( exists $scheduleInstructionsList{$opcode} ) {
#    utils::info("$opcode: Schedule instruction");
#    $is_schedule = 1;
#}

my $mainSemantics = getSemantics( $opcode, $kfile, 0 );

my $auxSemantics = "";

#if ($is_schedule) {
#    $auxSemantics = getSemantics( $opcode, $kfile . ".samereg", 1 );
#}

#Outfile
my $outFile =
  "$utils::home/Github/binary-decompilation/x86-semantics/semantics/";
if ( "register" eq $type ) {
    $outFile = $outFile . "registerInstructions/$opcode.k";
}
if ( "immediate" eq $type ) {
    $outFile = $outFile . "immediateInstructions/$opcode.k";
}
if ( "memory" eq $type ) {
    $outFile = $outFile . "memoryInstructions/$opcode.k";
}

print "$opcode:\tK Rule at $outFile\n";

writeKDefn( $mainSemantics,
    $outFile, $opcode, 1, 0, 0, $is_schedule, $auxSemantics );

############################## UTILS ####################################

sub getSemantics {
    my $opcode      = shift @_;
    my $kfile       = shift @_;
    my $is_schedule = shift @_;

    # Infile
    open( my $fp, "<", $kfile ) or die "Can't open $kfile: $!";
    my @lines = <$fp>;
    close $fp;

    my $targetinstr = "";
    my $instrfolder = kutils::getInstrsFolder(
        "$utils::home/Github/strata-data/output-strata/instruction-summary",
        $type, $opcode );

    if ( !$is_schedule ) {

        # Read the Target instr
        my $countertargetinstr = "";
        for my $line (@lines) {
            chomp $line;
            if ( $line =~ m/code:(.*)/g ) {
                $countertargetinstr = utils::trim($1);
            }
        }

        $targetinstr =
          kutils::getTargetInstr( $opcode, $debugprint, $instrfolder );

        if ( $countertargetinstr ne $targetinstr ) {
            print "CounterInstr: "
              . $countertargetinstr . "\n"
              . "TargetInstr: "
              . $targetinstr . "\n";
            failInfo("CheckPoint 1");
        }
    }
    else {
        $targetinstr = kutils::getTargetInstr( $opcode . ".samereg",
            $debugprint, $instrfolder );
    }

    print "Target: $targetinstr\n";

    # Get the operands and association with dummy registers R1, R2, ...
    my $operandListFromOpcode_ref =
      getOperandListFromOpcode( $opcode, $debugprint );
    my $operandListFromInstr_ref =
      getOperandListFromInstr( $targetinstr, $debugprint );

    my $actual2psedoRegs_ref =
      getDummyRegsForOperands( $operandListFromOpcode_ref,
        $operandListFromInstr_ref );
    my %actual2psedoRegs = %{$actual2psedoRegs_ref};
    utils::printMap( $actual2psedoRegs_ref, "ActualToPseduRegs", $debugprint );

    #printArray($operandListFromOpcode_ref);
    #printArray($operandListFromInstr_ref);
    my $semantics =
      sanitizeBVF( $opcode, \@lines, $actual2psedoRegs_ref, $debugprint );

    #print $semantics. "\n";
    return $semantics;
}
