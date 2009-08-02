//
//  FlipsideViewController.h
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/8/09.
//  Copyright Pinch Media 2009. All rights reserved.
//

@protocol FlipsideViewControllerDelegate;

@class AudioRecorder;

@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
	
	BOOL intermittent;
	UIButton *startStopBtn;
	AudioRecorder *mAudioRecorder;
	UIActivityIndicatorView *activity;
	NSURL *mRecordURL;

}

- (void)enableTimer:(BOOL)enable;

@property (nonatomic, retain) IBOutlet UIButton *startStopBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

@property BOOL intermittent;

- (IBAction)recordintermittent:(UIButton *)button;

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

