#!/bin/bash
SEMANTICS_DIR="/home/axel/Documents/FV_boot/X86-64-semantics/semantics"
SCRIPTS_DIR="/home/axel/Documents/FV_boot/X86-64-semantics/scripts"
CURRENT_DIR="/home/axel/Documents/FV_boot/X86-64-semantics/tests/kernel-tests/ljmp"

CONFIG_FILE="$SEMANTICS_DIR/x86-configuration.k"
DUT="$CURRENT_DIR/ljmp.dis"
K_OUTPUT="$CURRENT_DIR/ljmp.out"

ENTRY_POINT_REGEX="<entrypoint> mi\(64, \d+\s*\)"
ENTRY_POINT_REPLACEMENT="<entrypoint> mi\(64, 4198400\)"
EXIT_POINT_REGEX="<exitpoint> mi\(64, \d+\s*\)"
EXIT_POINT_REPLACEMENT="<exitpoint> mi\(64, 4198420\)"
PROCESSOR_MODE_REGEX="<processormode> b\d+"
PROCESSOR_MODE_REPLACEMENT="<processormode> b64"


# modify the configuration to have correct entry and exit points

function check_existence {
    grep -q $3 "$1" $2
    if [ $? -eq 1 ]
    then
        echo "couldn't match regex $1 in $2"
        exit 1
    fi
}

check_existence "$ENTRY_POINT_REGEX" $CONFIG_FILE -P
check_existence "$EXIT_POINT_REGEX" $CONFIG_FILE -P
check_existence "$PROCESSOR_MODE_REGEX" $CONFIG_FILE -P

perl -pi.bak -e "s/$ENTRY_POINT_REGEX/$ENTRY_POINT_REPLACEMENT/g" $CONFIG_FILE
perl -pi.bak -e "s/$EXIT_POINT_REGEX/$EXIT_POINT_REPLACEMENT/g" $CONFIG_FILE
perl -pi.bak -e "s/$PROCESSOR_MODE_REGEX/$PROCESSOR_MODE_REPLACEMENT/g" $CONFIG_FILE

$SCRIPTS_DIR/collect_instructions_semantics_dis.pl --file $DUT > /dev/null 2>&1 &&
echo "Kompiling"
$SCRIPTS_DIR/kompile.pl --backend java &&
echo "Krunning"
krun $DUT > $K_OUTPUT

EXPECTED_BASE="\"GDTR_BASE\" |-> 64'4202496"
EXPECTED_LIMIT="\"GDTR_LIMIT\" |-> 16'15"
EXPECTED_CS="\"CS\" |-> 64'9174325022162944"
EXPECTED_RAX="\"RAX\" |-> 64'2"
check_existence "$EXPECTED_BASE" $K_OUTPUT
check_existence "$EXPECTED_LIMIT" $K_OUTPUT
check_existence "$EXPECTED_CS" $K_OUTPUT
check_existence "$EXPECTED_RAX" $K_OUTPUT

echo "Check succesfull"
exit 0