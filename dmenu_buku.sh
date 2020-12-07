#!/bin/bash

buku -p -f 3 | sed 's/\t/ /g' | dmenu -i | cut -d ' ' -f 1 | xargs --no-run-if-empty buku -o

