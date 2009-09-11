#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <QTKit/QTKit.h>

@interface AppDelegate : NSObject {
	NSMutableArray *validMoviePaths;
	
	NSMatrix *saveOptionRadioGroup;
	NSTextField *pathField;
	NSTextField *statusMsg;
	
//	NSMutableArray				*_trackChannelLabelNames;
//	NSMutableArray				*_trackChannelLabelsMenusArray;
//	NSMutableArray				*_trackChannelLabelsIndexOfSelectedMenuItemArray;
//	
//	NSMutableArray				*_extractionChannelLabelNames;
//	NSMutableArray				*_extractionLayoutMenuList;	
}


@property (nonatomic, retain) IBOutlet NSMatrix *saveOptionRadioGroup;
@property (nonatomic, retain) IBOutlet NSTextField *pathField;
@property (nonatomic, retain) IBOutlet NSTextField *statusMsg;
- (IBAction)go:(id)sender;
- (IBAction)pathFieldChanged:(id)sender;

- (void)assignChannelsToFileAtPath:(NSString *)path;

- (void)bailWithMessage:(NSString *)msg;

//- (void)createLabelsArray;
//- (void)addLabelToLabelNamesArray:(NSMutableArray *)namesArray label:(AudioChannelLabel)thisLabel;

void setAudioTrackChannelLayoutDiscrete(Track inTrack, AudioChannelLabel lbl);
OSStatus getTrackLayoutAndSize(Track track,  UInt32* outLayoutSize, AudioChannelLayout** outLayout);


@end
