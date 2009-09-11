#import "AppDelegate.h"

@implementation AppDelegate

@synthesize saveOptionRadioGroup;
@synthesize pathField;
@synthesize statusMsg;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	validMoviePaths = nil;
}

- (IBAction)pathFieldChanged:(id)sender {
	if (validMoviePaths != nil) {
		NSLog(@"validMoviePaths was not nil; release it and create a new one");
		[validMoviePaths release], validMoviePaths = nil;
	}
	validMoviePaths = [[NSMutableArray alloc] init];
	
	NSString *path = [pathField stringValue];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ( ![fileManager fileExistsAtPath:path]) {
		[statusMsg setStringValue:@"Invalid path"];
		return;
	}
	
	if ([fileManager fileExistsAtPath:path isDirectory:nil]) {
		NSError *err = nil;
		NSArray *files = [fileManager contentsOfDirectoryAtPath:path error:&err];

//		NSLog(@"begin iterating %@", path);
		for (NSString *fileName in files) {
//			NSLog(@" ");
//			NSLog(@"fileName='%@'", fileName);
//			NSLog(@"[path stringByAppendingPathComponent:fileName]='%@'", [path stringByAppendingPathComponent:fileName]);
//			NSLog(@"[fileName lastPathComponent]='%@'", [fileName lastPathComponent]);
//			NSLog(@"[fileName pathExtension]='%@'", [fileName pathExtension]);
			
			if ([[fileName pathExtension] isEqualToString:@"mov"]) {
				NSString *fullPath = [path stringByAppendingPathComponent:fileName];
				NSLog(@"Adding '%@'", fullPath);
				[validMoviePaths addObject:fullPath];
			}
		}
		
		[statusMsg setStringValue:[NSString stringWithFormat:@"Found %d movies", [validMoviePaths count]]];
	} else {
		[statusMsg setStringValue:@"Aww, just one?"];
	}
}

- (void)bailWithMessage:(NSString *)msg {
	NSLog(msg);
	[statusMsg setStringValue:msg];
}

- (IBAction)go:(id)sender {
	NSString *path = [pathField stringValue];
	NSLog(@"pathField value: %@", path);
	
	if (validMoviePaths == nil) {
		return [self bailWithMessage:@"No movies found!"];
	}
	
	for (NSString *moviePath in validMoviePaths) {
		NSLog(@"Assigning channels for %@", moviePath);
		[self assignChannelsToFileAtPath:moviePath];
	}
}

- (void)assignChannelsToFileAtPath:(NSString *)path {
	int idx = 0;
	NSError *err;
	QTMovie *movie = [QTMovie movieWithFile:path error:&err];
	if (0 && err) { // TODO WTF
		NSLog(@"we got an error.");
		NSLog(@"error: %@", [err localizedDescription]);
	}
	
	AudioChannelLabel lbls[8] = {
		kAudioChannelLabel_Left,
		kAudioChannelLabel_Center,
		kAudioChannelLabel_Right,
		kAudioChannelLabel_LFEScreen,
		kAudioChannelLabel_LeftSurround, 
		kAudioChannelLabel_RightSurround,
		kAudioChannelLabel_LeftTotal,
		kAudioChannelLabel_RightTotal
	};
	
	// safety check
	for (QTTrack *track in [movie tracks]) {
		if ([[track attributeForKey:@"QTTrackMediaTypeAttribute"] isEqualToString:@"soun"]) {
			idx++;
		}
	}
	
	if (idx != 8) {
		return [self bailWithMessage:[NSString stringWithFormat:@"'%@' does not have 8 audio tracks; skipping it", [path lastPathComponent]]];
	}
		
	
	idx = 0;
	
	for (QTTrack *track in [movie tracks]) {
//		NSLog(@"got track of type '%@' named '%@'",
//			  [track attributeForKey:@"QTTrackMediaTypeAttribute"],
//			  [track attributeForKey:@"QTTrackDisplayNameAttribute"]
//		);
		if ([[track attributeForKey:@"QTTrackMediaTypeAttribute"] isEqualToString:@"soun"]) {
//			NSLog(@"... so set type");
			setAudioTrackChannelLayoutDiscrete([track quickTimeTrack], lbls[idx]);
			idx++;
		}
	}
	
	if ([saveOptionRadioGroup selectedRow] == 0) { // update existing files
		[movie updateMovieFile];
	} else {
		NSString *newPath = [path stringByReplacingOccurrencesOfString:@"." withString: @"-assigned."];
		NSLog(@"writing updated file to %@...", newPath);
	
		[movie writeToFile:newPath withAttributes:nil];
	}
	NSLog(@"done.");
}


#define fieldOffset(type, field) ((size_t) &((type *) 0)->field)
const int kNumChannelDescr = 1;

void setAudioTrackChannelLayoutDiscrete(Track inTrack, AudioChannelLabel lbl)
{
    UInt32 trackChannelLayoutSize;
    AudioChannelLayout* trackChannelLayout = NULL;
	
    // Allocate a layout of the required size
    trackChannelLayoutSize = fieldOffset(AudioChannelLayout, 
										 mChannelDescriptions[kNumChannelDescr]);
    // Allocate buffer to hold the layout, initialize all bits to 0
    trackChannelLayout = (AudioChannelLayout*)calloc(1, trackChannelLayoutSize);
    assert(trackChannelLayout != nil);
	
    // A tag that indicates the type of layout used.
    // Our channel layout is described using audio channel descriptions -- see 
    // AudioChannelLayout.mChannelDescriptions below.
    trackChannelLayout->mChannelLayoutTag = kAudioChannelLayoutTag_UseChannelDescriptions;
	
    // A bitmap that describes which channels are present.
    // We are not using channel bitmaps to describe our layout, we are using
    // the array of AudioChannelDescriptions to define the mapping.
    trackChannelLayout->mChannelBitmap =  0 ;
	
    // The number of channel descriptions in the mChannelDescriptionsarray. 
    // We are using 4 channel descriptions, one each for: Discrete 0, Discrete 1, 
    // Discrete 2 and Discrete 3.
    trackChannelLayout->mNumberChannelDescriptions = kNumChannelDescr ;
	
    // mChannelLabel = A label that describes the role of the channel. In common cases, 
    // such as “Left” or “Right,” role implies location. In such cases, mChannelFlags 
    // and mCoordinates can be set to 0.
    //
    // This example sets the following channel roles:
    //
    // first channel -> play to the first speaker
    trackChannelLayout->mChannelDescriptions[0].mChannelLabel = lbl;
	//    // second channel -> play to the second speaker
	//    trackChannelLayout->mChannelDescriptions[1].mChannelLabel = kAudioChannelLabel_Center; 
	//    // third channel -> play to the third speaker
	//    trackChannelLayout->mChannelDescriptions[2].mChannelLabel = kAudioChannelLabel_Right;
	//    // fourth channel -> play to the fourth speaker
	//    trackChannelLayout->mChannelDescriptions[3].mChannelLabel = kAudioChannelLabel_LFEScreen;
	//	
	//    trackChannelLayout->mChannelDescriptions[4].mChannelLabel = kAudioChannelLabel_RearSurroundLeft; 
	//    trackChannelLayout->mChannelDescriptions[5].mChannelLabel = kAudioChannelLabel_RearSurroundRight;
	//    trackChannelLayout->mChannelDescriptions[6].mChannelLabel = kAudioChannelLabel_LeftTotal;
	//    trackChannelLayout->mChannelDescriptions[7].mChannelLabel = kAudioChannelLabel_RightTotal;
	
    // Flags that indicate how to interpret the data in the mCoordinates field. 
    // If the audio channel does not require this information, set this field to 0.
    trackChannelLayout->mChannelDescriptions[0].mChannelFlags = 
	//	trackChannelLayout->mChannelDescriptions[1].mChannelFlags = 
	//	trackChannelLayout->mChannelDescriptions[2].mChannelFlags = 
	//	trackChannelLayout->mChannelDescriptions[3].mChannelFlags = 
	//	trackChannelLayout->mChannelDescriptions[4].mChannelFlags = 
	//	trackChannelLayout->mChannelDescriptions[5].mChannelFlags = 
	//	trackChannelLayout->mChannelDescriptions[6].mChannelFlags = 
	//	trackChannelLayout->mChannelDescriptions[7].mChannelFlags = 
	kAudioChannelFlags_AllOff ;
	
    // Set the channel layout properties on the track
    OSErr err = QTSetTrackProperty(inTrack,
								   kQTPropertyClass_Audio,
								   kQTAudioPropertyID_ChannelLayout, 
								   trackChannelLayoutSize,
								   trackChannelLayout );
    assert(err == noErr);
	
    free((void *)trackChannelLayout);
}

- (void)dealloc {
	[super dealloc];
}

@end
