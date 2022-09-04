"""Console script for brad_pitt"""
import sys
import click


@click.command()
def main(args=None):
    """Console script for brad_pitt."""
    click.echo("You can do some stuff here")
    click.echo("See click documentation at https://click.palletsprojects.com/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
