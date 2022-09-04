from setuptools import setup, find_packages
from src import __version__

with open("requirements.txt") as f:
    all_deps = [x for x in f.read().splitlines() if not x.startswith("#")]
with open("requirements-dev.txt") as f:
    dev_deps = [x for x in f.read().splitlines() if not x.startswith("#")]

setup(
    name="brad-pitt",
    version=__version__,
    description="a super simple python package demonstrating best practices for versioning",
    author="Chaz Reid",
    author_email="charlesreid1.ancestry@ancestry.com",
    url="https://github.com/charlesreid1-toy-factory/brad-pitt",
    packages=["brad_pitt"],
    package_dir={"brad_pitt": "src"},
    package_data={
        "gollyx_maps": [
            "data/*.json",
            "data/*.txt",
        ]
    },
    license="MIT",
    install_requires=all_deps,
    extras_require={
        "test": dev_deps,
        "docs": dev_deps,
        "develop": dev_deps,
    }
)
