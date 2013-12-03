#!/usr/bin/env python
# coding: utf-8
"""
Because I am lazy -- a quick script to scrape the website contents and
generate a JSON schedule. In the future this will go the other way around
and the website will be built up from JSON.
"""
from bs4 import BeautifulSoup
from urllib import request
import json

# grab site
www=request.urlopen('http://umd-byob.github.io/').read()
soup = BeautifulSoup(www)

# each list item is a single day with 1+ schedule items
talks = soup.findAll('li')
out = []

for entry in talks:
    # container to store all items for the day
    items = []

    # schedule date
    time = entry.find('time').text

    # some items are associated with URLs
    for talk in entry.findAll('a'):
        items.append({'title': talk.text, 'url': talk.attrs.get('href')})
    # others (e.g. cancelations) are just text
    for talk in entry.findAll('span'):
        items.append({'title': talk.text, 'url': ''})

    # add to output list
    out.append({'date': time, 'talks': items})

# dump JSON to a file
fp = open('schedule.json', 'w')
fp.write(json.dumps(out, indent=4))
fp.close()
