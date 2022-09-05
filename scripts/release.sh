#!/bin/bash

set -euo pipefail
set -x

REMOTE="gh"

echo "Using \"${REMOTE}\" for git remote name"

if [ -z "${BRAD_PITT_HOME}" ]; then
	echo 'You must set the $BRAD_PITT_HOME environment variable to proceed.'
	exit 1
fi

# This block discovers the command line flag `--dry-run`
# and passes on positional arguments as $1, $2, etc.
if [[ $# > 0 ]]; then
    DRYRUN=
    POSITIONAL=()
    while [[ $# > 0 ]]; do
        key="$1"
        case $key in
            --dry-run)
            DRYRUN="--dry-run"
            shift
            ;;
            *)
            POSITIONAL+=("$1")
            shift
            ;;
        esac
    done
    set -- "${POSITIONAL[@]}" # restore positional parameters
fi

POSITIONAL=

############## Checks

# Check nargs
if [[ $# != 2 ]]; then
    echo "Given a source (pre-release) branch and a destination (release) branch,"
	echo "this script does the following:"
	echo " - create a git tag"
	echo " - reset head of destination branch to head of source branch"
	echo " - push result to git repo"
    echo
    echo " This script takes three arguments:"
    echo " - source_branch is a git branch available on the remote that will be promoted"
    echo " - dest_branch is the git branch that will point to the same commit that source_branch points to"
    echo
    echo "Usage: $(basename $0) source_branch dest_branch [--dry-run]"
    echo
    echo "Example: $(basename $0) release/v1.0 main"
	echo "          (this will force the main branch to point at the release/v1.0 branch)"
	echo "          (that way, cloning the repo will clone the default (main) branch, which points at v1.0)"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "You have uncommitted files in your Git repository. Please commit or stash them."
    exit 1
fi

export PROMOTE_FROM_BRANCH=$1 PROMOTE_DEST_BRANCH=$2

# Check for unpushed commits
if [[ "$(git log ${REMOTE}/${PROMOTE_FROM_BRANCH}..HEAD)" ]]; then
    echo "You have unpushed changes on your promote from branch ${PROMOTE_FROM_BRANCH}! Aborting."
    exit 1
fi

RELEASE_TAG="v$(cat VERSION)"

# Check for commits on destination branch not on source branch
if [[ "$(git --no-pager log --graph --abbrev-commit --pretty=oneline --no-merges -- $PROMOTE_DEST_BRANCH ^$PROMOTE_FROM_BRANCH)" != "" ]]; then
    echo "Warning: The following commits are present on $PROMOTE_DEST_BRANCH but not on $PROMOTE_FROM_BRANCH"
    git --no-pager log --graph --abbrev-commit --pretty=oneline --no-merges $PROMOTE_DEST_BRANCH ^$PROMOTE_FROM_BRANCH
    echo -e "\nYou must transfer them, or overwrite and discard them, from branch $PROMOTE_DEST_BRANCH."
    exit 1
fi

# Check for changes to tracked files
if ! git --no-pager diff --ignore-submodules=untracked --exit-code; then
    echo "Working tree contains changes to tracked files. Please commit or discard your changes and try again."
    exit 1
fi

############## Strap in

if [[ ${DRYRUN:-} == true ]]; then
	echo "DRY RUN DETECTED, PRINTING A DRY RUN OF ALL COMMANDS THAT WOULD HAVE BEEN RUN"
	echo
	echo "git fetch --all"
	echo "git -c advice.detachedHead=false checkout ${REMOTE}/$PROMOTE_FROM_BRANCH"
	echo "git checkout -B $PROMOTE_DEST_BRANCH"
	echo "git tag $RELEASE_TAG"
	echo "git push --force $REMOTE $PROMOTE_DEST_BRANCH"
	echo "git push --tags $REMOTE"
	echo
else
	git fetch --all
	git -c advice.detachedHead=false checkout ${REMOTE}/$PROMOTE_FROM_BRANCH
	git checkout -B $PROMOTE_DEST_BRANCH
	git tag $RELEASE_TAG
	git push --force $REMOTE $PROMOTE_DEST_BRANCH
	git push --tags $REMOTE
fi
echo "Done. Success. Thank you. Goodbye."
