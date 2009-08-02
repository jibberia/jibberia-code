//
//  FlipsideViewController.m
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/8/09.
//  by Paul Ossenbruggen 8/2/09
//  Copyright Pinch Media 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "AudioRecorder.h"


@implementation FlipsideViewController

const int kMaxPunchInTimeRand = 60; // one minute
const int kMaxPunchOutTimeRand = 15; // seconds

@synthesize delegate;
@synthesize startStopBtn;
@synthesize activity;

@synthesize intermittent;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	unsigned xseed = (unsigned)time(NULL);  // Current Time
	srandom( xseed ); // Initialize the random number generator

    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];    
	
	mAudioRecorder = [[AudioRecorder alloc] init];
	
}


- (IBAction)done {
	[self enableTimer:NO];
	[self.delegate flipsideViewControllerDidFinish:self];	
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
	[mAudioRecorder release];
    [super dealloc];
}

- (void)punchOut:(NSNotification *)n
{
	NSLog(@"Punch Out Recording");
	[mAudioRecorder recordStop];

	NSLog(@"Upload");
	[mAudioRecorder upload];
	
	// Retrigger
	[self enableTimer:YES];
}


- (void)punchIn:(NSNotification *)n
{
	NSLog(@"Punch In Record");
	
	// Create a new dated file
	int ts = (int)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *recorderFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav", ts]];
	NSLog(@"recorderFilePath: %@", [recorderFilePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "]);
	
	mRecordURL = [NSURL fileURLWithPath:recorderFilePath];

	long value  = random() % kMaxPunchOutTimeRand + 1; // record at least one second. 
	NSLog(@"Record time value %d", value);

	[self performSelector:@selector(punchOut:) withObject:nil afterDelay:value];
	
	[mAudioRecorder recordToUrl:mRecordURL];
}


- (void)enableTimer:(BOOL)enable
{
	if (enable)
	{
		long value  = random() % kMaxPunchInTimeRand;
		NSLog(@"Delay time value %d", value);
		[self performSelector:@selector(punchIn:) withObject:nil afterDelay:value];
		[activity startAnimating];
		[startStopBtn setTitle:@"Stop" forState:UIControlStateNormal];
	}
	else
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[activity stopAnimating];
		[startStopBtn setTitle:@"Start" forState:UIControlStateNormal];
	}
}

- (IBAction)recordintermittent:(UIButton *)button
{
	self.intermittent = !self.intermittent;
	
	[self enableTimer:self.intermittent];
}

@end
