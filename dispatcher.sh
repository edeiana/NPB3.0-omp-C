#!/bin/bash -e

numOfInputs=1 ;
if test $# -lt ${numOfInputs} ; then
  echo "USAGE: $ `basename $0` scriptToRun itsArgs ..." ;
  exit 1 ;
fi

# Get repo dir
gitRepoDir="`git rev-parse --show-toplevel`";

# Go to condor dir
cd ${gitRepoDir}/condor ;

# Setup python virtual env
source source-me-to-setup-python-virtual-environment ;

# Generate condor file from template.con
condorFilePrefix="${1}" ;
for elem in ${@:2} ; do
  condorFilePrefix="${condorFilePrefix}_${elem}" ;
done
condorFile=$(mktemp ./condorfile_${condorFilePrefix}_XXXXX.con) ;
python generateCondorScript.py $@ > ${condorFile} ;

# Submit condor job
condor_submit ${condorFile} ;
