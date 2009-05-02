import urllib2
import re
from google.appengine.ext import db

class Video(db.Model):
  wimp_url = db.URLProperty()
  video_url = db.URLProperty()
  
  title = db.TextProperty(required=False)
  description = db.TextProperty(required=False)
  
  @classmethod
  def get_or_create(Klass, wimp_url, save=True):
    """
    The Right Way to add a video. Uses the given url (of the form
    http://www.wimp.com/somevideo/) as the key, and then scrapes the
    wimp page for more info.
    """
    vid = Klass.get_or_insert(wimp_url)
    vid.wimp_url = wimp_url
    vid.scrape_wimp()
    if save:
      vid.save()
    return vid  
  
  def scrape_wimp(self):
    conn = urllib2.urlopen(self.wimp_url)
    page = conn.readlines()
    
    title_re = re.compile("<b>(.*)</b>")
    look_here_for_description = False

    for line in page:
      if re.search(title_re, line):
        self.title = re.split(title_re, line)[1]
      elif line.find('flv') != -1:
        self.video_url = 'http://www.wimp.com' + re.split('.*","(.*)"\);', line)[1]
      
      if self.title and not self.description: # desc is after title
        if look_here_for_description:
          self.description = re.split('\s*(.*)</div>', line)[1]
          look_here_for_description = False
        elif line.startswith('<br/>'):
            look_here_for_description = True

  def __str__(self):
    if self.is_saved():
      id = str(self.key())
    else:
      id = 'UNSAVED'
    wimp_url = self.wimp_url or ''
    video_url = self.video_url or ''
    title = self.title or ''
    description = self.description or ''
    return "Video:\n    id: %s\n    wimp_url: %s\n    video_url: %s\n    title: %s\n    description: %s\n    " % (id, wimp_url, video_url, title, description)
          

class Comment(db.Model):
  video = db.ReferenceProperty(Video, required=True, collection_name='comments')
  author = db.StringProperty()
  text = db.TextProperty()
  date = db.DateTimeProperty(auto_now_add=True)
  def __str__(self):
    video = self.video or ''
    author = self.author or ''
    text = self.text or ''
    date = self.date or ''
    return 'Comment on video %s by %s on %s: "%s"' % (str(video), author, str(date), text)


# BlobProperty
# BooleanProperty
# ByteStringProperty
# CategoryProperty
# DateProperty
# DateTimeProperty
# DerivedPropertyError
# DuplicatePropertyError
# EmailProperty
# FloatProperty
# GeoPtProperty
# IMProperty
# IntegerProperty
# LinkProperty
# ListProperty
# PhoneNumberProperty
# PostalAddressProperty
# Property
# PropertyError
# RatingProperty
# ReferenceProperty
# SelfReferenceProperty
# StringListProperty
# StringProperty
# TextProperty
# TimeProperty
# URLProperty
# UserProperty

