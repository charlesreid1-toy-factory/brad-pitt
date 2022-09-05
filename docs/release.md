# Release Process

```
x.y.z
```

x = major version number

y = minor version number

z = patch version number

Proper releases are done by bumping the major version (if new changes will make
existing code backwards-incompatible), or the minor version (if new changes will
not break existing code).

Hotfixes and emergency patches are released by bumping the patch version number.

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

Create a pull request from this release preparation branch.
(Alternatively, merge it into `develop` directly:

```
git checkout develop
git merge --no-ff prepare-release-vX.Y
```

)

When the PR is approved and merged into develop, or when it has been manually
merged into develop, the develop branch will be ready for a new release:

```
                prepare-release-vX.Y               
		  o--o--o
         /		 \
--o--o--o---------o
                  develop
```

We can now cut a new release `X.Y` from the tip of the develop branch.


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

Either way, we will want to create a new branch starting at the commit that the v1.4 tag points to.
Here's how to do that:

```
git fetch --all --tags
git checkout tags/v1.4 -b release/v1.4
```

Now the git diagram looks like this:

```
             release/v1.4
o--o--o--o--o
            | 
            |
            tag:v1.4
```


### One-Off HotFix

Let's walk through how to deploy a fix for version 1.4.0 that only affects version 1.x and below
(and does not affect later versions, 2.x+).

Starting from branch `release/v1.4`, create a new hotfix branch:

```
git checkout -b hotfix/v1.4/fix-typos
```

Now the git diagram looks like this:

```
             hotfix/v1.4/fix-typos
             release/v1.4
o--o--o--o--o
            | 
            |
            tag:v1.4
```

Contribute typo fixes to version `1.4.0` with `git commit` commands:

```
                     hotfix/v1.4/fix-typos
               o--o--o
              /
             /
o--o--o--o--o release/v1.4
            | 
            |
            tag:v1.4
```

Once all commits have been added to the hotfix and it is ready to merge back into
the release branch, open a pull request to merge `hotfix/v1.4/fix-typos` into `release/v1.4`,
or alternatively, merge it in with the following commands:

```
git checkout release/v1.4
git merge --no-ff hotfix/v1.4/fix-typos
```

Now the git diagram looks like this:

```
                      hotfix/v1.4/fix-typos
               o--o--o
              /       \
             /         \
o--o--o--o--o ----------o
            |            release/v1.4
            |
            tag:v1.4
```

You are ready to run bump2version to bump the patch version, `1.4.0` to `1.4.1`,
and update the `v1.4` git tag to point to the new commit:

```
# start with a dry run
make dryrun_bump_patch_version

# do it really
make bump_patch_version
```

(Note: we do not want to cut a release to main, because a newer version has already
been cut to main.)


### Upstream HotFix

Now let's walk through a hotfix that affects both 1.4.0 and 2.0.0.

Revisiting the git diagram:

```
                    main
                    tag:v2.0
                    |    
              o--o--o
             /
o--o--o--o--o
            |
            |
            tag:v1.4
```

We can start at the common ancestor commit, which in this case is git tag v1.4.

We check out the hotfix branch directly from that git tag:

````
git fetch --all --tags
git checkout tags/v1.4 -b hotfix/fix-typos
```

#### Contribute Typo Fixes

Contribute typo fixes to the hotfix branch with `git commit` commands:

```
                    main
                    tag:v2.0
                    |    
              o--o--o
             /              hotfix/fix-typos
o--o--o--o--o--------o--o--o
            |
            |
            tag:v1.4
```

Now we have to merge the hotfix into any older versions that are affected
(and their version number bumped), and merge the hotfix into the latest
version if it is affected (and its version number bumped). If the latest
branch is updated, a new release should also be cut to main.

#### Merge Fixes to Older Version
#### Merge Fixes Upstream to Newer Version

Now we have to merge the hotfix changes into the tagged prior versions,
and bump the version number, and if this is the latest branch, cut a new
release to main.

Start with the oldest version:

```
git fetch --all --tags
git checkout tags/v1.4 -b release/v1.4
git merge --no-ff hotfix/fix-typos
```

which will result in this git diagram:


```
                    main
                    tag:v2.0
                    |    
              o--o--o
             /              hotfix/fix-typos
o--o--o--o--o--------o--o--o
            |\              \
            | \--------------o
            |                 release/v1.4
            tag:v1.4
```

Now run bump2version to bump the patch version, `1.4.0` to `1.4.1`,
and update the `v1.4` git tag to point to the new commit:

```
# start with a dry run
make dryrun_bump_patch_version

# do it really
make bump_patch_version
```

(Note: we do not want to cut a release to main, because a newer version has already
been cut to main.)

This results in:

```
                    main
                    tag:v2.0
                    |    
              o--o--o
             /              hotfix/fix-typos
o--o--o--o--o--------o--o--o
             \              \
              \--------------o
                             | release/v1.4
                             |
                             |
                             tag:v1.4
```

#### Merge Upstream to Newer Version

Similarly, the hotfix can be merged into v2.0:

```
git fetch --all --tags
git checkout tags/v2.0 -b release/v2.0
git merge --no-ff hotfix/fix-typos
```

This results in:

```
                    main
                    tag:v2.0
                    |         release/v2.0
              o--o--o--------o
             /              /
o--o--o--o--o--------o--o--o hotfix/fix-typos
             \              \
              \--------------o
                             | release/v1.4
                             |
                             |
                             tag:v1.4
```

Now run bump2version to bump the patch version, `2.0.0` to `2.0.1`,
and update the `v2.0` git tag to point to the new commit:

```
# start with a dry run
make dryrun_bump_patch_version

# do it really
make bump_patch_version
```

Finally, because this is the latest version, run make release to cut
the newest release to the main branch:

```
make release
```

