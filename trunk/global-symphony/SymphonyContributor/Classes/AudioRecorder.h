/*
 *  AudioRecorder.h
 *  SymphonyContributor
 *
 *  Created by Paul Ossenbruggen on 8/1/09.
 *
 */
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"

@interface AudioRecorder : NSObject<AVAudioRecorderDelegate, CLLocationManagerDelegate>
{
	AVAudioRecorder *mRecorder;
	BOOL recording;
	NSString *errorString;
	NSURL *mRecordURL;
	CLLocationManager *locationManager;
	CLLocation *location;
	NSString *name;
	
	ASIFormDataRequest *request;
	UIActivityIndicatorView *progressDealie;
	
	BOOL musical;
}

typedef enum 
{
	kRecorderNoError,
	kRecorderAudioInputNotAvalible,
	kRecorderAudioDataError,
	kRecorderAllocFailed,
	kRecorderCategoryErr,
	kRecorderActiveErr
	
} RecorderErrors;

- (void)setProgressDealie:(UIActivityIndicatorView*)theProgressDealie;
- (RecorderErrors)recordToUrl:(NSURL*)file;
- (RecorderErrors)recordStop;
- (NSString*)errorString;
- (NSString*)filePathStr;
- (void)upload;
- (void)startUpdatingLocation;
- (void)invalidateLocation;

@property (nonatomic, retain) NSString *errorString;
@property BOOL recording;
@property (nonatomic, retain) NSString *name;

@property BOOL musical;

@end