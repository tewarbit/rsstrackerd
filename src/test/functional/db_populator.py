# -*- coding: utf-8 -*-

#!/usr/bin/python
import urllib
import urllib2
from xml.dom import minidom

BASE_URL = "http://localhost:8001/util/"
HEADERS = {'Accept-Encoding': 'gzip,deflate,sdch', 'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8', 
           'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3', 'Content-Type': 'application/x-www-form-urlencoded'}


translations = [(u'\u2019', '\''), 
                (u'\u2018', '\''), 
                (u'\u2013', '-'), 
                (u'\u201D', '"'), 
                (u'\u201C', '"')]

def do_latin1_translate(s):
  for translate in translations:
    s = s.replace(translate[0], translate[1])

  return s.encode('iso-8859-1', 'replace')


rss_feed = minidom.parseString(open("etsy_rss.xml").read())
titles = rss_feed.getElementsByTagName('title')

subscription_name = titles[0].firstChild.nodeValue
subscription_name = do_latin1_translate(subscription_name)
print subscription_name

items = rss_feed.getElementsByTagName('item')
for item in items:
  item_title = item.getElementsByTagName('title')[0].firstChild.nodeValue.strip()
  item_title = do_latin1_translate(item_title)
  print item_title

  item_content = ""
  contents = item.getElementsByTagName("content:encoded")[0].childNodes
  for content in contents:
    c = content.nodeValue.strip()
    item_content += do_latin1_translate(c)
    print item_content

  url = BASE_URL + "create_feed_item"

  data = urllib.urlencode({'subscriptionname': subscription_name, 'itemname': item_title, 'content': item_content})
  results = urllib2.urlopen(url, data)

