#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <QTKit/QTKit.h>

@interface AppDelegate : NSObject {
	NSMutableArray *validMoviePaths;
	
	NSMatrix *saveOptionRadioGroup;
	NSTextField *pathField;
	NSTextField *statusMsg;
	
	NSTextView *log;
}


@property (nonatomic, retain) IBOutlet NSMatrix *saveOptionRadioGroup;
@property (nonatomic, retain) IBOutlet NSTextField *pathField;
@property (nonatomic, retain) IBOutlet NSTextField *statusMsg;
@property (nonatomic, retain) IBOutlet NSTextView *log;

- (IBAction)go:(id)sender;
- (IBAction)pathFieldChanged:(id)sender;
- (IBAction)browse:(id)sender;

- (void)assignChannelsToFileAtPath:(NSString *)path;
- (void)validateAndAddMoviePath:(NSString *)path;
- (void)populateValidMoviePaths;
- (void)bailWithMessage:(NSString *)msg;

- (void)log:(NSString *)s, ...;

void setAudioTrackChannelLayoutDiscrete(Track inTrack, AudioChannelLabel lbl);
OSStatus getTrackLayoutAndSize(Track track,  UInt32* outLayoutSize, AudioChannelLayout** outLayout);

@end
