//
//  SpeedMeasurementViewController.h
//  SpeedLocator
//
//  Created by Kevin Cox on 5/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeedMeasurement.h"

@interface SpeedMeasurementViewController : UIViewController {
	SpeedMeasurement *measurement;
	IBOutlet UISlider *speedSlider;
}

@property (nonatomic, retain) IBOutlet UISlider *speedSlider;

- (IBAction)speedChanged:(UISlider *)slider;
- (IBAction)saveSpeedMeasurement;

@end
