"""Console script for brad_pitt"""
import sys
import click
from .alpha import Alpha
from .beta import Beta
from .error import PittFall


@click.command()
def main(args=None):
    """Console script for brad_pitt."""
    click.echo("You are about to use the bradd-pitt library")
    a = Alpha(name="adios")
    a.adder(1, 2)
    b = Beta(tracking_id="12345")
    b.beers(foo="hello", world="bar")
    click.echo("Congrats! You successfully used the bradd-pitt library!")
    return 0


if __name__ == "__main__":
    sys.exit(main())
