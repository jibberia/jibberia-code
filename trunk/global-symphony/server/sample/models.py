from django.db import models
import os

class Sample(models.Model):
    name = models.CharField(max_length=100, null=True)
    created = models.DateTimeField(auto_now_add=True)
    file = models.FileField(upload_to='samples')
    musical = models.BooleanField(default=False, blank=False)
    lat = models.DecimalField(null=True, blank=True, default=None, decimal_places=10, max_digits=15)
    lon = models.DecimalField(null=True, blank=True, default=None, decimal_places=10, max_digits=15)
    
    def __unicode__(self):
        return u'Sample named "%s"' % self.name
        
    def transcode_to_mp3(self):
        if self.name.endswith('mp3'):
            return
        old_path = self.file.path
        new_path = old_path.replace('.wav', '.mp3')
        os.system("lame --preset hifi %s %s" % (old_path, new_path))
        self.file.name = self.file.name.replace('.wav', '.mp3')


