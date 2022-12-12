#!/usr/bin/env python
from skywalking import agent, config

config.init(collector_address="42.51.17.66:11800", service_name='python-app')
agent.start()
print("Skywalking agent started~")