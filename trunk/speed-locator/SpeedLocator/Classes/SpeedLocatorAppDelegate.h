//
//  SpeedLocatorAppDelegate.h
//  SpeedLocator
//
//  Created by Kevin Cox on 5/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SpeedLocatorAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UITabBarController *tabBarController;
	CLLocationManager *locationManager;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (readonly) CLLocationManager *locationManager;
@property (readonly) CLLocationCoordinate2D currentLocation;

+ (SpeedLocatorAppDelegate *)shared;

@end
