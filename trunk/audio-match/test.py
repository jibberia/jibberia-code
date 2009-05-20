#!/usr/bin/env python

from numpy import *
from scipy import * # after numpy to import scipy's fft
from scikits import audiolab

filename = 'audio/lv1.aif'
fft_window_size = 512
window_size = 2 * fft_window_size


audiofile = audiolab.sndfile(filename)
samples = audiofile.read_frames(audiofile.get_nframes())

# pad to right size so we can reshape it easily
extras = repeat(0, window_size - len(samples) % window_size)
samples = append(samples, extras)

fft_shape = (samples.size / window_size, window_size)
fft_windows = map(fft, samples.reshape(fft_shape))

print "got %d fft windows" % len(fft_windows)
