//
//  MainViewController.h
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/8/09.
//  Copyright Pinch Media 2009. All rights reserved.
//

#import "FlipsideViewController.h"
 

@class AudioRecorder;
@class AudioPlayer;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	BOOL recording;
	BOOL shouldLoop;

	NSURL *mRecordURL;
	NSMutableURLRequest *request;
	
	UIButton *playBtn;
	UISwitch *loopSwitch;
	UIButton *uploadBtn;
	AudioRecorder *mAudioRecorder;
	AudioPlayer *mAudioPlayer;
}

- (IBAction)showInfo;
- (IBAction)recordOrStop:(UIButton *)button;
- (IBAction)loopSwitchPress:(UISwitch *)button;

- (void)record;
- (void)stop;

@property (nonatomic, retain) IBOutlet UIButton *playBtn;
- (IBAction)play;//:(UIButton *)button;

@property (nonatomic, retain) IBOutlet UISwitch *loopSwitch;
- (IBAction)test:(id)sender;

@property (nonatomic, retain) IBOutlet UIButton *uploadBtn;
- (IBAction)upload;

@end
