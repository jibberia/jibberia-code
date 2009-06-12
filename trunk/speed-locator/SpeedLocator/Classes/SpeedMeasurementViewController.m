//
//  SpeedMeasurementViewController.m
//  SpeedLocator
//
//  Created by Kevin Cox on 5/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SpeedMeasurementViewController.h"
#import "SpeedLocatorAppDelegate.h"

@implementation SpeedMeasurementViewController

@synthesize speedSlider;

- (void)awakeFromNib {
//	NSLog(@"SpeedMeasurementViewController awakeFromNib");
	measurement = [[SpeedMeasurement alloc] init];
}

- (IBAction)speedChanged:(UISlider *)slider {
	measurement.speed = slider.value;
	
	NSLog(@"%@", measurement);
}

- (IBAction)saveSpeedMeasurement {
	CLLocationCoordinate2D loc = [SpeedLocatorAppDelegate shared].currentLocation;
	measurement.lat = loc.latitude;
	measurement.lon = loc.longitude;
	
	NSLog(@"about to save: %@", measurement);
	[measurement save];
	NSLog(@"done saving measurement.");
	measurement = [[SpeedMeasurement alloc] init];
}

- (void)dealloc {
	[measurement release], measurement = nil;
	[super dealloc];
}

@end






/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Initialization code
 NSLog(@"hi init speed mezh vc");
 }
 return self;
 }
 - (void)viewDidLoad {
 NSLog(@"viewDidLoad");
 }
 - (id)init {
 NSLog(@"init");
 self = [super init];
 return self;
 }
 - (id)initWithCoder:(NSCoder *)c {
 self = [super initWithCoder:c];
 NSLog(@"initWithCoder");
 return self;
 }
 
 
 
 Implement loadView if you want to create a view hierarchy programmatically
 - (void)loadView {
 }
 
 
 
 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 
 
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
 // Release anything that's not essential, such as cached data
 }
 
 */