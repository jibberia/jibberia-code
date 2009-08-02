from django.db import models

# Create your models here.

class Sample(models.Model):
	name = models.CharField(max_length=100, null=True)
	created = models.DateTimeField(auto_now_add=True)
	file = models.FileField(upload_to='samples')
	musical = models.BooleanField(default=False, blank=False)
	
	def __unicode__(self):
		return u"Sample named \"%s\"" % self.name


