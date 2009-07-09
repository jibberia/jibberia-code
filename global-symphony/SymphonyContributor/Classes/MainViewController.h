//
//  MainViewController.h
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/8/09.
//  Copyright Pinch Media 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	BOOL recording;

	AVAudioRecorder *recorder;
}

- (IBAction)showInfo;
- (IBAction)recordOrStop:(UIButton *)button;

@end
