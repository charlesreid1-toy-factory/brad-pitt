import os
from .error import PittFall


class Beta(object):
    """Praesent dapibus cursus imperdiet."""

    def __init__(self, *args, **kwargs):
        """Morbi dapibus ligula in posuere volutpat."""
        try:
            self.tracking_id = kwargs["tracking_id"]
        except KeyError:
            raise PittFall(
                f"{self.__class__.__name__}: Error: could not find a tracking id"
            )

    def beeps(self, **kwargs):
        """Nulla imperdiet, turpis eu vulputate pulvinar, felis erat facilisis nisl."""
        self.storage = dict(**kwargs)

    def beers(self, **kwargs):
        """Sed a lacus neque. Vestibulum aliquet augue nec urna aliquet, eu rutrum nisl auctor."""
        no_storage = dict(**kwargs)
        return no_storage

    def billy(self):
        """Curabitur cursus leo pellentesque enim tristique, quis bibendum ante rhoncus."""
        return self.tracking_id
