#!/bin/bash -e

numOfInputs=1 ;
if test $# -lt ${numOfInputs} ; then
  echo "USAGE: $ `basename $0` binary numOfRuns" ;
  exit 1 ;
fi

# Get args
binaryToRun="${1}" ;
numOfRuns="${2}" ;

# Get repo dir
gitRepoDir="`git rev-parse --show-toplevel`";

# Make output dir
outputDir="./output/${binaryToRun}" ;
mkdir -p ${outputDir} ;

cd ${outputDir} ;

timeFile="time.txt" ;
rm -f ${timeFile} ;

outputFile="output.txt" ;
rm -f ${outputFile} ;

#killBurnP6.sh ;

# Note: taskset core list is currently for piraat
#runBurnP6.sh 25 27 29 31 33 35 37 39 41 43 45 47;
#runBurnP6.sh 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100 102 104 106 108 110 ;
#runBurnP6.sh 57 59 61 63 65 67 69 71 73 75 77 79 81 83 85 87 89 91 93 95 97 99 101 103 105 107 109 111 ;

for i in $(seq 1 1 ${numOfRuns}) ; do
  #export OMP_NUM_THREADS=12 && /usr/bin/time --output=${timeFile} --append --format=%e taskset -c 1,3,5,7,9,11,13,15,17,19,21,23 ./../../bin/${binaryToRun} &>> ${outputFile} ; # piraat
  export OMP_NUM_THREADS=112 && /usr/bin/time --output=${timeFile} --append --format=%e ./../../bin/${binaryToRun} &>> ${outputFile} ; # fix
done

#killBurnP6.sh ;
