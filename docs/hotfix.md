```
x.y.z
```

x = major version number

y = minor version number

z = patch version number

As mentioned on the [Release Process](release.md) page,
hotfixes and emergency patches are released by bumping the patch version number.


# Fixing Problems

## Why Hotfixes are Necessary

A hotfix refers to a short-term quick fix for a problem with something
running in production.

To understand why hotfixes are necessary, consider the following scenario:
suppose you cut a release `1.4.y`, and a group of users adopts that version
and starts using it in production.

Separately, suppose you develop several major features and you cut a new major
release, `2.x`. Going forward, you would prefer if everyone adopted the `2.x`
branch, and all future development will focus on `2.x` (there will not be a `1.5`),
but you still have users using `1.4.y` in production.

## Hotfix Scenario

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

* The fix for 1.4.0 fixes something that no longer applies in 2.0.0 (one-off hotfix)
* The fix for 1.4.0 fixes something that is still in 2.0.0 (upstream hotfix)


## Prepare to Apply Hotfix

Whichever approach you are going to use, you will need to create a starting branch.

Create a new branch starting at the commit that the v1.4 tag points to.

Here's how to do that:

Start by making sure you have the latest tags:

```
git fetch --all --tags
```

Assuming your working directory is clean, you should be able to check out the
tag you want to apply the hotfix to:

```
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


## One-Off Hotfix

The following procedure is for a fix to version 1.4.y that does not affect version 2.x.

### Step 1: Create Hotfix Branch

Starting from branch `release/v1.4`, create a new hotfix branch. Here, we call it
`hotfix/v1.4/fix-typos` but that naming convention is arbitrary:

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

### Step 2: Make Commits to Hotfix Branch

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

This branch should also bump the patch version number
using the make rule:

```
make bump_patch_version
```

For example, if the original tag v1.4 pointed to the 1.4.0 commit,
then the hotfix should bump the patch version to 1.4.1.

(Update the CHANGELOG too.)

### Step 3: Merge Hotfix to Release Branch

Once all commits have been added to the hotfix and it is ready to merge back into
the release branch, open a pull request to merge `hotfix/v1.4/fix-typos` into 
`release/v1.4`.

Once the PR is opened, reviewed, approved, and merged, the git diagram will look like this:

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

Now, from the `release/v1.4` branch, run the release script,
but because this is fixing a version that is no longer the
latest version, we should only create a git tag for the
new release, we should not cut that release to main.

```
make release_tag
```

### Step 4: Bump Version

You are ready to run bump2version to bump the patch version, `1.4.0` to `1.4.1`,
and update the `v1.4` git tag to point to the new commit:

```
make bump_patch_version
```

(Note: we do not want to cut a release to main, because a newer version has already
been cut to main.)


## Upstream HotFix

Now let's walk through how to deploy a hotfix that affects both 1.4.0 and 2.0.0.

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

### Step 1: Create Hotfix Branch from Common Ancestor

We check out the hotfix branch directly from that common ancestor's git tag:

```
git fetch --all --tags
git checkout tags/v1.4 -b hotfix/fix-typos
```

### Step 2: Make Commits to Hotfix Branch

Contribute fixes to the hotfix branch with `git commit` commands:

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


### Step 3: Merge Fixes to Older Version

Now we have to merge the hotfix changes into the tagged prior versions,
and bump the version number, and if this is the latest branch, cut a new
release to main.

Start by fetching all the tags:

```
git fetch --all --tags
```

Now check out the tag for the older version, 1.4. Create a new release branch:

```
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

### Step 4: Bump Version on Older Version

Now run bump2version to bump the patch version, `1.4.0` to `1.4.1`,
and update the `v1.4` git tag to point to the new commit:

```
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
              \--------------o---o
                                 | release/v1.4
                                 |
                                 |
                                 tag:v1.4
```


### Step 5: Merge Fixes Upstream to Newer Version

Similarly, the hotfix can be merged into v2.0.

Start by fetching all the tags:

```
git fetch --all --tags
```

Now check out the tag for the newer version, 2.0. Create a new release branch:

```
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
              \--------------o---o
                                 | release/v1.4
                                 |
                                 |
                                 tag:v1.4
```

### Step 6: Bump Version on Upstream

Now run bump2version to bump the patch version, `2.0.0` to `2.0.1`,
and update the `v2.0` git tag to point to the new commit:

```
make bump_patch_version
```

This results in:

```
                                 tag:v2.0
                                 |
                                 |
                                 | release/v2.0
              o--o--o--------o---o
             /              /
o--o--o--o--o--------o--o--o hotfix/fix-typos
             \              \
              \--------------o---o
                                 | release/v1.4
                                 |
                                 |
                                 tag:v1.4
```

Finally, because this is the latest version, run make release to cut
the newest release to the main branch:

```
make release
```

This results in the v2.0 tag being cut to main:

```
                                 main
                                 tag:v2.0
                                 |
                                 |
                                 | release/v2.0
              o--o--o--------o---o
             /              /
o--o--o--o--o--------o--o--o hotfix/fix-typos
             \              \
              \--------------o---o
                                 | release/v1.4
                                 |
                                 |
                                 tag:v1.4
```
