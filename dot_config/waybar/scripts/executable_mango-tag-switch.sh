#!/usr/bin/env bash
# Switch to mango tag N (1..9) by setting bitmask: 1 << (N-1).
N=$1
mask=$(( 1 << (N - 1) ))
mmsg -s -t "$mask"
