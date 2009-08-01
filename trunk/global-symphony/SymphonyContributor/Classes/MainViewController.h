//
//  MainViewController.h
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/8/09.
//  Copyright Pinch Media 2009. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
	BOOL recording;
	BOOL shouldLoop;

	AVAudioRecorder *recorder;
	NSURL *recordURL;
	NSMutableURLRequest *request;
	
	UIButton *playBtn;
	UISwitch *loopSwitch;
	UIButton *uploadBtn;
}

- (IBAction)showInfo;
- (IBAction)recordOrStop:(UIButton *)button;

- (void)record;
- (void)stop;

@property (nonatomic, retain) IBOutlet UIButton *playBtn;
- (IBAction)play;//:(UIButton *)button;

@property (nonatomic, retain) IBOutlet UISwitch *loopSwitch;
- (IBAction)test:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton *uploadBtn;
- (IBAction)upload;

@end
