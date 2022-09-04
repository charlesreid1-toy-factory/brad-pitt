import os
import random
import json


def random_fact():
    facts = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'brad_pitt_facts.json')
    if not os.path.exists(facts):
        raise PittFall(f"random_fact: Error: Could not find data/brad_pitt_facts.json. Looked in {facts}")
    else:
        with open(facts, 'r') as f:
            d = json.load(f)
        facts = d['list_of_facts']
        return random.choice(facts)
