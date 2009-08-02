/*
 *  AudioRecorder.h
 *  SymphonyContributor
 *
 *  Created by Paul Ossenbruggen on 8/1/09.
 *
 */
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AudioRecorder : NSObject<AVAudioRecorderDelegate>
{
	AVAudioRecorder *mRecorder;
	BOOL recording;
	NSString *errorString;
	NSURL *mRecordURL;

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

- (RecorderErrors)recordToUrl:(NSURL*)file;
- (RecorderErrors)recordStop;
- (NSString*)errorString;
- (NSString*)filePathStr;

@property (nonatomic, retain) NSString *errorString;
@property BOOL recording;

@end