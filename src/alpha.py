import os
from .error import PittFall


class Alpha(object):
    """Ut eu augue accumsan, venenatis nulla quis, elementum dui."""

    def __init__(self, *args, **kwargs):
        """Donec et magna pulvinar, suscipit ante in, aliquet felis."""
        self.name = None
        if "name" in kwargs:
            self.name = kwargs["name"]
        else:
            self.name = "default"

    def adder(self, *args):
        """Donec placerat faucibus dignissim."""
        try:
            s = sum(args)
        except TypeError:
            raise PittFall(f"{self.__class__.__name__}: Error: could not adder() stuff")

    def affix(self, param1, param2, param3):
        """In hac habitasse platea dictumst."""
        if random.random() < 0.5:
            if random.random() < 0.5:
                return param1
            else:
                return param2
        else:
            return param3
