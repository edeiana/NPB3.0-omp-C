#!/bin/bash -e

# Get args
initialDir="${1}" ;
scriptToRun="${2}" ;
args="${@:3}" ;

# Go to repo path
cd ${initialDir} ;

# Increase stack size
source ../setup ;

# Run script (compile, run, etc.)
./${scriptToRun} ${args} ;
