from django.http import HttpResponse
from sample.forms import SampleForm

def add_sample(request):
    if request.method == 'GET':
        return HttpResponse('<form method="POST" action="/samples/add" enctype="multipart/form-data">' + str(SampleForm()) + '<input type="submit" /></form>')
    elif request.method == 'POST':
        form = SampleForm(request.POST, request.FILES)
        resp = ''
        if form.is_valid():
            print "no errors"
            resp += "<h1>saved</h1><br>"
            form.save()
        else:
            resp += str(repr(form.errors))
        resp += '<pre>' + repr(form).replace('<', '&lt;').replace('>', '&gt;') + '\n\n\n' + str(dir(form));
        return HttpResponse(resp)
