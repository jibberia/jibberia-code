#import "AppDelegate.h"
#import "QuickTimeAudioUtils.h"

@implementation AppDelegate
@synthesize pathField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSLog(@"applicationDidFinishLaunching");

}
- (IBAction)go:(id)sender {
	NSLog(@"pathField value: %@", [pathField stringValue]);

	NSError *err;
	movie = [QTMovie movieWithFile:[pathField stringValue] error:&err];
	if (0 && err) { // TODO WTF
		NSLog(@"we got an error.");
		NSLog(@"error: %@", [err localizedDescription]);
	}
	
//	[self createLabelsArray];
	
	
	int idx = 0;
	
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
	
	for (QTTrack *track in [movie tracks]) {
		NSLog(@"got track of type '%@' named '%@'",
			  [track attributeForKey:@"QTTrackMediaTypeAttribute"],
			  [track attributeForKey:@"QTTrackDisplayNameAttribute"]
		);
		if ([[track attributeForKey:@"QTTrackMediaTypeAttribute"] isEqualToString:@"soun"]) {
			NSLog(@"... so set type");
			setAudioTrackChannelLayoutDiscrete([track quickTimeTrack], lbls[idx]);
			idx++;
		}
	}
	
	NSString *newPath = [[pathField stringValue] stringByReplacingOccurrencesOfString:@"." withString: @"-assigned."];
	NSLog(@"writing updated file to %@...", newPath);
	
	[movie writeToFile:newPath withAttributes:nil];
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
	if (movie) [movie release], movie = nil;
	[super dealloc];
}

/*


// Populate the track selector pop-up button  
- (void)populateTrackSelectorPopUpButton
{
	UInt32 index;
	NSArray	*arrayOfMovieTracks;
	
	[_audTrackSelectorPopUpButton removeAllItems];
//	[self setTrack:nil];
	
	if (movie == nil)
		return;
	
	// First, add the special item associated with the movie summary mix. 
	// This item does not have a track associated with it
	[_audTrackSelectorPopUpButton insertItemWithTitle:@"Summary Channel Layout" atIndex:0];
	[[_audTrackSelectorPopUpButton itemAtIndex:0] setRepresentedObject:nil];
	[_audTrackSelectorPopUpButton selectItemAtIndex:0];
	
	// Add to the pop-up menu, all the sound tracks of this movie
	arrayOfMovieTracks = [_currentMovie tracks];
	for (index = 0; index < [arrayOfMovieTracks count]; index++) 
	{
		if (trackMixesToAudioContext([[arrayOfMovieTracks objectAtIndex:index] quickTimeTrack]))
		{
			NSMutableString	*trackNumber;
			trackNumber = [[NSMutableString alloc] initWithFormat:@"Track %d: %@", index + 1,
						   [[arrayOfMovieTracks objectAtIndex:index] attributeForKey:@"QTTrackDisplayNameAttribute"]];
			[_audTrackSelectorPopUpButton addItemWithTitle:trackNumber];
			[[_audTrackSelectorPopUpButton lastItem] setRepresentedObject:(QTTrack*)[arrayOfMovieTracks objectAtIndex:index]];
			[trackNumber release];	
		}
	}
}
*/


// Create and add an InfoObject to the provided array
- (void)addLabelToLabelNamesArray:(NSMutableArray *)namesArray label:(AudioChannelLabel)thisLabel
{
	InfoObject *labelInfo = [[InfoObject alloc] init];
	NSString *labelStr = [NSString stringWithString:@""];
	UInt32 labelSize = sizeof(NSString*);
	AudioChannelDescription acd = {0};
	acd.mChannelLabel = thisLabel;
	(void)AudioFormatGetProperty(kAudioFormatProperty_ChannelName, 
								 sizeof(AudioChannelDescription), 
								 &acd, 
								 &labelSize, 
								 &labelStr);
	[labelInfo setItem:thisLabel andItemName:labelStr];
	[labelStr release];
	[namesArray addObject:labelInfo];
	[labelInfo release];
}

- (void)createLabelsArray
{
	// This tag gets us most of the labels that we are interested in
	AudioChannelLayoutTag	tag = kAudioChannelLayoutTag_MPEG_7_1_A;
	UInt32					layoutSize;
	AudioChannelLayout		*layout;
	UInt32					channel = 0;
	UInt32					numDiscreteChannels = 0;
	UInt32					numDeviceChannels;
	UInt32					index;
	OSStatus				err;
	
	if (noErr != AudioFormatGetPropertyInfo (kAudioFormatProperty_ChannelLayoutForTag, sizeof(AudioChannelLayoutTag), 
											 &tag, &layoutSize))
		goto bail;									
	
	layout = (AudioChannelLayout*)malloc(layoutSize);
	if (noErr != AudioFormatGetProperty(kAudioFormatProperty_ChannelLayoutForTag, sizeof(AudioChannelLayoutTag), 
										&tag, &layoutSize, layout))
		goto bail;
	
	if (noErr != expandChannelLayout(&layout, &layoutSize))
		goto bail;
	
	// Commonly used labels 
	for (channel = 0 ; channel < layout->mNumberChannelDescriptions; channel++)
	{
		AudioChannelLabel thisLabel = (AudioChannelLabel)(layout->mChannelDescriptions[channel]).mChannelLabel;
		[self addLabelToLabelNamesArray:_trackChannelLabelNames label:thisLabel];
		[self addLabelToLabelNamesArray:_extractionChannelLabelNames label:thisLabel];
	}
	
	// Center Surround
	[self addLabelToLabelNamesArray:_trackChannelLabelNames label:kAudioChannelLabel_CenterSurround];
	[self addLabelToLabelNamesArray:_extractionChannelLabelNames label:kAudioChannelLabel_CenterSurround];
	
	// Mono
	[self addLabelToLabelNamesArray:_trackChannelLabelNames label:kAudioChannelLabel_Mono];
	
	// Discrete Labels
//	if (_deviceLayout)
//		numDeviceChannels = _deviceLayout->mNumberChannelDescriptions;
	
	AudioChannelLayout *localDiscreteLayout;	
	err = getDiscreteExtractionLayout([movie quickTimeMovie], nil, &localDiscreteLayout);		
	if (!err)
		numDiscreteChannels = localDiscreteLayout->mNumberChannelDescriptions;
	if (localDiscreteLayout)
		free(localDiscreteLayout);
	
	numDiscreteChannels = (numDeviceChannels > numDiscreteChannels) ? numDeviceChannels : numDiscreteChannels;
	
	for (index = 0; index < numDiscreteChannels; index++)
	{
		AudioChannelLabel discreteLabel = (1L<<16) | index;
		[self addLabelToLabelNamesArray:_trackChannelLabelNames label:discreteLabel];
	}	
	// Unused (to disable output from this channel)
	[self addLabelToLabelNamesArray:_trackChannelLabelNames label:kAudioChannelLabel_Unused];
	
bail:
	if (layout)
		free(layout);
}

@end
