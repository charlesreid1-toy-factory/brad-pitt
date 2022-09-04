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

* `.bumpversion.cfg`: this configuration file is for `bump2version` (which has
  superseded `bumpversion`). This updates the version number in `src/__init__.py`
  and in `Readme.md`. By default it will create a commit and a git tag of the form
  `v0.0.0`.

* `Makefile`: provides several convenience methods for performing tasks in the repo

### Makefile

```
$ make help

clean                remove all build, test, and Python artifacts
clean-build          remove build artifacts
clean-pyc            remove Python file artifacts
clean-test           remove test and coverage artifacts
lint                 check style
docs                 generate mkdocs HTML documentation
serve-docs           serve the docs
deploy-docs          serve the docs
test                 run tests quickly with the default Python
test-all             run tests on every Python version with tox
install              install the package to the active Python's site-packages
release_major        dry run: cut a major release
release_major_real   cut a major release
release_minor        dry run: cut a minor release
release_minor_real   cut a minor release
release_patch        dry run: cut a patch release
release_patch_real   cut a patch release
```

### Tests

Tests can be run with pytest:

```
pytest -vs tests/
```


## What is the point of this example?

This example has three purposes:

* The first purpose is to show yet another Python package example. There is no one way to
  create a Python package, so additional examples implementing additional features
  (or disabling unneeded features) can help benfit others in deciding how to package
  their own Python code. (These are also ***toy repositories***, and implementing too many
  features or best practices can be too overwhelming!)

* The second purpose is to demonstrate best practices for Python libraries that will have
  new versions released frequently, and show how to preserve documentation for prior
  versions alongside documentation for the current version.

* The third purpose is to show how the principles of HubFlow can be implemented in practice,
  alongside tools like bump2version and mike.


## What other goodies are shown off in this example?

This example also demonstrates:

* How to bundle a JSON data file (or data directory) with your Python package, so that
  your library can have data files available alongside code files.

* How to implement a minimal CLI tool with Click that can use the library (both the classes
  provided by the library, and the data bundled with the library).


## What is not included in this example?

This example implements only the barest minimum CLI tool with Click.

This example does **not** implement any best practices for building a good CLI tool.

