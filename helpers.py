#!/usr/bin/env python3

import sys
import os
import argparse
import filecmp
import pickle

# helpers.py is my file for any helper functions used.
# Edwin Tang (z5482091)
# Implementation ===============================================================

grip = '.grip'
statfile = '.grip/stat'
commitDir = '.grip/commits'
currState = '.grip/curr'
defaultBranch = '.grip/commits/trunk'

# Custom subclass wrapper for Argparse to rewrite exit and error behaviour
class ArgumentParser(argparse.ArgumentParser):
    def exit(self, status=0, message=None):
        if status != 0:
            self.error()
        sys.exit(status)

    def error(self, message=None):
        self.print_usage(sys.stderr)
        sys.exit(1)
    
    def parse_args(self, args=None, namespace=None):
        try:
            args, argv = self.parse_known_args(args, namespace)
            if argv:
                msg = 'unrecognized arguments: %s'
                self.error(msg % ' '.join(argv))
            return args
        except Exception as e:
            self.error(e)

# Function that prints out error in the correct place given sys.argv[0]
def eprint(argv, string):
    print(f"{os.path.basename(argv)}: error: {string}", file=sys.stderr)

# Function that verifies that grip directory exists, and so does its sub directories
def verifyGrip(fileName):
    if not os.path.exists(grip):
        print(f"{os.path.basename(fileName)}: error: grip repository directory .grip not found")
        sys.exit(1)
    if not os.path.exists(commitDir):
        os.mkdir(commitDir)
    if not os.path.exists(currState):
        os.mkdir(currState)

# Function that fetches all directories in a given path
def getDir(path):
    return [f for f in os.listdir(path) if os.path.isdir(f"{path}/{f}")]

# Function that fetches all files in a given path
def getFiles(path):
    return [f for f in os.listdir(path) if os.path.isfile(f"{path}/{f}")]

# Function that fetches all commits / sub directories (2 layers nesting)
def getCommits(path):
    tempFiles = getDir(path)
    files = []
    for i in tempFiles:
        files += list(map(lambda x: i + '/' + x, getDir(f"{path}/{i}")))
    return files
        

# Function that compares files in three paths and returns string of message
# Returns None if no error msg
# Returns if 'file' in index is different to both the working file and the repository
# Returns if 'file' has staged changes in the index
# Returns if 'file' in the repository is different to the working file

# - If cwd doesn't exist, but commit and index are same - no error
# - If cwd doesn't exist, but commit and index are different - no error

# - If commit doesn't exist, but index does - error: 'FILE' has staged changes in the index
# - If commit doesn't exist and neither does index - error: 'FILE' is not in the grip repository
# - All three exists, we can do simple comparison
# - if cwd is same as commit but diff to index
def tripleFileCmp(cwd, index, commit, cached):
    if not os.path.exists(cwd):
        return None
    if not os.path.exists(commit):
        if not filecmp.cmp(cwd, index, shallow=True):
            return f"'{cwd}' in index is different to both the working file and the repository"
        elif not cached:
            return f"'{cwd}' has staged changes in the index"
        else:
            return None
    # NOW ALL THREE FILES SHOULD EXIST
    cwdIndexCMP = not filecmp.cmp(cwd, index, shallow=True)
    cwdCommitCMP = not filecmp.cmp(cwd, commit, shallow=True)
    indexCommitCMP = not filecmp.cmp(index, commit, shallow=True)
    if cwdIndexCMP and indexCommitCMP:
        # All three versions of the file are different
        return f"'{cwd}' in index is different to both the working file and the repository"
    if cwdIndexCMP and cwdCommitCMP:
        # CWD is different to index and commit, but index and commit are the same
        if cached:
            return None
        else:
            return f"'{cwd}' in the repository is different to the working file"
    if indexCommitCMP:
        if cached:
            return None
        else:
            return f"'{cwd}' has staged changes in the index"
    return None

# Function that determines the statuses for a given file
def determineStatus(cwd, index, commit):
    statuses = []
    if cwd and not index and not commit:
        statuses.append("untracked")
    if index and not commit:
        statuses.append("added to index")
    if cwd:
        # File changed
        if index and not commit:
            if not filecmp.cmp(cwd, index, shallow=True):
                statuses.append("file changed")
        elif index and commit:
            cwdIndex = filecmp.cmp(cwd, index, shallow=True)
            cwdWorkspace = filecmp.cmp(cwd, commit, shallow=True)
            indexWorkspace = filecmp.cmp(index, commit, shallow=True)
            if not cwdIndex and not cwdWorkspace:
                statuses.append("file changed")
            elif not indexWorkspace:
                statuses.append("file changed")
    else:
        # File Deleted
        if index or commit:
            statuses.append("file deleted")
    if not index and commit:
        statuses.append("deleted from index")
    # Changes not staged to commit
    if cwd:
        if commit:
            cwdIndex = filecmp.cmp(cwd, index, shallow=True) if index else False
            cwdWorkspace = filecmp.cmp(index, commit, shallow=True) if index else False
            if not cwdIndex and cwdWorkspace:
                statuses.append("changes not staged for commit")
    # Changes staged for commit
    if not cwd and index and commit:
        if not filecmp.cmp(index, commit, shallow=True):
            statuses.append("changes staged for commit")
    if cwd and index and commit:
        cwdIndex = filecmp.cmp(cwd, index, shallow=True)
        cwdWorkspace = filecmp.cmp(cwd, commit, shallow=True)
        indexWorkspace = filecmp.cmp(index, commit, shallow=True)
        if cwdIndex and cwdWorkspace and indexWorkspace:
            statuses.append("same as repo")
        elif not cwdIndex and not cwdWorkspace and not indexWorkspace:
            statuses.append("different changes staged for commit")
        elif not indexWorkspace:
            statuses.append("changes staged for commit")
    return statuses

# Fetches the branch we are currently on
def fetchGenInfo():
    if os.path.exists(statfile):
        with open(statfile, 'rb') as f:
            genInfo = pickle.load(f)
        if not genInfo.get('currBranch'):
            with open(statfile, 'wb') as f:
                genInfo = {'currBranch': defaultBranch}
                pickle.dump(genInfo, f)
            return defaultBranch
        else:
            return genInfo["currBranch"]
    else:
        with open(statfile, 'wb') as f:
            genInfo = {'currBranch': defaultBranch}
            pickle.dump(genInfo, f)
        return defaultBranch

# Takes the new path and writes to the gen info file
def writeGenInfo(path):
    if os.path.exists(statfile):
        with open(statfile, 'rb') as f:
            genInfo = pickle.load(f)
        genInfo['currBranch'] = path
        with open(statfile, 'wb') as f:
            pickle.dump(genInfo, f)
        return
    else:
        genInfo = {'currBranch': path}
        with open(statfile, 'wb') as f:
            pickle.dump(genInfo, f)
        return