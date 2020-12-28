#!/bin/bash
BUILD_DIR="build"
OBJ_FILE="$BUILD_DIR/out.o"
OBJ_FILE_HEADERS="$BUILD_DIR/out_headers.o"

mkdir -p $BUILD_DIR

as $1 -o $OBJ_FILE
objdump -h $OBJ_FILE > $OBJ_FILE_HEADERS
