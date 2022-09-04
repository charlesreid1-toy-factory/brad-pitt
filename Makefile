.PHONY: clean clean-build clean-pyc clean-test lint lint/flake8 lint/black docs serve-docs deploy-docs test test-all install release_major release_major_real release_minor release_minor_real release_patch release_patch_real

.DEFAULT_GOAL := help

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
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

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

############ Docs

docs: ## generate mkdocs HTML documentation
	rm -fr site/*
	mkdocs build --clean

serve-docs: docs ## serve the docs
	mkdocs serve --clean

deploy-docs: docs ## serve the docs
	mkdocs gh-deploy --clean

############ Test

test: ## run tests quickly with the default Python
	pytest

test-all: ## run tests on every Python version with tox
	tox

############ Build

install: clean ## install the package to the active Python's site-packages
	python setup.py install

############ Release

release_major: ## dry run: cut a major release
	bump2version --dry-run --verbose bump2version major
	@echo "Use the 'make release_major_real' rule to commit the proposed changes."

release_major_real: ## cut a major release
	bump2version --verbose bump2version major

release_minor: ## dry run: cut a minor release
	bump2version --dry-run --verbose bump2version minor
	@echo "Use the 'make release_minor_real' rule to commit the proposed changes."

release_minor_real: ## cut a minor release
	bump2version --verbose bump2version minor

release_patch: ## dry run: cut a patch release
	bump2version --dry-run --verbose bump2version patch
	@echo "Use the 'make release_patch_real' rule to commit the proposed changes."

release_patch_real: ## cut a patch release
	bump2version --verbose bump2version patch
