//
//  MainViewController.m
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/8/09.
//  Copyright Pinch Media 2009. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "AudioRecorder.h"
#import "AudioPlayer.h"

@implementation MainViewController

@synthesize playBtn;
@synthesize loopSwitch;
@synthesize uploadBtn;
@synthesize progressDealie;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		mAudioRecorder = [[AudioRecorder alloc] init];
		mAudioPlayer = [[AudioPlayer alloc] init];
    }
    return self;
}

- (IBAction)recordOrStop:(UIButton *)button {
	
	if (mAudioRecorder.recording) {
		[self stop];
		[button setTitle:@"Record" forState:UIControlStateNormal];
		
		if (locationManager == nil) {
			locationManager = [[CLLocationManager alloc] init];
			locationManager.delegate = self;
		}
		
		// skip location services if the user has disabled Location Services in General Settings
		// this is so we don't pop up nag messages to turn it on
		if (locationManager.locationServicesEnabled) {
			[locationManager startUpdatingLocation];
			[progressDealie startAnimating];
		}
		
	} else {
		location = nil;
		[self record];
		[button setTitle:@"Stop" forState:UIControlStateNormal];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[manager stopUpdatingLocation];
	location = [newLocation copy];
	[progressDealie stopAnimating];
}

- (IBAction)upload {
	[progressDealie startAnimating];
	request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://jibberia.dyndns.org:8000/samples/add"]]; // jibberia.dyndns.org
	[request setFile:[mAudioRecorder filePathStr] forKey:@"file"];
	[request setPostValue:@"TODO" forKey:@"name"];
	if (location != nil) {
	
		[request setPostValue:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"lat"];
		[request setPostValue:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"lon"];
	}
	[request start];
	[progressDealie stopAnimating];
}

- (IBAction)loopSwitchPress:(UISwitch *)switchitem
{
	mAudioPlayer.looping = loopSwitch.on;
}

- (IBAction)play {//:(UIButton *)button {
	[mAudioPlayer playUrl:mRecordURL];
}

// http://stackoverflow.com/questions/1010343/how-do-i-record-audio-on-iphone-with-avaudiorecorder
- (void)record {
	// Create a new dated file
	int ts = (int)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *recorderFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav", ts]];
	NSLog(@"recorderFilePath: %@", [recorderFilePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]);

	mRecordURL = [NSURL fileURLWithPath:recorderFilePath];
	
	int error = [mAudioRecorder recordToUrl:mRecordURL];
	if (error == kRecorderAllocFailed)
	{
		UIAlertView *alert =
		[[UIAlertView alloc] initWithTitle:@"Warning"
								   message:[mAudioRecorder errorString]
								  delegate:nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
		[alert show];
		[alert release];
		NSLog(@"Error %@", [mAudioRecorder errorString]);
	} else if (error == kRecorderAudioInputNotAvalible)
	{
        UIAlertView *cantRecordAlert =
		[[UIAlertView alloc] initWithTitle:@"Warning"
								   message:@"Audio input hardware not available"
								  delegate:nil
						 cancelButtonTitle:@"OK"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
		NSLog(@"Error %@", [mAudioRecorder errorString]);
		
	} else if (error != 0)
	{
		NSLog(@"%@", [mAudioRecorder errorString]);
	}
	
	//	[recorder recordForDuration:(NSTimeInterval) 10];
}

- (void)stop {

	int result = [mAudioRecorder recordStop];
	if (result == kRecorderNoError)
	{
		NSLog(@"apparently got data successfully");
		playBtn.enabled = YES;
		uploadBtn.enabled = YES;
	}
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
}


@end
