# brad-pitt

<img alt="version-0.2.0" src="https://img.shields.io/badge/version-0.2.0-orange" />

![Brad Pitt](docs/img/brad.jpg)

This repository is a demonstration of a super simple Python
package that implements some useful features for versioned
packages:

* [mkdocs-material](https://squidfunk.github.io/mkdocs-material/)
  for markdown-based documentation
* [mkautodoc](https://github.com/tomchristie/mkautodoc)
  to automatically generate documentation of a Python API
* [bump2version](https://github.com/c4urself/bump2version/)
  for bumping versions in an automated way
* [mike](https://github.com/jimporter/mike)
  to manage mkdocs documentation for multiple versions

This repo was created from 
[audreyfeldroy/cookiecutter-pypackage](https://github.com/audreyfeldroy/cookiecutter-pypackage).


## Quick Start

First, we recommend setting up a virtual environment:

```
python -m virtualenv vp && source vp/bin/activate
```

Now install the required dependencies, then install the package:

```
pip3 install -r requirements.txt
python3 setup.py build install
```

This will install the library into the virtual environment, so you should
be able to import the provided classes (for example, `Alpha`) now:

```
$ python3

>>> from brad_pitt import Alpha
```

Installing the `brad-pitt` library also installs a command line tool
called `bp`:

```
$ bp

You are about to use the bradd-pitt library
 - Using Alpha class
 - Using Beta class
 - Brad Pitt fact: During the filming of one of his most popular movies Seven, Brad Pitt broke his arm. Instead of delaying the filming due to this unfortunate event, the director had the injury written into the script.
Congrats! You successfully used the bradd-pitt library!
```

## What is in this repo?

### Main Directories and Files

* `src/` directory: contains the source code for the `brad-pitt` library.
  This is specifically named `src/` (see `setup.py`, specifically the
  `package_dir` parameter) to avoid having the source code and the
  egg that is generated start with the same prefix, `brad_pitt`.
  (Mainly annoying from a tab completion perspective, but also redundancy.)

* `tests/` directory: contains a few minimal tests. Nothing fancy.

* `docs/` directory: contains the Markdown files for the mkdocs documentation.

### .bumpversion.cfg

(Note: the `bumpversion` library has been deprecated and replaced with `bump2version`.
You should not have to change anything, since the `requirements-dev.txt` will handle it.
Also, `bumpversion` should now point to `bump2version` on PyPI, so `pip install bumpversion`
will install `bump2version`.)

The bump2version configuration file is at `.bumpversion.cfg`.

It updates the version number in `src/__init__.py` (which is where `setup.py` gets
the version number from), and in the Readme (which contains a shield with the
version number).

It will also create a commit with the version bump, and create a new tag
that is in the form `vX.Y.Z`.

### Tests

Tests can be run with pytest:

```
pytest -vs tests/
```

## What is the point of this example?

The point is twofold:

* Presents a good pattern for having operational tooling that utilizes
  object-oriented code that can be maintained, tracked, and updated
  as part of a core library. This makes operational tooling more reliable,
  more useful, and easier to write tests for.

* Demonstrates some techniques for writing good tests, including
  having useful test utilities. Includes some good patterns from
  tests in the DSS data store.


## What is not included in this example?

Thisexample can be taken a step further.

The pattern that we are providing in this repository can be thought of as
an additional operations layer that can be added alongside an existing
library. This is useful for any software library that also has associated
infrastructure, and operational tooling is required to manage or interact
with existing resources, create new resources, or remove resources.


