# Release Process

Proper releases are done by bumping the major (breaking) or minor (non-breaking)
version numbers. Hotfixes and emergency patches are released using the patch
version number.


## Developing New Features

All development of new versions happens starting from the `develop` branch.

Starting from the `develop` branch:

```
git checkout develop
```

To add a new feature or fix a bug, create a new branch with the feature or fix.
We recommend `<name of author>-<name of feature>` but it is up to you.

```
git checkout -b chaz-new-branch
```

Now the new branch and develop branch are at the same commit:

```
      chaz-new-branch
o--o--o
      develop
```

Make changes and add commits to the new branch:

```
                        chaz-new-branch
        o--o--o--o--o--o
       /
      /
--o--o
      develop
```

Now open a pull request to merge chaz-new-branch into develop.
When the PR is merged, it will result in the following:

```
                        chaz-new-branch
        o--o--o--o--o--o
       /				\
      /					 \
--o--o--------------------o
                          develop
```

Repeat this process until you have added all features and fixes
for the next release into develop.


## Preparing for a Major/Minor Release

When develop has accumulated enough features and fixes for a new
release, create a final branch for the release of the next major or
minor version `X.Y`.

Starting from the develop branch,

```
git checkout -b prepare-release-vX.Y
```

which results in

```
        prepare-release-vX.Y
--o--o--o
        develop
```

Now you are ready to prepare changes for the final release.
Add any changes for the final release, including updating
the CHANGELOG and updating dependencies in requirements.txt files.

```
                prepare-release-vX.Y
		  o--o--o
         /
--o--o--o
        develop
```

Create a pull rrequest from this release preparation branch.
When approved and merged into develop, the develop branch will be
ready for a new release to be cut:

```
                prepare-release-vX.Y               
		  o--o--o
         /		 \
--o--o--o---------o
                  develop
```

The repo is now ready to cut a new release `X.Y` to the main branch.


## Bumping the Version Number

The repository's `develop` branch has been prepared for release `X.Y`,
so the last remaining step is to actually bump the version number.

We also want to create a git tag to easily point to this release version.

Lastly, we want to update the `main` branch to point to the latest released
version, so that when people clone it, they obtain the latest release.

There are several make rules that will bump the verison number, create a commit,
and create a git tag. We cover those below. We also show how to update the
`main` branch to point to the latest release.

### Dry Run

Do a dry run of bumping the version number to review what
changes will be made with this final commit:

```
# if bumping major version
make dryrun_bump_major_version

# if bumping minor version
make dryrun_bump_minor_version
```

This will show what a new version commit, bumped with bump2version, would look like:

```
                        hypothetical
                        bump2version
                        commit
        - - - - - - - - o                
      /
--o--o
      develop
```

### Real Run

Now create the actual commit that bumps the version,
and create a version tag:

```
# if bumping major version
make bump_major_version

# if bumping minor version
make bump_minor_version
```

This will create a new version commit with bump2version:

```
            bump2version
            commit
        ----o
      /      develop
--o--o
```

### Cut Release to Main

Finally, we will cut the release to main.

(This means that we force the main branch, whatever it currently
happens to be pointing to, to point to this latest version release.
This ensures that when people clone the repository, which clones
the default main branch, they will be cloning the latest version.)

Start with a dry run of this release operation:

```
make dryrun_release
```

If this goes okay, cut the release to main for real:

```
make release
```

The final git diagram should look like this:

```
            bump2version
            commit
        ----o
      /      develop
--o--o       main
```


## What About the Next Major/Minor Version?

Once the glow of victory from cutting the latest version to main has
faded, you will be thinking about how to proceed next. How to pick up
where you left off and start developing version X.Y+1?

Switch back to the develop branch, which was where you were right before
cutting the release to main. Pick up where you left off developing the
next version.


# Fixing Problems

## Why Hot Fixes are Necessary

A hot fix refers to a short-term quick fix for a problem with something
running in production.

To understand why hot fixes are necessary, consider the following scenario:
suppose you cut a release `1.4.0`, and a group of users adopts that version
and starts using it in production.

Separately, suppose you develop several major features and you cut a new major
release, `2.0.0`. Going forward, you would prefer if everyone adopted the `2.x`
branch, and all future development will focus on `2.x` (there will not be a `1.5.0`),
But you still have users using `1.4.0` in production, and there may be minor
problems with that version that require fixes.

## How to Deploy a Hot Fix

Suppose we have a tag for v1.4.0, which was cut some time in the past,
and since then we have created a new major version `2.0.0` and its corresponding tag.

```
                    main
					tag:v2.0.0
                    |    
              o--o--o--o--o--o
             /                develop
o--o--o--o--o
            |
            |
            tag:v1.4
```

Now suppose we need to fix something in `1.4.0` (which `tag:v1.4` points to). There are two scenarios:

* The fix for 1.4.0 fixes something that no longer applies in 2.0.0 (one-off hot fix)
* The fix for 1.4.0 fixes something that is still in 2.0.0 (upstream hot fix)

### Deploy a One-Off Hot Fix

Let's walk through the above example, where `tag:v1.4` points to `1.4.0`, and we need to deploy a fix for
that version that only affects that version (and does not affect later versions, 2.x+).

Check out the commit tagged with the prior version to be fixed (`tags/v1.4`), and create a new hotfix branch
from it (`-b hotfix/v1.4/fix-typo`):

```
git fetch --all --tags
git checkout tags/v1.4 -b hotfix/v1.4/fix-typo
```

Now the git diagram looks like this:

```
             hotfix/v1.4/fix-typo
o--o--o--o--o
            | 
            |
            tag:v1.4
```

Contribute any commits to fix the problems with version `1.4.0`:

```
                     hotfix/v1.4/fix-typo
              o--o--o
             /
o--o--o--o--o
            | 
            |
            tag:v1.4
```




