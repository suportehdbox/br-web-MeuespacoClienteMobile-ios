//
//  SinistroNovoDataHoraViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoDataHoraViewController.h"
#import "LibertyMobileAppDelegate.h"
#import "Util.h"


@implementation SinistroNovoDataHoraViewController

@synthesize managedObjectContext;
@synthesize event;
@synthesize editable;

@synthesize txtDateTime;
@synthesize datePickerDateTime;

@synthesize selectedDate;
@synthesize dateFormatter;
@synthesize minDate;
@synthesize maxDate;

-(id)initWithEventTime:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoDataHoraViewController" bundle:nil])) 
    {
        self.event = eventInit;
        self.managedObjectContext = theManagedObjectContext;
        self.editable = canEdit;
        
        if (eventInit.incidentDateTime) {
            self.selectedDate = eventInit.incidentDateTime;
        }
        else {
            self.selectedDate = [NSDate date];            
        }
        self.dateFormatter = nil;
        self.minDate = nil;
        self.maxDate = [NSDate date];
        
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

- (void)dealloc
{
    [super dealloc];
    
	datePickerDateTime = nil;
	txtDateTime = nil;

	[selectedDate release];
	[dateFormatter release];
	[minDate release];
	[maxDate release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    
    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Data do Sinistro";
    
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
        UIBarButtonItem *concluidoButton = [Util addCustomButtonNavigationBar:self action:@selector(btnConcluido:) imageName:@"btn-concluido-lm.png"];
        self.navigationItem.rightBarButtonItem = concluidoButton;
        [concluidoButton release];
    }
    
    [self setupDatePicker];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //TODO - ask the user if they want to save uncommitted changes?
    [self rollbackState];
	[super viewWillDisappear:animated];
}

-(NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - private methods

- (void)setupDatePicker
{
	//default to the current date if the delegate did not preset the date
	if (nil == self.selectedDate)
	{
		self.selectedDate = [NSDate date];
	}
	
	//set format to date and time if delegate did not specify format
	if(nil == self.dateFormatter)
	{
		self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
       [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
	}
	
	//set the date on the picker and label
	self.datePickerDateTime.date = self.selectedDate;
	self.txtDateTime.text = [self.dateFormatter stringFromDate: self.selectedDate];

	//if max and/or min date are specified, set them on the picker
	if(self.minDate)
	{	
		self.datePickerDateTime.minimumDate = self.minDate;
	}
	if(self.maxDate)
	{	
		self.datePickerDateTime.maximumDate = self.maxDate;
	}
    
    [self.datePickerDateTime setEnabled:editable];
}

#pragma mark - Custom Methods

-(void) saveState
{
    //save the changes to the data model
    [(LibertyMobileAppDelegate *) [[UIApplication sharedApplication] delegate] saveState];
}

-(void) rollbackState {	
    //save the changes to the data model
    [(LibertyMobileAppDelegate *) [[UIApplication sharedApplication] delegate] rollbackState];
}

#pragma mark -s Actions

- (IBAction)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnConcluido:(id)sender
{
    self.event.incidentDateTime = datePickerDateTime.date;
    [self saveState];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dateChanged:(id)sender
{
	self.txtDateTime.text = [dateFormatter stringFromDate:self.datePickerDateTime.date];
}

@end
