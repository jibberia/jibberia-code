from django.http import HttpResponse
from sample.forms import SampleForm
from sample.models import *
from django.utils import simplejson
from django.conf import settings
from django.core.files import File

def add_sample(request):
    if request.method == 'GET':
        return HttpResponse('<form method="POST" action="/samples/add" enctype="multipart/form-data">' + str(SampleForm()) + '<input type="submit" /></form>')
    elif request.method == 'POST':
        form = SampleForm(request.POST, request.FILES)
        resp = ''
        if form.is_valid():
            resp += "success"
            form.save()
            sample = form.instance
            sample.transcode_to_mp3()
            sample.save()
        else:
            resp += str(repr(form.errors))
        print resp
        return HttpResponse(resp)

def random_sample(request):
    samples = Sample.objects.all()
    
    if request.GET.has_key('exclude'):
        exclude_ids = simplejson.loads(request.GET['exclude'])
        for sample_id in exclude_ids:
            samples = samples.exclude(id=sample_id)
    
    if request.GET.has_key('musical'):
        samples = samples.filter(musical=True)
        
    samples = samples.exclude(lat=None).exclude(lon=None)

    samples = samples.order_by('?')[:1]
    
    if samples.count() == 0:
        sample_ret_obj = {
            "error": "No more samples"
        }
    else:
        sample = samples[0]
        sample_ret_obj = {
            "id": sample.id,
            "name": sample.name,
            "url": settings.MEDIA_URL + sample.file.url,
            "lat": str(sample.lat),
            "lon": str(sample.lon)
        }
    
    return HttpResponse(simplejson.dumps(sample_ret_obj))