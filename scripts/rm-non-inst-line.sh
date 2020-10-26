#!/bin/bash
tmp=mktemp
cat $1 | grep -P "\w*[0-9a-fA-F]+:" > $tmp
mv $tmp $1