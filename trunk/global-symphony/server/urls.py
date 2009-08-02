from django.conf.urls.defaults import *
from django.conf import settings
from sample.views import *

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Example:
    # (r'^server/', include('server.foo.urls')),
    (r'^samples/add', add_sample),
    (r'^samples/', include('sample.urls')),
    (r'^samples/random', random_sample),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'^admin/', include(admin.site.urls)),
    (r'^site_media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.SITE_MEDIA_ROOT}),
    (r'^static/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.MEDIA_ROOT}),
)
