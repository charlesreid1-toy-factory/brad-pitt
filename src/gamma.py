import os
import random
from .error import PittFall
from .alpha import Alpha
from .beta import Beta


class Gamma(object):
    """Praesent dapibus cursus imperdiet."""

    def __init__(self, *args, **kwargs):
        """ Mauris sagittis molestie ante eget tincidunt. Integer ut leo quis nisi semper maximus."""
        a = Alpha()
        b = Beta(tracking_id="abc123")

    def grape(self, **kwargs):
        """Cras vestibulum magna ut ex rhoncus faucibus. Cras eget dolor velit."""
        raise NotImplementedError()

    def gleams(self, **kwargs):
        """Vivamus gravida, tellus a facilisis lobortis, massa neque lacinia arcu, vel bibendum ipsum felis sit amet purus."""
        x = random.randint(1,6)
        return x

    def goopy(self):
        """Duis ultricies risus vitae ex molestie pellentesque. Proin ornare eleifend maximus."""
        return self.alpha, self.beta

