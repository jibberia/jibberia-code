from google.appengine.ext import db

class TVideo(db.Model):
  wimp_url = db.URLProperty()
  video_url = db.URLProperty()
  
  title = db.TextProperty(required=False)
  description = db.TextProperty(required=False)
  
  def __init__(self, parent=None, key_name=None, _app=None, _from_entity=False, **kwds):
    super(TVideo, self).__init__(parent, key_name, _app, _from_entity, kwds=kwds)
    if self.wimp_url:
      self.scrape_wimp()
  
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
    return "Video:\n    id: %s\n    wimp_url: %s\n    video_url: %s\n    title: %s\n    description: %s\n    " % (wimp_url, id, video_url, title, description)


if __name__ == '__main__':
  v = TVideo(wimp_url='http://www.wimp.com/bookfun/')
