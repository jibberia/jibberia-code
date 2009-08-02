from django.conf.urls.defaults import *
from django.views.generic.simple import direct_to_template
from django.conf import settings
from django.contrib import admin
import os

urlpatterns = patterns('',
    (r'^playback/$', direct_to_template, {'template': 'sample/playback.html'}),
)