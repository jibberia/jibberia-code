//
//  SpeedLocatorAppDelegate.m
//  SpeedLocator
//
//  Created by Kevin Cox on 5/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "SpeedLocatorAppDelegate.h"
#import "SpeedMeasurement.h"

@interface SpeedLocatorAppDelegate (Private)
- (void)testMeasurement;
- (void)testSelect;
- (void)initCoreLocation;
@end


@implementation SpeedLocatorAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize locationManager;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[self initCoreLocation];
	
	//	[self testSelect];
	
	//	[self testMeasurement];
	
	//	NSLog(@"");
	//	NSLog(@"---  DONE  ---");
	//	NSLog(@"");
	
	// Add the tab bar controller's current view as a subview of the window
	[window addSubview:tabBarController.view];
}

- (void)initCoreLocation {
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	[locationManager startUpdatingLocation];
	NSLog(@"(%f, %f)", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	NSLog(@"CL UPDATE: %@", newLocation);
	NSLog(@"(%f, %f)", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
}
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	NSLog(@"CL fail :(");
}
- (CLLocationCoordinate2D)currentLocation {
	return locationManager.location.coordinate;
}

+ (SpeedLocatorAppDelegate *)shared {
	return (SpeedLocatorAppDelegate *)[UIApplication sharedApplication];
}

- (void)testSelect {
	NSArray *ms = [SpeedMeasurement allObjects];
	for (SpeedMeasurement *m in ms) {
		NSLog(@"in db: %@", m);
	}
}

- (void)testMeasurement {
	SpeedMeasurement *measurement = [[SpeedMeasurement alloc] init];
	measurement.lat = 1;
	measurement.lon = 2;
	measurement.speed = 3;
	measurement.notes = @"first";
	measurement.timestamp = [NSDate date];
	
	
	NSLog(@"Measurement:");
	NSLog(@"%@", measurement);
	
	[measurement save];
	NSLog(@"measurement saved. release...");
	[measurement release], measurement = nil;
	
	NSLog(@"now find it...");
	//	measurement = [SpeedMeasurement findByNotes:@"first"];
	measurement = (SpeedMeasurement *)[SpeedMeasurement findByPK:1];
	NSLog(@"%@", measurement);
	
	[measurement release], measurement = nil;
}	

/*
 Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 }
 */

/*
 Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */


- (void)dealloc {
	[locationManager release], locationManager = nil;
	[tabBarController release];
	[window release];
	[super dealloc];
}

@end

