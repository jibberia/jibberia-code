//
//  MainViewController.h
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/8/09.
//  Copyright Pinch Media 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "ASIFormDataRequest.h"
#import <CoreLocation/CoreLocation.h>

@class AudioRecorder;
@class AudioPlayer;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UITextFieldDelegate> {
	BOOL recording;
	BOOL shouldLoop;

	NSURL *mRecordURL;
	
	UITextField *nameField;
	UIButton *playBtn;
	UISwitch *loopSwitch;
	UIButton *uploadBtn;
	UIActivityIndicatorView *progressDealie;
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

@property (nonatomic, retain) IBOutlet UIButton *uploadBtn;
- (IBAction)upload;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progressDealie;

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@end
