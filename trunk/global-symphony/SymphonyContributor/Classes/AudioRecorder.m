/*
 *  AudioRecorder.c
 *  SymphonyContributor
 *
 *  Created by Paul Ossenbruggen on 8/1/09.
 *
 */

#include "AudioRecorder.h"

@implementation AudioRecorder


@synthesize errorString;
@synthesize recording;
@synthesize name;
@synthesize musical;

- (id)init {
    if (self = [super init]) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		self.name = @"Untitled Sample";
    }
    return self;
}

- (void)setProgressDealie:(UIActivityIndicatorView*)theProgressDealie {
	progressDealie = [theProgressDealie retain];
}

- (RecorderErrors)recordToUrl:(NSURL*)recordUrl
{
	NSLog(@"record start");
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	
	// enter record mode
	[audioSession setCategory:AVAudioSessionCategoryRecord error:&err];
	
	if (err) {
		
        self.errorString = [NSString stringWithFormat:(@"audioSession error: %@ %d %@", [err domain], [err code], [[err userInfo] description])];
		return kRecorderCategoryErr;
	}
	
	[audioSession setActive:YES error:&err];
	
	if (err) {
        self.errorString = [NSString stringWithFormat:(@"audioSession error: %@ %d %@", [err domain], [err code], [[err userInfo] description])];
		return kRecorderActiveErr;
	}
	
	NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
								   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
								   [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
								   [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
								   [NSNumber numberWithInt:16] , AVLinearPCMBitDepthKey,
								   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
								   [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
								   nil];
	
	
	err = nil;
	mRecordURL = recordUrl;
	mRecorder = [[AVAudioRecorder alloc] initWithURL:mRecordURL settings:recordSetting error:&err];
	if (!mRecorder) {

		self.errorString = [NSString stringWithFormat:@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]];
		return kRecorderAllocFailed;
	}
	
	// prepare to record
	[mRecorder setDelegate:self];
	[mRecorder prepareToRecord];
	mRecorder.meteringEnabled = NO;
	
	if (!audioSession.inputIsAvailable) {
				
        return kRecorderAudioInputNotAvalible;
	}
	// start recording
	NSLog(@"calling record now");
	[mRecorder record];
	
	self.recording = YES;
	
	return kRecorderNoError;
}

- (RecorderErrors)recordStop
{
	NSLog(@"stop");
	
	[mRecorder stop];
	
	self.recording = NO;

	NSError *err = nil;
	NSData *audioData = [NSData dataWithContentsOfFile:[mRecordURL path] options: 0 error:&err];
	if(!audioData)
	{
        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		return kRecorderAudioDataError;
	}
	return kRecorderNoError;
}

- (NSString *)filePathStr {
	return [mRecordURL path];
}

/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)aRecorder successfully:(BOOL)flag {
	NSLog(@"[%@ audioRecorderDidFinishRecording:%@ successfully:%d]", [self class], aRecorder, flag);
	self.recording = NO;
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)aRecorder error:(NSError *)error {
	NSLog(@"[%@ audioRecorderEncodeErrorDidOccur:%@ error:%@]", [self class], aRecorder, error);
	self.recording = NO;

}

/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorder will have been paused. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)aRecorder {
	NSLog(@"[%@ audioRecorderBeginInterruption:%@]", [self class], aRecorder);
}

/* audioRecorderEndInterruption: is called when the audio session interruption has ended and this recorder had been interrupted while recording. 
 The recorder can be restarted at this point. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)aRecorder {
	NSLog(@"[%@ audioRecorderEndInterruption:%@]", [self class], aRecorder);
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[manager stopUpdatingLocation];
	location = [newLocation copy];
	if (progressDealie != nil) {
		[progressDealie stopAnimating];
	}
}

- (void)upload {
	request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://jibberia.dyndns.org:8198/samples/add"]]; // jibberia.dyndns.org
	
	[request setFile:[self filePathStr] forKey:@"file"];
	[request setPostValue:self.name forKey:@"name"];

	if (musical) [request setPostValue:@"True"  forKey:@"musical"];
	else         [request setPostValue:@"False" forKey:@"musical"];
	
	if (location != nil) {
		[request setPostValue:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"lat"];
		[request setPostValue:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"lon"];
	}
	[request start];
}	

- (void)startUpdatingLocation {
	// skip location services if the user has disabled Location Services in General Settings
	// this is so we don't pop up nag messages to turn it on
	if (locationManager.locationServicesEnabled) {
		if (progressDealie != nil) {
			[progressDealie startAnimating];
		}
		[locationManager startUpdatingLocation];
	}
}
- (void)invalidateLocation {
	location = nil;
}

@end
