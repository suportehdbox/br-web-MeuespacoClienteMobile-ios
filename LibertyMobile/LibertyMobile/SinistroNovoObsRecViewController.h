//
//  SinistroNovoObsRecViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@interface SinistroNovoObsRecViewController : UIViewController <AVAudioSessionDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    NSManagedObjectContext *managedObjectContext;
	Event *event;
    BOOL editable;

	UIWebView *instructions;
    UIImageView *instructionsImg;
    
    NSURL *voiceNoteFile;
	AVAudioRecorder *recorder;
	AVAudioPlayer *player;
    NSTimer *recordingTimer;   
    NSTimer *meterTimer;
    
    UIButton *leftButton;
	UIButton *rightButton;
	
	UIProgressView *recordingProgress;
	UILabel *currentTimeLabel;
	UILabel *totalTimeLabel;
    
    UIActivityIndicatorView *activityIndicator;
    UILabel *meterDisplay;
	
	UIAlertView *uiAlertView;
	UIActionSheet *uiActionSheet;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Event *event;
@property BOOL editable;

@property (nonatomic, retain) IBOutlet UIWebView *instructions;
@property (nonatomic, retain) IBOutlet UIImageView *instructionsImg;

@property (nonatomic, retain) NSURL *voiceNoteFile;
@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSTimer *recordingTimer;
@property (nonatomic, retain) NSTimer *meterTimer;

@property (nonatomic, retain) IBOutlet UIButton *leftButton;
@property (nonatomic, retain) IBOutlet UIButton *rightButton;

@property (nonatomic, retain) IBOutlet UIProgressView *recordingProgress;
@property (nonatomic, retain) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalTimeLabel;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *meterDisplay;
@property (nonatomic, retain) UIAlertView *uiAlertView;
@property (nonatomic, retain) UIActionSheet *uiActionSheet;

-(id)initWithEventRecord:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit;

- (void) updateCurrentTime:(NSTimeInterval) currentTime andTotalTime: (NSTimeInterval) totalTime;
- (void) updateRecordingProgress: (NSTimer *) theTimer;
- (void) updatePlayingProgress: (NSTimer *) theTimer;
- (void) updateRecordingMeter: (NSTimer *) theTimer;
- (void) updatePlayingMeter: (NSTimer *) theTimer;
- (void) updateMeterDisplay: (float)currentPowerLevel;

- (void) updateButton:(UIButton *) theButton setTitle:(NSString *) theTitle andAction:(SEL) theAction andEnabled:(BOOL) isEnabled;
- (void) setStateDefault:(BOOL)voiceNotePresent;
- (void) setStateRecording;
- (void) setStatePausedRecording;
- (void) setStatePlaying;
- (void) setStatePausedPlaying;

- (void) startRecording;
- (void) pauseRecording;
- (void) resumeRecording;
- (void) stopRecording;
- (void) editRecording;
- (void) deleteRecording;

- (void) startPlaying;
- (void) pausePlaying;
- (void) resumePlaying;
- (void) stopPlaying;

- (void) rollbackState;
- (void) saveState;
- (void) applicationEnteredBackground;

@end
