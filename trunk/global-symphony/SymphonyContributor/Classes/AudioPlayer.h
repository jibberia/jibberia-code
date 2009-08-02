/*
 *  AudioPlayer.h
 *  SymphonyContributor
 *
 *  Created by Paul Ossenbruggen on 8/1/09.
 *
 */
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AudioPlayer : NSObject<AVAudioPlayerDelegate>
{
	NSString *errorString;
	BOOL playing;
	AudioPlayer *mAudioPlayer;
	BOOL looping;
	NSURL *mUrl;
}

typedef enum 
{
	kPlayerNoError,
	kPlayerCategoryErr,
	kPlayerActiveErr,
	kPlayerAllocFailed
	
} PlayerErrors;

- (PlayerErrors)playUrl:(NSURL*)file;
- (void)playStop;

@property (nonatomic, retain) NSString *errorString;
@property BOOL playing;
@property BOOL looping;

@end