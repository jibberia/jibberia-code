//
//  Sample.m
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/13/09.
//  Copyright 2009 Pinch Media. All rights reserved.
//

#import "Sample.h"


@implementation Sample

- (id)init {
	if (self = [super init]) {
		recording = NO;
	}
	return self;
}

// http://stackoverflow.com/questions/1010343/how-do-i-record-audio-on-iphone-with-avaudiorecorder
- (void)record {
	NSLog(@"record start");
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	
	// enter record mode
	[audioSession setCategory:AVAudioSessionCategoryRecord error:&err];
	if (err) {
        NSLog(@"audioSession error: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	
	[audioSession setActive:YES error:&err];
	if (err) {
        NSLog(@"audioSession error: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	
	NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
		[NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
		[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
		[NSNumber numberWithInt:2], AVNumberOfChannelsKey,
		[NSNumber numberWithInt:16] , AVLinearPCMBitDepthKey,
		[NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
		[NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
	nil];
	
	[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
	[recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
	[recordSetting setValue:[NSNumber numberWithInt:16]  forKey:AVLinearPCMBitDepthKey];
	[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	
	
	// Create a new dated file
	NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
	NSString *caldate = [now description];
	recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
	
	NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
	err = nil;
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
	if (!recorder) {
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
		[[UIAlertView alloc] initWithTitle:@"Warning"
								   message:[err localizedDescription]
								  delegate:nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
	}
	
	// prepare to record
	[recorder setDelegate:self];
	[recorder prepareToRecord];
	recorder.meteringEnabled = YES;
	
	if (!audioSession.inputIsAvailable) {
        UIAlertView *cantRecordAlert =
		[[UIAlertView alloc] initWithTitle:@"Warning"
								   message:@"Audio input hardware not available"
								  delegate:nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
        return;
	}
	// start recording
	[recorder record];
	//	[recorder recordForDuration:(NSTimeInterval) 10];
}

- (void)stop {
	
}

@end
