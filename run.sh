#!/bin/bash -e

numOfInputs=3 ;
if test $# -lt ${numOfInputs} ; then
  echo "USAGE: $ `basename $0` binary numOfRuns numOfCores" ;
  exit 1 ;
fi

# Get args
binaryToRun="${1}" ;
numOfRuns="${2}" ;
numOfCores="${3}" ;

# Get machine name
machine="`uname -n`" ;

# Get repo dir
gitRepoDir="`git rev-parse --show-toplevel`";

# Make output dir
outputDir="${gitRepoDir}/output/${machine}/${binaryToRun}/${numOfCores}" ;
mkdir -p ${outputDir} ;

cd ${outputDir} ;

timeFile="time.txt" ;
rm -f ${timeFile} ;

outputFile="output.txt" ;
rm -f ${outputFile} ;

# fix.cs.northwestern.edu cores list
coresList=(56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100 102 104 106 108 110 57 59 61 63 65 67 69 71 73 75 77 79 81 83 85 87 89 91 93 95 97 99 101 103 105 107 109 111)

# Kill previous burnP6, just in case
killBurnP6.sh ;

# Run burnP6 on unused cores
machineCores=${#coresList[@]} ;
if [ machineCores > numOfCores ] ; then
  remainingCores=`echo "${machineCores} - ${numOfCores}" | bc` ;
  coresToRunBurnP6=${coresList[@]:${numOfCores}:${remainingCores}} ;
  runBurnP6.sh "${coresToRunBurnP6[@]}" ;
fi

coresToRunApp=${coresList[@]:0:${numOfCores}} ;
coresToRunAppAsCommaSeparatedList=$( IFS=','; echo "${coresToRunApp[*]}" ) ;
for i in $(seq 1 1 ${numOfRuns}) ; do
  export OMP_NUM_THREADS=${numOfCores} && taskset -c ${coresToRunAppAsCommaSeparatedList} ${gitRepoDir}/bin/${binaryToRun} &> ${outputFile} ;
  time=`cat ${outputFile} | grep "Time in seconds" | awk '{ print $5 }'` ;
  echo "${time}" >> ${timeFile} ;
done

# Kill burnP6 processes at the end
killBurnP6.sh ;
