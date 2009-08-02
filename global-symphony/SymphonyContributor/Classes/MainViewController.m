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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		NSLog(@"custom init point?");
		mAudioRecorder = [[AudioRecorder alloc] init];
		mAudioPlayer = [[AudioPlayer alloc] init];
    }
    return self;
}

- (IBAction)recordOrStop:(UIButton *)button {
	
	if (mAudioRecorder.recording) {
		[self stop];
		[button setTitle:@"Record" forState:UIControlStateNormal];
	} else {
		[self record];
		[button setTitle:@"Stop" forState:UIControlStateNormal];
	}
}

// http://stackoverflow.com/questions/936855/file-upload-to-http-server-in-iphone-programming
- (IBAction)upload {
	NSLog(@"upload");
	NSString *urlString = @"http://localhost:8000/samples/add";
	NSString *filename = @"test.wav";
	
	request= [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *postbody = [NSMutableData data];
	[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
	[postbody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postbody appendData:[NSData dataWithData:[NSData dataWithContentsOfURL:mRecordURL]]];
	[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:postbody];
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(returnString);
}

- (IBAction)loopSwitchPress:(UISwitch*)switchitem
{
	mAudioPlayer.looping = loopSwitch.on;
}

- (IBAction)test:(id)sender {
	if (loopSwitch.on) NSLog(@"Yes, should loop");
	else NSLog(@"No, should NOT loop.");
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
