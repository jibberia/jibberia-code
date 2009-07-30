//
//  SymphonyContributorAppDelegate.m
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/8/09.
//  Copyright Pinch Media 2009. All rights reserved.
//

#import "SymphonyContributorAppDelegate.h"
#import "MainViewController.h"

#import "Beacon.h"

@implementation SymphonyContributorAppDelegate

@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
//	[Beacon initAndStartBeaconWithApplicationCode:@"915c66a20d48d0c877ed5f2ab9a08ada" useCoreLocation:YES useOnlyWiFi:NO];
	
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}

//- (void)applicationWillTerminate:(UIApplication *)a {
//	[Beacon endBeacon];
//}

- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
