#!/bin/bash

trg=$(mktemp --tmpdir "kstat_$(date -I)_XXXX.7z")
rm -f "$trg" # delete, otherwise 7z complains
7z a "$trg" kstat.html kstat_files/

echo "7zipped to $trg"
echo "ln -s kstat.html index.html"
