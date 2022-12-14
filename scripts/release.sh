#!/bin/bash

set -euo pipefail
set -x

REMOTE="gh"

echo "Using \"${REMOTE}\" for git remote name"

if [ -z "${BRAD_PITT_HOME}" ]; then
	echo 'You must set the $BRAD_PITT_HOME environment variable to proceed.'
	exit 1
fi

# This block discovers the command line flags
# `--dry-run` and `--tag-only`
# and passes on positional arguments as $1, $2, etc.
if [[ $# > 0 ]]; then
    DRYRUN=
	TAGONLY=
    POSITIONAL=()
    while [[ $# > 0 ]]; do
        key="$1"
        case $key in
            --dry-run)
            DRYRUN="--dry-run"
            shift
            ;;
		    --tag-only)
            TAGONLY="--tag-only"
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

if [[ "${DRYRUN}" == "" ]]; then
	set +x
	echo "No --dry-run flag detected, performing real git actions"
	set -x
fi

if [[ "${TAGONLY}" == "" ]]; then
	set +x
	echo "No --tag-only flag detected, cutting release to main"
	set -x
fi

############## Checks

# Check nargs
if [[ $# != 2 ]]; then
	set +x
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
    echo "Usage: $(basename $0) source_branch dest_branch [--dry-run] [--tag-only]"
    echo
    echo "    --dry-run			Prints out but does not run commands"
	echo
	echo "    --tag-only        Creates the tag for the new version, but"
	echo "                      does not promote the source branch to the"
	echo "                      destination branch, or change the head of the"
	echo "                      destination branch in any way."
    echo
    echo "Example: $(basename $0) release/v1.0 main"
	echo "          (this will force the main branch to point at the release/v1.0 branch)"
	echo "          (that way, cloning the repo will clone the default (main) branch, which points at v1.0)"
    echo
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
	set +x
    echo "You have uncommitted files in your Git repository. Please commit or stash them."
    exit 1
fi

export PROMOTE_FROM_BRANCH=$1 PROMOTE_DEST_BRANCH=$2

# Check for unpushed commits
if [[ "$(git log ${REMOTE}/${PROMOTE_FROM_BRANCH}..HEAD)" ]]; then
	set +x
    echo "You have unpushed changes on your promote from branch ${PROMOTE_FROM_BRANCH}! Aborting."
    exit 1
fi

RELEASE_TAG="v$(cat VERSION)"
MIKE_TAG="$(cat VERSION | cut -d. -f1,2)"

# Check for commits on destination branch not on source branch
if [[ "$(git --no-pager log --graph --abbrev-commit --pretty=oneline --no-merges -- $PROMOTE_DEST_BRANCH ^$PROMOTE_FROM_BRANCH)" != "" ]]; then
	set +x
    echo "Warning: The following commits are present on $PROMOTE_DEST_BRANCH but not on $PROMOTE_FROM_BRANCH"
    git --no-pager log --graph --abbrev-commit --pretty=oneline --no-merges $PROMOTE_DEST_BRANCH ^$PROMOTE_FROM_BRANCH
    echo -e "\nYou must transfer them, or overwrite and discard them, from branch $PROMOTE_DEST_BRANCH."
    exit 1
fi

# Check for changes to tracked files
if ! git --no-pager diff --ignore-submodules=untracked --exit-code; then
	set +x
    echo "Working tree contains changes to tracked files. Please commit or discard your changes and try again."
    exit 1
fi

############## Artifacts

# Documentation
#
# If TAGONLY is false, we are going to cut a release to main,
# meaning the default git branch will point at this version,
# which means it should be considered the "latest".
# 
# Add the latest shortcut whenever we're cutting a release to main.

if [[ "${DRYRUN}" == "" ]]; then
	# real thing
	mkdocs build --strict --clean

	if [[ "${TAGONLY}" == "" ]]; then
		# cutting release to main, so include latest shortcut
		mike deploy -u ${MIKE_TAG} latest
	else
		mike deploy ${MIKE_TAG}
	fi

	git push ${REMOTE} gh-pages
else
	# dry run
	set +x
	mkdocs build --strict --clean

	if [[ "${TAGONLY}" == "" ]]; then
		# cutting release to main, so include latest shortcut
		echo "mike deploy -u ${MIKE_TAG} latest"
	else
		echo "mike deploy ${MIKE_TAG}"
	fi
	echo "git push ${REMOTE} gh-pages"
fi

############## Strap in

if [[ "${DRYRUN}" == "" ]]; then
	# real thing
	git fetch --all
	# This is the reason you need to have all local changes committed and pushed to the remote:
	# we are checking out a fresh, clean version of the source branch from the remote.
	git -c advice.detachedHead=false checkout ${REMOTE}/$PROMOTE_FROM_BRANCH
	if [[ "${TAGONLY}" == "" ]]; then
		# We are cutting a release to destination branch, so force the (local) destination branch
		# pointer to point to the source branch (which we checked out from remote with prior command).
		git checkout -B $PROMOTE_DEST_BRANCH
		# Force push the remote destination branch to match the local destination branch,
		# (which we forced to point to the source branch with prior command).
		git push --force $REMOTE $PROMOTE_DEST_BRANCH
	fi
	# Create and push tag from the latest version: vX.Y.Z
	git tag $RELEASE_TAG
	git push --tags $REMOTE
else
	# dry run
	set +x
	echo "DRY RUN DETECTED, PRINTING A DRY RUN OF ALL COMMANDS THAT WOULD HAVE BEEN RUN"
	echo
	echo "git fetch --all"
	echo "git -c advice.detachedHead=false checkout ${REMOTE}/$PROMOTE_FROM_BRANCH"
	if [[ "${TAGONLY}" == "" ]]; then
		echo "git checkout -B $PROMOTE_DEST_BRANCH"
		echo "git push --force $REMOTE $PROMOTE_DEST_BRANCH"
	fi
	echo "git tag $RELEASE_TAG"
	echo "git push --tags $REMOTE"
	echo
fi
set +x
echo "Done. Success. Thank you. Goodbye."
# (why is this necessary? we always end up in detached gh/develop head state)
git checkout develop
