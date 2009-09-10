#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <QTKit/QTKit.h>
#import "InfoObject.h"

@interface AppDelegate : NSObject {
	QTMovie *movie;
	NSTextField *pathField;
	
	NSMutableArray				*_trackChannelLabelNames;
	NSMutableArray				*_trackChannelLabelsMenusArray;
	NSMutableArray				*_trackChannelLabelsIndexOfSelectedMenuItemArray;
	
	NSMutableArray				*_extractionChannelLabelNames;
	NSMutableArray				*_extractionLayoutMenuList;	
}


@property (nonatomic, retain) IBOutlet NSTextField *pathField;
- (IBAction)go:(id)sender;


- (void)createLabelsArray;
- (void)addLabelToLabelNamesArray:(NSMutableArray *)namesArray label:(AudioChannelLabel)thisLabel;

void setAudioTrackChannelLayoutDiscrete(Track inTrack, AudioChannelLabel lbl);
OSStatus getTrackLayoutAndSize(Track track,  UInt32* outLayoutSize, AudioChannelLayout** outLayout);


@end
