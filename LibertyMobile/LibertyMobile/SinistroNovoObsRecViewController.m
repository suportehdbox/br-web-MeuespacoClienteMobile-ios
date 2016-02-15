//
//  SinistroNovoObsRecViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoObsRecViewController.h"
#import "Util.h"
#import "LibertyMobileAppDelegate.h"

@implementation SinistroNovoObsRecViewController

@synthesize managedObjectContext;
@synthesize event;
@synthesize editable;

@synthesize instructions;
@synthesize instructionsImg;

@synthesize voiceNoteFile;
@synthesize recorder;
@synthesize player;
@synthesize recordingTimer;
@synthesize meterTimer;

@synthesize leftButton;
@synthesize rightButton;

@synthesize recordingProgress;
@synthesize currentTimeLabel;
@synthesize totalTimeLabel;

@synthesize activityIndicator;
@synthesize meterDisplay;
@synthesize uiAlertView;
@synthesize uiActionSheet;

static float const MAX_RECORDING_LENGTH = 90;

#define EDIT_RECORDING_ACTION_SHEET 0;


#pragma mark -
#pragma mark Init methods
-(id)initWithEventRecord:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoObsRecViewController" bundle:nil])) 
    {
        self.event = eventInit;
        self.managedObjectContext = theManagedObjectContext;
        self.editable = canEdit;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark Load/Unload
-(void)viewDidLoad
{   
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    
    // << EPO: oculta a parte de informação no caso landscape:
    BOOL isLandscape = UIDeviceOrientationIsLandscape(self.interfaceOrientation);
    if(isLandscape){
        instructions.hidden = YES;
        instructionsImg.hidden = YES;
    } else {
        instructions.hidden = NO;
        instructionsImg.hidden = NO;
    }
    // >>
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(applicationEnteredBackground) 
												 name:UIApplicationDidEnterBackgroundNotification 
											   object:nil];
	
    //Load the instructions
    [Util loadHtml:@"infoRecord" webViewControl:self.instructions];

    //create the audio session
    NSError *error;
	AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
	[audioSession setActive:YES error: &error];
	
	//turn on the speaker
	UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
	AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    [self setStateDefault:NO];

    if(self.event.lengthOfVoiceNote > 0)
    {
        [self setStateDefault:YES];
	}
    else
    {
        [self setStateDefault:NO];
    }
	
    //set up the buttons
    self.leftButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.leftButton.titleLabel.textAlignment = UITextAlignmentCenter;
    
    self.rightButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.rightButton.titleLabel.textAlignment = UITextAlignmentCenter;
	
    self.navigationItem.title = @"Gravação de Voz";    
    
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *cancelButton = [Util addCustomButtonNavigationBar:self action:@selector(btnCancel:) imageName:@"btn-cancelar-lm.png"];
//    self.navigationItem.leftBarButtonItem = cancelButton;
//    [cancelButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnCancel:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    

    if (editable) {
        //Adicionando o botão direito na NavigationBar
        UIBarButtonItem *concluidoButton = [Util addCustomButtonNavigationBar:self action:@selector(doneButtonPressed:) imageName:@"btn-concluido-lm.png"];
        self.navigationItem.rightBarButtonItem = concluidoButton;
        [concluidoButton release];
    }
    
    [self.activityIndicator stopAnimating];
}

- (void)applicationEnteredBackground {
	if (uiAlertView) {
		[uiAlertView dismissWithClickedButtonIndex:uiAlertView.cancelButtonIndex animated:NO];
	}
	if (uiActionSheet) {
		[uiActionSheet dismissWithClickedButtonIndex:uiActionSheet.cancelButtonIndex animated:NO];
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];
	self.instructions = nil;
	self.leftButton = nil;
	self.rightButton = nil;
	self.recordingProgress = nil;
	self.currentTimeLabel = nil;
	self.totalTimeLabel = nil;
	self.activityIndicator = nil;
	self.meterDisplay = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    //Stop the recorder
    [self.recorder stop];
    
    //Stop the timers
    [self.recordingTimer invalidate];
    [self.meterTimer invalidate];
    
    //Stop and reset the player
    [self.player stop];
    self.player.currentTime = 0;
    
    //TODO: - ask the user if they want to save uncommitted changes?
    [self rollbackState];
	[super viewWillDisappear:animated];
}

// << EPO: 
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // oculta a parte de informação no caso landscape:
    BOOL isLandscape = UIDeviceOrientationIsLandscape(toInterfaceOrientation);
    if(isLandscape){
        instructions.hidden = YES;
        instructionsImg.hidden = YES;
    } else {
        instructions.hidden = NO;
        instructionsImg.hidden = NO;
    }
}
// >>

#pragma mark -
#pragma mark View State Methods
//updates the progress indicators on the screen with the given current and total times
-(void) updateCurrentTime:(NSTimeInterval) currentTime andTotalTime: (NSTimeInterval) totalTime
{
	self.currentTimeLabel.text = [NSString stringWithFormat:@"%2ld:%02ld", ((long) currentTime / 60), ((long)currentTime % 60)];
    
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%2ld:%02ld", ((long) totalTime / 60), ((long)totalTime % 60)];
    
	//floor the current time so that the progress bar matches the seconds counter,
	//otherwise the seconds bar will appear ahead due to rounding
	self.recordingProgress.progress = floor(currentTime)/totalTime;
}

//updates the buttons on the screen with the proper titles and actions for the current funcationality
-(void) updateButton:(UIButton *) theButton setTitle:(NSString *) theTitle andAction:(SEL) theAction andEnabled:(BOOL) isEnabled
{
    //set the title of the button
    [theButton setTitle:theTitle forState:UIControlStateNormal];
    
    //remove any old actions associated with button
    [theButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    
    //add the new action to the button
    [theButton addTarget:self
                  action:theAction
        forControlEvents:UIControlEventTouchUpInside];
    
    //enable or disable the button
    theButton.enabled = isEnabled;
}

//sets up the screen in the default state
- (void)setStateDefault:(BOOL)voiceNotePresent
{
    //left button is play and enabled if voice note is present
	[self updateButton:self.leftButton setTitle:@"Reproduzir" andAction:@selector(startPlaying) andEnabled:voiceNotePresent];
    
    //right button is record/edit recording and enabled; timers are at 0 and either voicenote length or maximum length of voicenote if none is yet present
	if(voiceNotePresent)
	{
        [self updateCurrentTime:0 andTotalTime:self.event.lengthOfVoiceNote];
        if (editable) {
            [self updateButton:self.rightButton setTitle:@"Apagar\nGravação" andAction:@selector(editRecording) andEnabled:YES];
        } else {
            [self.rightButton setHidden:YES];
        }
	}
	else
	{
        [self updateCurrentTime:0 andTotalTime:MAX_RECORDING_LENGTH];
        [self updateButton:self.rightButton setTitle:@"Gravar" andAction:@selector(startRecording) andEnabled:YES];
        [self.rightButton setHidden:NO];
	}
    
    //Clear the meter
    [self updateMeterDisplay:-160];
}

//sets up the screen in the recording state
-(void) setStateRecording
{    
    //left button is Pause (Recording)
    [self updateButton:self.leftButton setTitle:@"Pausa" andAction:@selector(pauseRecording) andEnabled:YES];
    
    //right button is Stop (Recording)
    [self updateButton:self.rightButton setTitle:@"Parar" andAction:@selector(stopRecording) andEnabled:YES];
}

//updates the recording length label and progress bar while recording
-(void) updateRecordingProgress: (NSTimer *) theTimer 
{
	if(self.recorder.recording)
	{
        //update the model
        self.event.lengthOfVoiceNote = [self.recorder currentTime];

        //update the display
		[self updateCurrentTime:self.recorder.currentTime andTotalTime: MAX_RECORDING_LENGTH];
	}
}

//update the meter to show user recorder sound levels
- (void)updateRecordingMeter:(NSTimer *)timer 
{
	[recorder updateMeters];
	
    //get the current power level
    float currentPowerLevel = [recorder averagePowerForChannel:0];
    
    [self updateMeterDisplay:currentPowerLevel];
}

//sets up the screen in the paused recording state
-(void) setStatePausedRecording
{
    //left button is Resume Recording
    [self updateButton:self.leftButton setTitle:@"Continuar\nGravação" andAction:@selector(resumeRecording) andEnabled:YES];
    
    //right button is Stop (Recording)
    [self updateButton:self.rightButton setTitle:@"Parar" andAction:@selector(stopRecording) andEnabled:YES];
    
    //Clear the meter
    [self updateMeterDisplay:-160];
}

//sets up the screen in the playing state
-(void) setStatePlaying
{
    [self.rightButton setHidden:FALSE];

    //left button is Pause (Playing)
    [self updateButton:self.leftButton setTitle:@"Pausa" andAction:@selector(pausePlaying) andEnabled:YES];
    
    //right button is Stop (Playing)
    [self updateButton:self.rightButton setTitle:@"Parar" andAction:@selector(stopPlaying) andEnabled:YES];
}

//sets up the screen in the paused state
-(void) setStatePausedPlaying
{
    //left button is Resume Playing
    [self updateButton:self.leftButton setTitle:@"Continuar\nReprodução" andAction:@selector(resumePlaying) andEnabled:YES];
    
    //right button is Stop (Playing)
    [self updateButton:self.rightButton setTitle:@"Parar" andAction:@selector(stopPlaying) andEnabled:YES];
    
    //Clear the meter
    [self updateMeterDisplay:-160];
}

//update the playing length label and progress bar while recording
-(void) updatePlayingProgress: (NSTimer *) theTimer 
{
	if(self.player.playing)
	{
		[self updateCurrentTime:self.player.currentTime andTotalTime: self.player.duration];
	}
}

//update the meter to show user recorder sound levels
- (void)updatePlayingMeter:(NSTimer *)timer 
{
	[player updateMeters];
    
    //get the current power level
    float currentPowerLevel = [player averagePowerForChannel:0];
    
    [self updateMeterDisplay:currentPowerLevel];
	
}

- (void)updateMeterDisplay: (float)currentPowerLevel
{
    //power level is in decibels (-160 to 0), so add 160 to get positive numbers
    currentPowerLevel = (160 + currentPowerLevel); 
    
    //This shouldn't happen, but just in case, make sure the level does not get above 280 px wide
    if(currentPowerLevel > 280)
    {
        currentPowerLevel = 280;
    }
    
    //Update the meter display with a rectangle of width currentPowerLevel
    CGRect currentDisplayFrame = self.meterDisplay.frame;
    CGRect rect = CGRectMake(currentDisplayFrame.origin.x, currentDisplayFrame.origin.y, currentPowerLevel, currentDisplayFrame.size.height);
    
    self.meterDisplay.frame = rect;
}

#pragma mark -
#pragma mark AVAudioSession Delegate Methods
- (void) beginInterruption
{
    if(self.recorder.recording)
    {
        [self stopRecording];
    }
    
    if(self.player.playing)
    {
        [self stopPlaying];
    }
}

#pragma mark -
#pragma mark Recorder Methods

- (void) startRecording
{ 
    [self.activityIndicator startAnimating];
    
    //if the event already has a voice note, use it, otherwise create one
	if(nil == self.event.pathToVoiceNote)
	{
		//Get the path
		NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		
		NSString *documentFolderPath = [searchPaths objectAtIndex:0];
		
		//Add a timestamp to make it unique
		NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
		
		//Set the file name
		NSString *fileName = [[NSString alloc] initWithFormat:@"%0.0f%@", timestamp, @"EventVoiceNote.wav"];
		
		//Set the full path
		self.event.pathToVoiceNote = [documentFolderPath stringByAppendingPathComponent:fileName];
		[fileName release];
	}
    
    //Create the file to record to (if necessary)
    if (self.voiceNoteFile == nil)	
    {
		self.voiceNoteFile = [NSURL fileURLWithPath:self.event.pathToVoiceNote];
    }
    
    //Start the recording session
    NSMutableDictionary* recordSetting = [[[NSMutableDictionary alloc] init] autorelease];
	[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey]; 
	[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    //Create the recorder
    NSError *error;
    recorder = [[ AVAudioRecorder alloc] initWithURL:voiceNoteFile settings:recordSetting error:&error];
    
    if (error) 
    {	
        //There was an error.  Log it and alert the user
		NSLog(@"%@", [error localizedDescription]);
		
		switch (error.code)
        {
			case kAudioConverterErr_FormatNotSupported:
				NSLog(@"Audio File Format not Supported or inconsistent with extension");
				break;
			default:
				break;
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Em gravação" 
														message:@"Impossível Gravar" 
													   delegate:self 
                                              cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		self.uiAlertView = alert;
		[alert show];
		[alert release];
	}
	else 
    {
        //Set the state to recording
		[self setStateRecording];
		
		//Start recording, with maximium length of recording
		[recorder setDelegate:self];
        recorder.meteringEnabled = YES;
		[recorder prepareToRecord];
		[recorder recordForDuration:(NSTimeInterval)MAX_RECORDING_LENGTH];
        
        //Monitor the recording to update the timers
		self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(updateRecordingProgress:) userInfo:nil repeats: YES];
        
        //Monitor the recording to update the meter
        self.meterTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(updateRecordingMeter:) userInfo: nil repeats: YES];
	}
    [self.activityIndicator stopAnimating];
}

- (void) pauseRecording
{
    //Set the state to paused recording
    [self setStatePausedRecording];
    
    //Pause the recording session
    [self.recorder pause];
    
    //Stop the timers
    [self.recordingTimer invalidate];
    [self.meterTimer invalidate];
}

- (void) resumeRecording
{
    //Set the state to recording
    [self setStateRecording];
    
    //Resume the recording session
    [self.recorder recordForDuration:(NSTimeInterval)MAX_RECORDING_LENGTH];
    
    //Resume the timer
    self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target:self selector:@selector(updateRecordingProgress:) userInfo:nil repeats: YES];
    
    //Monitor the recording to update the meter
    self.meterTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(updateRecordingMeter:) userInfo: nil repeats: YES];
}

- (void) stopRecording
{    
    //Set the state to default
    [self setStateDefault:YES];
    
    //Stop the recorder
    [self.recorder stop];
    
    //Stop the timers
    [self.recordingTimer invalidate];
    [self.meterTimer invalidate];
}

- (void) editRecording
{
    //Ask the user whether they want to Delete the recording, Resume recording where they left off, or cancel
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:nil
								  delegate:self 
								  cancelButtonTitle:@"Cancelar" 
								  destructiveButtonTitle:@"Remover" 
								  otherButtonTitles: nil];
    self.uiActionSheet = actionSheet;
	actionSheet.tag = EDIT_RECORDING_ACTION_SHEET;
    
	[actionSheet showInView:self.parentViewController.view];
	
    [actionSheet release];
}

- (void) deleteRecording
{
    //Set the state to default
    [self setStateDefault:NO];
    
    //Delete the recording
    self.voiceNoteFile = nil;
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if(YES == [fileMgr fileExistsAtPath:self.event.pathToVoiceNote])
    {
        [fileMgr removeItemAtPath:self.event.pathToVoiceNote error:NULL];
    }
    
    //reset the voicenote length
    self.event.lengthOfVoiceNote = 0;
    self.event.pathToVoiceNote = nil;
    
    //must complete save because the deletion of the file cannot be undone
    [self saveState];
}

#pragma mark -
#pragma mark AVAudioRecorder Delegate Methods

-(void) audioRecorderDidFinishRecording:(AVAudioRecorder *)theRecorder successfully:(BOOL)successful
{	
	//stop the timers
	[self.recordingTimer invalidate];
    [self.meterTimer invalidate];
	
    //alert the user to any errors
    if(!successful)
    {
        NSLog(@"Recording did not finish successfully");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Em gravação" 
                                                        message:@"Impossível Gravar" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
		self.uiAlertView = alert;
        [alert show];
        [alert release];
    }
	
    //set the state to the default
	[self setStateDefault:YES];
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)theRecorder
{
    [self stopRecording];
}

#pragma mark -
#pragma mark Player Methods

- (void) startPlaying
{
    [self.activityIndicator startAnimating];
    
    //Create the player
    if(self.voiceNoteFile == nil)
    {
        self.voiceNoteFile = [NSURL fileURLWithPath:self.event.pathToVoiceNote];
    }
    NSError *error;
    self.player = [[[AVAudioPlayer alloc] initWithContentsOfURL:self.voiceNoteFile error:&error] autorelease];
	[self.player setDelegate:self];
    self.player.meteringEnabled = YES;
	
    //If there was an error, log it and alert the user
	if(error)
	{
        NSLog(@"%@", [error localizedDescription]);
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reproduzindo" 
														message:@"Impossível Reproduzir" 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		self.uiAlertView = alert;
		[alert show];
		[alert release];
	}
	else
	{
        //Set the state to playing
        [self setStatePlaying];
        
        //Start the player
        [self.player prepareToPlay];
        
        [self.player play];
        
        //Monitor the player to update the timers
        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updatePlayingProgress:) userInfo:nil repeats: YES];
        
        //Monitor the player to update the meter
        self.meterTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(updatePlayingMeter:) userInfo: nil repeats: YES];
	}
    
    [self.activityIndicator stopAnimating];
}

- (void) pausePlaying
{
    //Set the state to paused
    [self setStatePausedPlaying];
    
    //Pause the player
    [self.player pause];
    
    //Stop the timers
    [self.recordingTimer invalidate];
    [self.meterTimer invalidate];
}

- (void) resumePlaying
{
    //Set the state to playing
    [self setStatePlaying];
    
    //Start the player
    [self.player play];
    
    //Resume the timer
    self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updatePlayingProgress:) userInfo:nil repeats: YES];
    
    //Monitor the player to update the meter
    self.meterTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(updatePlayingMeter:) userInfo: nil repeats: YES];
}

- (void) stopPlaying
{
    //Set the state to the default
    [self setStateDefault:YES];
    
    //Stop and reset the player
    [self.player stop];
    self.player.currentTime = 0;
    
    //Stop the timers
    [self.recordingTimer invalidate];
    [self.meterTimer invalidate];
}

#pragma mark -
#pragma mark AVAudioPlayer Delegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)thePlayer successfully:(BOOL)successful
{
	//stop the timers
	[self.recordingTimer invalidate];
    [self.meterTimer invalidate];
	
    //alert the user to any errors
    if(!successful)
    {
        NSLog(@"Playing did not finish successfully");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reproduzindo" 
                                                        message:@"Impossível Reproduzir" 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
		self.uiAlertView = alert;
        [alert show];
        [alert release];
    }
	
    //set the state to the default
	[self setStateDefault:YES];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)thePlayer
{
    [self stopPlaying];
}

#pragma mark -
#pragma mark Action Sheet Delegate Methods

//actions to perform when user selects button in action sheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	uiActionSheet = nil;
	//if the user selected Delete
	if (buttonIndex == 0)
	{       
        //Delete the recording
        [self deleteRecording];
	}
} 

#pragma mark -
#pragma mark UI Actions
- (void)doneButtonPressed:(id)sender 
{    
    //Save any changes
    [self saveState];
    
    //Close the view
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Persistence

-(void) saveState
{
    //save the changes to the data model
    [(LibertyMobileAppDelegate *) [[UIApplication sharedApplication] delegate] saveState];
}

-(void) rollbackState 
{	
    //roll back the changes to the data model
    [(LibertyMobileAppDelegate *) [[UIApplication sharedApplication] delegate] rollbackState];
}

#pragma mark -
#pragma mark Memory Management

-(void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
    
	// Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [event release];

    [leftButton release];
    [rightButton release];
    [recordingProgress release];
    [currentTimeLabel release];
    [totalTimeLabel release];
    [instructions release];
    [voiceNoteFile release];
    [recorder release];
    [player release];
    [recordingTimer release];
    [meterTimer release];
    [meterDisplay release];
	[uiAlertView release];
	[uiActionSheet release];
	[super dealloc];
}


@end
