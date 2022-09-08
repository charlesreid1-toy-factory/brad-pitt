SHELL=/bin/bash

ifeq ($(shell which bump2version),)
$(error Please install bump2version or activate your virtual environment)
endif

ifeq ($(shell echo ${BRAD_PITT_HOME}),)
$(error Environment variable BRAD_PITT_HOME not defined. Please run "source environment" in the repo root directory before running make commands)
endif

