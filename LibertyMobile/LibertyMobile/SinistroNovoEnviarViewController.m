//
//  SinistroNovoEnviarViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
 
#import "SinistroNovoEnviarViewController.h"
#import "LibertyMobileAppDelegate.h"
#import "TemplateProcessor.h"
#import "SendEvent.h"
#import "Constants.h"
#import "EventPhoto.h"
#import "Util.h"
 
@interface SinistroNovoEnviarViewController()
@property (nonatomic, retain) NSDictionary *contactsDictionary;
@end
 
@implementation SinistroNovoEnviarViewController

@synthesize event, user, managedObjectContext;
@synthesize delegate;
@synthesize webView, callButton, continueButton, activityIndicator;
@synthesize contactsDictionary;
@synthesize uiAlertView;

-(id)initWithEvent:(Event *)theEvent andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext
{
    if ((self = [super initWithNibName:@"SinistroNovoEnviarViewController" bundle:nil]))
    {
        self.event = theEvent;
        self.managedObjectContext = theManagedObjectContext;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[activityIndicator stopAnimating];
	
	[continueButton setEnabled:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[activityIndicator stopAnimating];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Enviar dados";
    
    [Util loadHtml:@"infoSend" webViewControl:self.webInfo];

	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationEnteredBackground)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];

	NSString *path = [[NSBundle mainBundle] pathForResource:@"LMContactDirectory" ofType:@"plist"];
	self.contactsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	
    [self.webView setBackgroundColor:[UIColor clearColor]];
	[self.webView setOpaque:NO];
    [self.webView setUserInteractionEnabled:YES];
    
    [self.view addSubview:webView];
	
	for (id subview in webView.subviews) {
		if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
			((UIScrollView *)subview).scrollEnabled = NO;
		}
	}
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *sinistroButton = [Util addCustomButtonNavigationBar:self action:@selector(btnSinistroNovo:) imageName:@"05_sinistrosdados-btn-novo.png"];
//    self.navigationItem.leftBarButtonItem = sinistroButton;
//    [sinistroButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnSinistroNovo:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
}

- (void)applicationEnteredBackground
{
	if (uiAlertView) {
		[uiAlertView dismissWithClickedButtonIndex:uiAlertView.cancelButtonIndex animated:NO];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
	self.webView = nil;
	self.callButton = nil;
	self.continueButton = nil;
	self.activityIndicator = nil;
}

- (void)dealloc
{
	[event release];
	[user release];
	[managedObjectContext release];
	
	[webView release];
	[callButton release];
	[continueButton release];
	[activityIndicator release];
	[contactsDictionary release];
	[uiAlertView release];
	[super dealloc];
}

#pragma mark Persistence Methods

-(void) markAsSent
{
	[self.event setEventStatus:@"Sent"];
	[self.event setSubmitDateTime:[NSDate date]];
	[(LibertyMobileAppDelegate *) [[UIApplication sharedApplication] delegate] saveState];
}

#pragma mark - Compose Mail Methods

// TODO: Code borrowed from Apple's MailComposer sample code. Plugged in for prototype purposes
// Probably belongs in it's own controller
- (void)composeEmail
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enviar dados para a Liberty Seguros"
															message:@"Envio de email não disponível"
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			self.uiAlertView = alert;
			[alert show];
			[alert release];
            
            [activityIndicator stopAnimating];
            
            [continueButton setEnabled:YES];
		}
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enviar dados para a Liberty Seguros"
														message:@"Envio de email não disponível"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		self.uiAlertView = alert;
		[alert show];
		[alert release];
	}
}

- (NSString *) subjectLineForSendEvent: (SendEvent *) aSendEvent
{
	// <<Auto/Home>> <<Last Name>> Claim Details <<Incident Date/Time>>
	NSMutableString *subjectLine = [NSMutableString stringWithCapacity:120];
	
	
	[subjectLine appendString:[aSendEvent.event.eventType intValue] == LMLineOfBusinessTypeAuto ? @"Automóvel " : @"Residência "];
	
	// (null) will appear for lastName if it is null.  Assuming it is required before getting here
	[subjectLine appendFormat:@"%@ Detalhes do Sinistro ", aSendEvent.user.lastName];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[subjectLine appendString: [dateFormatter stringFromDate:aSendEvent.event.incidentDateTime]];
	[dateFormatter release];
	
	return subjectLine;
}

// Displays an email composition interface inside the application. Populates all the Mail fields.
- (void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	//Path get the path to HelpItems.plist
	NSString *path=[[NSBundle mainBundle] pathForResource:@"Email" ofType:@"plist"];
	
	//Create the dictionary from the contents of the file.
	NSDictionary *emailDictionary=[NSDictionary dictionaryWithContentsOfFile:path];
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:[emailDictionary valueForKey:@"DefaultTo"]];
	
	[picker setToRecipients:toRecipients];
	
	TemplateProcessor *templateProcessor = [[TemplateProcessor alloc] init];
	[templateProcessor setTemplateDictionary:emailDictionary];
	SendEvent *sendEvent = [[SendEvent alloc] init];
	[sendEvent setEvent:event];
	[self loadUser];
	[sendEvent setUser:user];
	
	[picker setSubject:[self subjectLineForSendEvent: sendEvent]];
	
	// Add Photos
	NSArray *photoArray = nil;
	NSString *fileName = nil;
	EventPhoto *eventPhoto = nil;
	NSString *partialFileName = nil;
	NSMutableString *photoOrder = [NSMutableString stringWithCapacity:512];
    
	for (int sectionNumber = 0; sectionNumber < 4; sectionNumber++) {
		photoArray = [event sortedPhotoArrayForSection:sectionNumber];
        
		NSUInteger i, count = [photoArray count];
		for (i = 0; i < count; i++) {
			eventPhoto = [photoArray objectAtIndex:i];
			NSData *imageData = UIImageJPEGRepresentation([eventPhoto fullSizeImage], 1.0);
            //			NSData *imageData = UIImagePNGRepresentation([eventPhoto fullSizeImage]);
            
			if (LMLineOfBusinessTypeAuto == [event.eventType intValue]) {
				switch (sectionNumber) {
					case 0:
						partialFileName = @"O-Seu-Veiculo";
						break;
					case 1:
						partialFileName = @"Outros-Veiculos";
						break;
					case 2:
						partialFileName = @"Local-Do-Acidente";
						break;
					case 3:
						partialFileName = @"Documentos";
						break;
					default:
						partialFileName = @"Unknown";
						break;
				}
			} else if (LMLineOfBusinessTypeHome == [event.eventType intValue]) {
				switch (sectionNumber) {
					case 0:
						partialFileName = @"Local-Do-Sinistro";
						break;
					case 1:
						partialFileName = @"Danos";
						break;
					case 2:
						partialFileName = @"Documentos";
						break;
					default:
						partialFileName = @"Unknown";
						break;
				}
			}
			
			fileName = [NSString stringWithFormat:@"%@-%d.jpg", partialFileName, i+1];
			[picker addAttachmentData:imageData mimeType:@"image/jpg" fileName:fileName];
            //			fileName = [NSString stringWithFormat:@"%@-%d.png", partialFileName, i+1];
            //			[picker addAttachmentData:imageData mimeType:@"image/png" fileName:fileName];
			[photoOrder appendFormat:@"<li>%@</li>", fileName];
		}
	}
	[sendEvent setPhotoOrder:photoOrder];
	
	// Generate and add body
	NSString *emailBody = [templateProcessor processTemplate:[emailDictionary valueForKey:@"BodyTemplate"] withObject:sendEvent];
	[templateProcessor release];
	
    //	[picker addAttachmentData:[emailBody dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/html" fileName:@"claim_info.html"];
	[picker addAttachmentData:[[sendEvent applicationSignature] dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/ascii" fileName:@"app_info.txt"];
	[sendEvent release];
	
    //	[picker setMessageBody:@"There is an attachment issue in Outlook regarding image names.  See attached html file for claim data." isHTML:NO];
	[picker setMessageBody:emailBody isHTML:YES];
    
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// TODO: Do something here if error
	// Notifies users about errors associated with the interface
	
	if (error) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enviar dados para a Liberty Seguros"
														message:@"Ocorreu um erro"
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		alert.tag = LMSendInfoUIAlertViewTagSendResult;
		self.uiAlertView = alert;
		[alert show];
		[alert release];
	}
	else {
		switch (result)
		{
			case MFMailComposeResultCancelled:
                [self dismissModalViewControllerAnimated:YES];
				break;
			case MFMailComposeResultSaved:
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enviar dados para a Liberty Seguros"
																message:@"O seu mail foi salvo mas não enviado"
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				alert.tag = LMSendInfoUIAlertViewTagSendResult;
				self.uiAlertView = alert;
				[alert show];
				[alert release];
			}
				break;
			case MFMailComposeResultSent:
			{
				[self markAsSent];
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enviar dados para a Liberty Seguros"
																message:@"Os dados do sinistro foram enviados com sucesso para a caixa de saída de email. Você irá receber um email de confirmação após a recepção"
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				alert.tag = LMSendInfoUIAlertViewTagSendResult;
				self.uiAlertView = alert;
				[alert show];
				[alert release];
			}
				break;
			case MFMailComposeResultFailed:
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enviar dados para a Liberty Seguros"
																message:@"Erro desconhecido"
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				alert.tag = LMSendInfoUIAlertViewTagSendResult;
				self.uiAlertView = alert;
				[alert show];
				[alert release];
			}
				break;
			default:
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Erro desconhecido no envio do Email"
															   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				alert.tag = LMSendInfoUIAlertViewTagSendResult;
				self.uiAlertView = alert;
				[alert show];
				[alert release];
			}
				
				break;
		}
	}
}

#pragma mark -

- (IBAction)sendInfo:(id)sender
{
	[activityIndicator startAnimating];
	[continueButton setTitle:@"Preparando o email..." forState:UIControlStateNormal];
	[continueButton setEnabled:NO];
	[self composeEmail];
}

#pragma mark -

- (IBAction)placeCall:(id)sender
{
	NSString *tagString = [NSString stringWithFormat:@"%d", [self.event.eventType intValue]];
	
	NSDictionary *screenContactDictionary = [self.contactsDictionary valueForKey:@"ClaimDetail"];
	NSDictionary *aContactDictionary = [screenContactDictionary valueForKey:tagString];
	NSString *alertTitle = [aContactDictionary valueForKey:@"Label"];
	NSString *alertNumber = [aContactDictionary valueForKey:@"Number"];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
													message:alertNumber
												   delegate:self
										  cancelButtonTitle:@"Cancelar"
										  otherButtonTitles:@"Chamar", nil];
	alert.tag = LMSendInfoUIAlertViewTagCall;
	self.uiAlertView = alert;
	[alert show];
	[alert release];
}


#pragma mark - stolenFromMyInfo

- (void) loadUser
{
    //see if there is already user info entered
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    
    //Get the data
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:fetchRequest
                                                                               error:&error]mutableCopy];
	
    if(mutableFetchResults == nil)
    {
        //TODO: handle error
    }
    
    if([mutableFetchResults count] == 0)
    {
        //There is no user info yet - create it
        self.user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
        self.user.contactAddress = (Address *)[NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:managedObjectContext];
    }
    else
    {
        //There should only ever be one instance of user info, so use the first one
        self.user = (User *)[mutableFetchResults objectAtIndex:0];
    }
    [mutableFetchResults release];
    [fetchRequest release];
	
}

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	uiAlertView = nil;
	
	if (LMSendInfoUIAlertViewTagCall == alertView.tag)
	{
		if (1 == buttonIndex) {
			NSString *numberToCall = [NSString stringWithFormat:@"tel: %@", alertView.message];
			NSString *webReadyNumberToCall = [numberToCall stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:webReadyNumberToCall]];
		}
	}
	else if (LMSendInfoUIAlertViewTagSendResult == alertView.tag)
	{
        [continueButton setTitle:@"Sim, enviar agora" forState:UIControlStateNormal];
        [self dismissModalViewControllerAnimated:YES];
	}
}

- (IBAction)btnSinistroNovo:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
