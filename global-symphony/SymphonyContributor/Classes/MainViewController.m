//
//  MainViewController.m
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/8/09.
//  Copyright Pinch Media 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"


@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		NSLog(@"custom init point?");
		recording = NO;
    }
    return self;
}

- (IBAction)recordOrStop:(UIButton *)button {
	recording = !recording;

	if (recording) {
		[button setTitle:@"Stop" forState:UIControlStateNormal];
		[self record];
	} else {
		[button setTitle:@"Record" forState:UIControlStateNormal];
		[self stop];
	}
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
	/*
	[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
	[recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
	[recordSetting setValue:[NSNumber numberWithInt:16]  forKey:AVLinearPCMBitDepthKey];
	[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	*/
	
	// Create a new dated file
	int ts = (int)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	recorderFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.caf", ts]];
	
	NSLog(@"recorderFilePath: %@", recorderFilePath);
	
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
	recorder.meteringEnabled = NO;
	
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
	NSLog(@"calling record now");
	[recorder record];
	//	[recorder recordForDuration:(NSTimeInterval) 10];
}

- (void)stop {
	NSLog(@"stop");
	
	
	[recorder stop];
	
	NSURL *url = [NSURL fileURLWithPath: recorderFilePath];
	NSError *err = nil;
	NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
	if(!audioData)
        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
	else
		NSLog(@"apparently got data successfully");
	/*
	NSFileManager *fm = [NSFileManager defaultManager];
	
	err = nil;
	[fm removeItemAtPath:[url path] error:&err];
	if(err)
        NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
	
	
	
	UIBarButtonItem *startButton = [[UIBarButtonItem alloc] initWithTitle:@"Record" style:UIBarButtonItemStyleBordered  target:self action:@selector(startRecording)];
	self.navigationItem.rightBarButtonItem = startButton;
	[startButton release];
	*/
}


/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)aRecorder successfully:(BOOL)flag {
	NSLog(@"[%@ audioRecorderDidFinishRecording:%@ successfully:%d]", [self class], aRecorder, flag);
}

/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)aRecorder error:(NSError *)error {
	NSLog(@"[%@ audioRecorderEncodeErrorDidOccur:%@ error:%@]", [self class], aRecorder, error);
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




/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[recorderFilePath release];
}


@end
