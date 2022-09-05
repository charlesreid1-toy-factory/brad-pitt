```
x.y.z
```

x = major version number

y = minor version number

z = patch version number

Normal releases are done by bumping the major version (if new changes will make
existing code backwards-incompatible), or the minor version (if new changes will
not break existing code).

Hotfixes and emergency patches are released by bumping the patch version number.
These can complicate the branches, so we treat them separately. See
[Hotfixes](hotfixes.md).


# Best Case Scenario

Let's run through what the steps to cut a new release look like
in the best case scenario.


## Develop New Features

All development of new versions happens starting from the `develop` branch.

Users start from the `develop` branch:

```
git checkout develop
```

(Assuming a clean working directory, and after pulling latest changes.)

To add a new feature or fix a bug, create a new branch with the feature or fix
(we recommend naming it `<name of author>-<name of feature>`):

```
git checkout -b chaz-new-branch
```

The diagram of the git repository looks like this:

```
      chaz-new-branch
o--o--o
      develop
```

Make commits on the new branch to develop the feature. When finished, the
diagram of the git repository looks like this:

```
                        chaz-new-branch
        o--o--o--o--o--o
       /
      /
--o--o
      develop
```


## Open, Review, and Merge Pull Request

Now open a PR to merge `chaz-new-branch` into `develop`.

This PR will be reviewed, possibly with changes requested, and finally it will
be merged into `develop`.

When the PR is merged, the digram of the git repository will look like this:

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

When develop has accumulated enough features and fixes for a new release,
the code is frozen. A final pull request is opened against `develop`.
This final pull request will prepare for the new release by updating
the following:

* Updating CHANGELOG
* Updating dependencies in requirements.txt
* Updating version number with bumpversion

For example, if the branch preparing for release `X.Y` were called
`release-prep-vX.Y` then the git diagram would look like this:

```
                release-prep-vX.Y
		  o--o--o
         /
--o--o--o
        develop
```

We are now ready to bump the version number with `bump2version`. There are
several make rules provided to do that (the `dryrun` rule just prints what
`bump2version` would change, the other rule makes the change and commits it).

```
# if bumping major version
make dryrun_bump_major_version
make bump_major_version

# if bumping minor version
make dryrun_bump_minor_version
make bump_minor_version
```

Create a PR from this release preparation branch, have the PR reviewed, and
merge it into `develop`:

```
                release-prep-vX.Y
		  o--o--o
         /		 \
--o--o--o---------o
                  develop
```

We are almost done, but still need to officially release the new version.


### Run Release Script

Once the final version is merged to `develop`, the last step is to run
the `scripts/release.sh` script from the `develop` branch.

The release script does two things:

* Creates a git tag for the new commit to allow referencing it by version number

* Cuts a new release to main (in other words, force the main (default) branch to
  point to this commit, so that when people clone the repo, they get this latest
  version)

The release script takes two arguments:

* The source (promote from) branch, usually `develop`
* The destination (promote to) branch, usually `main`

If those are your two arguments, do a dry run of the release:

```
make dryrun_release
```

Finally, do the actual release:

```
make release
```


## Artifacts

What about uploading software artifacts, like eggs or tar files or packages?

Those tasks should be performed before running the release script, or - better -
they should be in the release script, and they should be executed before the 
git tag is created and pushed. (That way, if there is a problem creating the
artifacts, a fix can be incorporated as part of the release, or if a faulty
artifact is uploaded, the version number can be bumped as needed.)


## What About the Next Major/Minor Version?

Once the glow of victory from cutting the latest version to main has
faded, you will be thinking about how to proceed on development of the
next major or minor version. 

To start developing the next version, follow the instructions at the
beginning of this document - switch to the develop branch and start
adding features and fixes.
