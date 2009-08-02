from django.conf.urls.defaults import *
from django.conf import settings
from sample.views import *
from django.views.generic.simple import direct_to_template

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Example:
    # (r'^server/', include('server.foo.urls')),
    (r'^samples/add', add_sample),
    (r'^samples/', include('sample.urls')),
    (r'^samples/random', random_sample),
    
    (r'^playback/rainbow', direct_to_template, {'template': 'sample/playback.html'}),
    (r'^playback/audio-map', direct_to_template, {'template': 'sample/audio-map.html'}),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'^admin/', include(admin.site.urls)),
    (r'^site_media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.SITE_MEDIA_ROOT}),
    (r'^static/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.MEDIA_ROOT}),
    (r'^$', direct_to_template, {'template': 'index.html'}),
)
