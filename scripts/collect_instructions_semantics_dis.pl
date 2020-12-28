#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use File::Compare;
use File::Basename;
use File::Temp qw/ tempfile tempdir /;
use Cwd 'abs_path';

BEGIN {
    my $script_path = dirname( abs_path($0) );
    unshift @INC, $script_path;
}
use kutils;
use utils;

my $help        = "";
my $file        = "";
my $script_path = dirname( abs_path($0) );
my $baseDir     = "$script_path/../semantics";
my $regDir      = $baseDir . "/registerInstructions/";
my $immDir      = $baseDir . "/immediateInstructions/";
my $memDir      = $baseDir . "/memoryInstructions/";
my $sysDir      = $baseDir . "/systemInstructions/";
my $extraDir    = $baseDir . "/extras/";
my $target      = $baseDir . "/underTestInstructions/";

GetOptions(
    "help"   => \$help,
    "file:s" => \$file,
) or die("Error in command line arguments\n");

if ($help) {
    print("");
    exit(1);
}

if ( $help ne "" or $file eq "" ) {
    print "Usage: collect_instructions_semantics.pl --file test.s\n";
    exit(0);
}

open( my $fp, "<", $file ) or die "Can't open $file: $!";
my @lines     = <$fp>;
my %opcodeMap = ();

for my $line (@lines) {
    chomp $line;
    $line = utils::trim($line);

    # if ( $line =~ m/:/ ) {
    #     print("skipping line : $line\n");
    #     next;
    # }

    if ( $line =~
m/\.type|\.size|\.ident|\.align|\.weak|\.local|\.file|\.p2align|\.cfi\_|\.text|\.file|\.section|\.quad|\.value|\.long|\.zero|\.globl|\.comm|\.string|\.data|\.byte|\.bss|\.ascii|\.asciz|\.set/
      )
    {
        print("skipping line : $line\n");
        next;
    }

    if ( $line =~ m/0x[0-9a-fA-F]*:\s*0x[0-9a-fA-F]+\s*(\w*)/g ) {
        print "match : $1\n";
        $opcodeMap{ "rep_" . $1 } = "";
        $opcodeMap{$1} = "";
        next;
    }

    my $opcode = $line =~ s/\s.*//gr;
    if ( "" ne $opcode ) {

        if ( $opcode eq "leave" ) {
            $opcodeMap{"popq"} = "";
        }

        $opcodeMap{$opcode} = "";
    }

}

for my $opcode ( keys %opcodeMap ) {
    print $opcode . "\n";
    populate($opcode);
}

sub populate {
    my $opcode = shift @_;
    my $doit   = shift @_;

    if ( $opcode eq "" || $opcode eq "//" ) {
        return;
    }

    execute(
"cp $regDir/$opcode* $immDir/$opcode* $memDir/$opcode* $sysDir/$opcode* $target 1> /dev/null 2>&1",
        $doit
    );

    my $varb = $opcode . "b";
    my $varw = $opcode . "w";
    my $varl = $opcode . "l";
    my $varq = $opcode . "q";

    execute(
"cp $regDir/$varb* $immDir/$varb* $memDir/$varb* $sysDir/$varb* $target 1> /dev/null 2>&1",
        $doit
    );
    execute(
"cp $regDir/$varw* $immDir/$varw* $memDir/$varw* $sysDir/$varw* $target 1> /dev/null 2>&1",
        $doit
    );
    execute(
"cp $regDir/$varl* $immDir/$varl* $memDir/$varl* $sysDir/$varl* $target 1> /dev/null 2>&1",
        $doit
    );
    execute(
"cp $regDir/$varq* $immDir/$varq* $memDir/$varq* $sysDir/$varq* $target 1> /dev/null 2>&1",
        $doit
    );

    execute( "cp $extraDir/* $target        1> /dev/null 2>&1", $doit );
    execute( "cp $sysDir/callq* $target     1> /dev/null 2>&1", $doit );
    execute( "cp $sysDir/jmpq* $target      1> /dev/null 2>&1", $doit );
    execute( "cp $sysDir/retq.k* $target    1> /dev/null 2>&1", $doit );
    execute( "cp $sysDir/leaveq.k* $target  1> /dev/null 2>&1", $doit );

    execute( "rm  $target/cmpl_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/cmpq_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/cmpw_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/addl_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/addw_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/andw_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/orw_*imm8*      1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/xorw_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/imulw_*imm8*    1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/subl_*imm8*      1> /dev/null 2>&1",   $doit );
    execute( "rm  $target/subw_*imm8*      1> /dev/null 2>&1",   $doit );
    execute( "rm  $target/addq_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/adcq_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/andq_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/andl_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/leaq_*m16*      1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/leaq_*m32*      1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/movq_r64_imm32.k   1> /dev/null 2>&1", $doit );
    execute( "rm  $target/xorq_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/subq_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/xorl_*imm8*     1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/orl_*imm8*      1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/orq_*imm8*      1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/pushq_*imm8*    1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/pushq_*imm16*   1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/imulq_*imm8*    1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/imull_*imm8*    1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/*_rax_*         1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/*_eax_*         1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/*_ax_*          1> /dev/null 2>&1",    $doit );
    execute( "rm  $target/*_al_*          1> /dev/null 2>&1",    $doit );

}

exit;
