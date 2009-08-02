/*
 *  AudioPlayer.c
 *  SymphonyContributor
 *
 *  Created by Paul Ossenbruggen on 8/1/09.
 *
 */

#include "AudioPlayer.h"

@implementation AudioPlayer



@synthesize errorString;
@synthesize looping;
@synthesize playing;

- (id)init {
    if (self = [super init]) {
    }
    return self;
}
 
- (PlayerErrors)playUrl:(NSURL*)fileURL
{
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
	if (err) {
        errorString = [NSString stringWithFormat:@"audioSession error: %@ %d %@", [err domain], [err code], [[err userInfo] description]];
        return kPlayerCategoryErr;
	}
	
	[audioSession setActive:YES error:&err];
	if (err) {
        errorString = [NSString stringWithFormat:@"audioSession error: %@ %d %@", [err domain], [err code], [[err userInfo] description]];
        return kPlayerActiveErr;
	}
	
	NSLog(@"fileURL: %@", (NSString *)fileURL);
	mUrl = fileURL;
	AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&err];
	if (err) {
        errorString = [NSString stringWithFormat:@"audioSession error: %@ %d %@", [err domain], [err code], [[err userInfo] description]];
        return kPlayerAllocFailed;
	}
	player.delegate = self;
	[player prepareToPlay];
	[player play];	
	self.playing = YES;
	return kPlayerNoError;
}

- (void)playStop
{
	self.playing = NO;
}



/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog(@"[%@ audioPlayerDidFinishPlaying:%@ successfully:%d]", [self class], player, flag);
	if (self.looping) { 
		[self playUrl:mUrl];
	}
	self.playing = NO;
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	NSLog(@"[%@ audioPlayerDecodeErrorDidOccur:%@ error:%@]", [self class], player, error);
	self.playing = NO;
}

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	NSLog(@"[%@ audioPlayerBeginInterruption:%@]", [self class], player);
}

/* audioPlayerEndInterruption: is called when the audio session interruption has ended and this player had been interrupted while playing. 
 The player can be restarted at this point. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	NSLog(@"[%@ audioPlayerEndInterruption:%@]", [self class], player);
}


@end
