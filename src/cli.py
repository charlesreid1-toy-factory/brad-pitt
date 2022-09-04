"""Console script for brad_pitt"""
import sys
import click
from .alpha import Alpha
from .beta import Beta
from .error import PittFall
from .util import random_fact


@click.command()
def main(args=None):
    """Console script for brad_pitt."""
    click.echo("You are about to use the bradd-pitt library")
    click.echo(" - Using Alpha class")
    a = Alpha(name="adios")
    a.adder(1, 2)
    click.echo(" - Using Beta class")
    b = Beta(tracking_id="12345")
    b.beers(foo="hello", world="bar")
    click.echo(f" - Brad Pitt fact: {random_fact()}")
    click.echo("Congrats! You successfully used the bradd-pitt library!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
