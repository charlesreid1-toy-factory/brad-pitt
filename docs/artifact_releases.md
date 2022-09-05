This page covers how artifacts (such as packaged files, eggs, or documentation)
are released.

## When are artifacts created?

Tasks that create artifacts should be performed when the final release prep branch
has been merged into the `develop` branch. That merge commit will be the one that is
tagged with the new version, and will be the commit cut to main (main will point to
this commit once `make release` has been run). All artifacts should be generated
from that commit.

But also, the artifacts should be generated before the final commit is
tagged and the release cut to main, just in case something goes wrong during
the artifact generation process (although that should hopefully be unusual).

That means the artifacts should be generated from the `develop` branch,
_after_ the release prep branch is merged into `develop`, but
_before_ we have run `make release` from the `develop` branch.

## Where does it happen?

See the `scripts/release.sh` script, just before the operations that
tag the release and cut the release to main, there is a block of code
that will deploy the current documentation version to GitHub Pages.


