import sys
import cgi
import urllib2
import re
import wsgiref.handlers
from google.appengine.ext import webapp
from google.appengine.ext.webapp import template

from models import Video, Comment

def render_template(who, template_path, values = {}):
#  abs_path = '/Users/kevin/pybox/google-app-engine/wimp-commenter/templates/' + template_path
#  abs_path = '/Users/kevin/jibberia-code/wimp-commenter/templates' + template_path
  abs_path = './templates/' + template_path
  output = template.render(abs_path, values)
  who.response.out.write(output)



class MainHandler(webapp.RequestHandler):
  def get(self):
    videos = Video.all()
    render_template(self, 'index.html', {
      'videos': videos
    })

class VideoHandler(webapp.RequestHandler):
  def get(self, id=1):
    video = Video.get(id)
    debug = str(video)
    render_template(self, 'video.html', {
      'video': video,
      'debug': debug,
    })

class AddVideoHandler(webapp.RequestHandler):
  def get(self):
    render_template(self, 'add-video-form.html')
  
  def post(self):
    wimp_url = cgi.escape(self.request.get('wimp_url'))
    video = Video.get_or_create(wimp_url)
    self.redirect('/video/%s' % id)

class AddCommentHandler(webapp.RequestHandler):
  def post(self, id):
    video = Video.get(id)
    
    author = cgi.escape(self.request.get('author'))
    text = cgi.escape(self.request.get('text'))
    
    comment = Comment(video=video, author=author, text=text)
    comment.save()
    self.redirect('/video/%s' % id)

def main():
  application = webapp.WSGIApplication([('/', MainHandler),
                                        ('/add-video', AddVideoHandler),
                                        ('/video/(.*)/comment', AddCommentHandler),
                                        ('/video/(.*)', VideoHandler),
                                       ], debug=True)
  wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
  main()
