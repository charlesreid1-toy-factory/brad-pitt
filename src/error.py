import random
import json

class PittFall(Exception):
    """This class is just here for the clever wordplay"""

    def __init__(self, *args, **kwargs):
        print("-"*40)
        print(self.random_fact())
        print("-"*40)
        super(*args, **kwargs)

    def random_fact(self):
        with open('data/brad_pitt_facts.json', 'r') as f:
            d = json.load(f)
        facts = d['list_of_facts']
        return random.choice(facts)
