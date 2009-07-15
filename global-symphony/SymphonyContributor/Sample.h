//
//  Sample.h
//  SymphonyContributor
//
//  Created by Kevin Cox on 7/13/09.
//  Copyright 2009 Pinch Media. All rights reserved.
//

#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>


@interface Sample : NSObject {
	BOOL recording;
	AVAudioRecorder *recorder;
	NSString *recorderFilePath;
}

@end
