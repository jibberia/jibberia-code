//
//  SpeedMeasurement.m
//  SpeedLocator
//
//  Created by Kevin Cox on 5/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SpeedMeasurement.h"


@implementation SpeedMeasurement

@synthesize lat;
@synthesize lon;
@synthesize speed;
@synthesize notes;
@synthesize timestamp;

- (id)init {
//	NSLog(@"SpeedMeasurement init");
	self = [super init];
	return self;
}

- (void)save {
	NSLog(@"[SpeedMeasurement save] (overridden) - setting timestamp, then saving");
	if (!lat) NSLog(@"!lat");
	self.timestamp = [NSDate date];
	[super save];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"SpeedMeasurement: %f at (%f, %f) [%@] \"%@\"", speed, lat, lon, timestamp, notes];
}

@end
