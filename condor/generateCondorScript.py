import os
import sys

## Process the command line arguments
#
#
def getArgs():
  args = {}

  args['repoPath'] = os.path.dirname(os.path.abspath(__file__)) + '/..'
  args['condorTemplate'] = args['repoPath'] + '/condor/template.con'

  args['args'] = args['repoPath']
  for elem in sys.argv[1:]:
    args['args'] += ' ' + elem

  return args


def getCondorFile(args):
  newFileAsStr = ''
  with open(args['condorTemplate'], 'r') as f:
    for line in f:
      if (line.startswith('RepoPath')):
        newFileAsStr += 'RepoPath = ' + args['repoPath'] + '\n'
      elif (line.startswith('Arguments')):
        newFileAsStr += 'Arguments = "' + args['args'] + '"\n'
      else:
        newFileAsStr += str(line)

  return newFileAsStr


args = getArgs()
newFileAsStr = getCondorFile(args)
print(newFileAsStr)
