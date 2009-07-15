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


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, AVAudioRecorderDelegate> {
	BOOL recording;

	AVAudioRecorder *recorder;
	NSString *recorderFilePath;
	NSString *test;
}

- (IBAction)showInfo;
- (IBAction)recordOrStop:(UIButton *)button;

- (void)record;
- (void)stop;

@end
