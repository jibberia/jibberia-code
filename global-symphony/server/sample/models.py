from django.db import models

# Create your models here.

class Sample(models.Model):
	name = models.CharField(max_length=100)
	created = models.DateField()
	
	def __unicode__(self):
		return u"Sample named \"%s\"" % self.name


