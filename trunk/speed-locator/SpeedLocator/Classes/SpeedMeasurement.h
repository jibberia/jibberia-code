//
//  SpeedMeasurement.h
//  SpeedLocator
//
//  Created by Kevin Cox on 5/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLitePersistentObject.h"

@interface SpeedMeasurement : SQLitePersistentObject {
	double lat;
	double lon;
	double speed;
	NSString *notes;
	NSDate *timestamp;
}

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
@property (nonatomic, assign) double speed;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSDate *timestamp;

@end
