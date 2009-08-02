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

@interface MainViewController : UIViewController <CLLocationManagerDelegate, FlipsideViewControllerDelegate> {
	BOOL recording;
	BOOL shouldLoop;

	NSURL *mRecordURL;
//	NSString *recorderFilePath;
	ASIFormDataRequest *request;
	
	UIButton *playBtn;
	UISwitch *loopSwitch;
	UIButton *uploadBtn;
	AudioRecorder *mAudioRecorder;
	AudioPlayer *mAudioPlayer;
	
	CLLocationManager *locationManager;
	CLLocation *location;
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

@end
