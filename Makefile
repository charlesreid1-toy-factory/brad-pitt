include common.mk

.PHONY: clean clean-build clean-pyc clean-test lint lint/flake8 lint/black docs serve-docs deploy-docs test test-all install bump_major_version bump_minor_version bump_patch_version release

.DEFAULT_GOAL := help

CB := $(shell git branch --show-current)

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

############ Clean

clean: clean-build clean-pyc clean-test ## remove all build, test, and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs *.egg*

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr .pytest_cache

############ Lint

lint/flake8: ## check style with flake8
	flake8 bradpitt tests

lint/black: ## check style with black
	black --check bradpitt tests

lint: lint/flake8 lint/black ## check style

############ Requirements

requirements:
	python3 -m pip install --upgrade -r requirements.txt

requirements-dev:
	python3 -m pip install --upgrade -r requirements-dev.txt

############ Docs

build-docs: ## build local copy of mkdocs documentation
	rm -fr site/*
	make build
	mkdocs build --clean

serve-docs: docs ## serve local copy of mkdocs documentation
	mkdocs serve --clean

# This should be handled by the scripts/release.sh script
#mike-deploy-docs: ## deploy this version of the docs using mike
#	VERS=$(shell cat VERSION)
#	@echo "Deploying docs for version $(VERS)"
#	mike deploy $(VERS)
#
#mike-deploy-docs-latest: ## deploy this version of the docs and add a latest shortcut
#	VERS=$(shell cat VERSION)
#	@echo "Deploying docs for version $(VERS) (with latest shortcut)"
#	mike deploy $(VERS) latest

############ Test

test: ## run tests quickly with the default Python
	pytest -vs

test-all: ## run tests on every Python version with tox
	tox

############ Build

build: clean ## build and install the package into the active Python's site-packages
	python3 setup.py build install

buildtest: clean build test

############ Release

bump_major_version: ## bump major version
	@echo
	@echo "About to bump the major version"
	@echo
	#bump2version --dry-run --verbose major
	bump2version --verbose major

bump_minor_version: ## bump minor version
	@echo
	@echo "About to bump the minor version"
	@echo
	#bump2version --dry-run --verbose minor
	bump2version --verbose minor

bump_patch_version: ## bump patch version
	@echo
	@echo "About to bump the patch version"
	@echo
	#bump2version --dry-run --verbose patch
	bump2version --verbose patch

release: ## tag and cut a release
	@echo
	@echo "About to cut a release: from current branch $(CB) to main"
	#scripts/release.sh --dry-run $(CB) main
	scripts/release.sh $(CB) main

release_tag: ## only tag the release, do not cut it
	@echo
	@echo "About to tag a release: on branch $(CB)"
	#scripts/release.sh --dry-run --tag-only $(CB) main
	scripts/release.sh --tag-only $(CB) not_main
