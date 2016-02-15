//
//  SinistroNovoCompartilharViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoCompartilharViewController.h"
#import "Util.h"
#import "TextFieldTableViewCell.h"
#import "TextViewFieldTableViewCell.h"
#import "KeyboardNavigationBar.h"
#import "LibertyMobileAppDelegate.h"
#import "TemplateProcessor.h"
#import "BotaoAmareloTableViewCell.h"


@implementation SinistroNovoCompartilharViewController

@synthesize managedObjectContext;
@synthesize eventUser;
@synthesize editable;
@synthesize uiAlertView;

//Tag's Defines
#define FIELD_TAG_NAME              1
#define FIELD_TAG_LASTNAME          2
#define FIELD_TAG_POLICY            3
#define FIELD_TAG_PHONE             4

#define MAX_FIELD_TAG               4

#define SECTION_DADOS_CONTATO       0
#define SECTION_COMPARTILHAR        1

#define SECTION_TOTAL               2


-(id)initWithEventShare:(User *)eventUserInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoCompartilharViewController" bundle:nil])) 
    {
        self.eventUser = eventUserInit;
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

- (void)dealloc
{
    [super dealloc];
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
    
    // Pegar o caminho do plist
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"SinistroNovoCompartilhar" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    arrayFields = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];        
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Compartilhar dados";
    
    [Util dropTableBackgroudColor:self.camposTableView];
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *cancelButton = [Util addCustomButtonNavigationBar:self action:@selector(btnCancel:) imageName:@"btn-cancelar-lm.png"];
//    self.navigationItem.leftBarButtonItem = cancelButton;
//    [cancelButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnCancel:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    
    [camposTableView setDataSource:self];
    [camposTableView setDelegate:self];
    
    [camposTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellTextField"];
    [camposTableView registerNib:[UINib nibWithNibName:@"BotaoAmareloTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellButton"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	//Push changes into model before rolling back
	//[super.activeTextField resignFirstResponder];
	
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int iCount = [Util getCountSectionArray:section sourceArray:arrayFields];
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iSection = indexPath.section;
    int iPositionReal = [Util getPositionSectionArray:iSection numRow:indexPath.row sourceArray:arrayFields];
    NSMutableDictionary* dict = [arrayFields objectAtIndex:iPositionReal];
    int iTag = [[dict objectForKey:@"tag"] intValue];

    switch (indexPath.section)
    {
        case SECTION_DADOS_CONTATO:
            {
                TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTextField"];
                
                [cell.txtField setDelegate:self];
                cell.lblField.text = [dict objectForKey:@"menuItem"];
                cell.txtField.tag = iTag;
                
                cell.txtField.placeholder = [dict objectForKey:@"placeholder"];
                
                //Which table/cell are we talking about
                switch (iTag)
                {
                    case FIELD_TAG_NAME:
                        cell.txtField.text = self.eventUser.firstName;
                        cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
                        break;
                    case FIELD_TAG_LASTNAME:
                        cell.txtField.text = self.eventUser.lastName;
                        cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
                        break;
                    case FIELD_TAG_POLICY:
                        cell.txtField.text = self.eventUser.autoPolicyNumber;
                        cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
                        break;
                    case FIELD_TAG_PHONE:
                        cell.txtField.text = self.eventUser.homePhone;
                        cell.txtField.keyboardType = UIKeyboardTypePhonePad;
                        break;
                    default:
                        break;
                }
                
                return cell;
            }
            
        case SECTION_COMPARTILHAR:
            {
                // Caso seja a linha do Botão Amarelo
                return [Util getViewButtonTableViewCell:self action:@selector(btnCompartilhar:) textButton:[dict objectForKey:@"menuItem"] tableView:tableView];
            }
    }
    return nil;
}


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
    //Open the Keyboard
    //[Util openKeyBoardTableView:[tableView cellForRowAtIndexPath:indexPath]];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iPositionReal = [Util getPositionSectionArray:indexPath.section numRow:indexPath.row sourceArray:arrayFields];
    NSMutableDictionary* dict = [arrayFields objectAtIndex:iPositionReal];
    BOOL bHeader = [[dict objectForKey:@"header"] boolValue];
    
    if (bHeader) return 35.0;
    
    return tableView.rowHeight;
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger lengthAfterChange = [textField.text length] + [string length];   
    NSInteger maxLength = [Util getFieldLengthByFieldTagArray:textField.tag sourceArray:arrayFields];
    
    //only allow the max characters
    if (lengthAfterChange  > maxLength){
        return FALSE;
    }
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    //determine which field is being edited and save the data to the right place in the model
    NSInteger field = theTextField.tag;
    NSString *mystring = [[NSString alloc] initWithString:[theTextField text]];

    ///---------
    //Which table/cell are we talking about   
    switch (field)
    {
        case FIELD_TAG_NAME:
            self.eventUser.firstName = mystring;
            break;
        case FIELD_TAG_LASTNAME:
            self.eventUser.lastName = mystring;
            break;
        case FIELD_TAG_PHONE:
            self.eventUser.homePhone = mystring;
            break;
        case FIELD_TAG_POLICY:
            self.eventUser.autoPolicyNumber = mystring;
            break;
         default:
            break;
    }
    
    [mystring release];
    //----------------------------------
}


-(void) saveState
{
    //save the changes to the data model
    [(LibertyMobileAppDelegate *) [[UIApplication sharedApplication] delegate] saveState];
}

-(void) rollbackState {	
    //save the changes to the data model
    [(LibertyMobileAppDelegate *) [[UIApplication sharedApplication] delegate] rollbackState];
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
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compartilhe suas informações" 
															message:@"Envio de emails indisponivel" 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			self.uiAlertView = alert;
			[alert show];
			[alert release];
		}
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compartilhe suas informações" 
														message:@"Envio de emails indisponivel" 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		self.uiAlertView = alert;
		[alert show];
		[alert release];
	}
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
	
	
	TemplateProcessor *templateProcessor = [[TemplateProcessor alloc] init];
	[templateProcessor setTemplateDictionary:emailDictionary];
    
	[picker setSubject:@"Informação de Seguro Automóvel"];
	
	NSString *emailBody = [templateProcessor processTemplate:[emailDictionary valueForKey:@"ShareInfoTemplate"] withObject:eventUser];
	[templateProcessor release];
	
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compartilhe suas informações"
														message:@"Ocorreu um erro" 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		self.uiAlertView = alert;
		[alert show];
		[alert release];
	}
	else {
		switch (result)
		{
			case MFMailComposeResultCancelled:				
				break;
			case MFMailComposeResultSaved:
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compartilhe suas informações" 
																message:@"O seu mail foi guardado mas não enviado" 
															   delegate:nil 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
				self.uiAlertView = alert;
				[alert show];
				[alert release];
			}
				break;
			case MFMailComposeResultSent:
			{
				//Added this alert back to remain consistent with the response we get when sending claim info to the outbox
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compartilhe suas informações" 
																message:@"Dados enviados com sucesso para a caixa de saída de email"
															   delegate:nil 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
				self.uiAlertView = alert;
				[alert show];
				[alert release];
			}				
				break;
			case MFMailComposeResultFailed:
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compartilhe suas informações"
																message:@"Erro inesperado" 
															   delegate:nil 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
				self.uiAlertView = alert;
				[alert show];
				[alert release];
			}
				break;
			default:
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Erro inerente ao enviar Email"
															   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				self.uiAlertView = alert;
				[alert show];
				[alert release];
			}
				
				break;
		}
		
		[self dismissModalViewControllerAnimated:YES];
		[[self navigationController] popViewControllerAnimated:YES];
	}
}

#pragma mark - Action

- (IBAction)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCompartilhar:(id)sender
{
	//Push changes into model before rolling back
	[super.activeTextField resignFirstResponder];
	
    //hide the keyboard
    [self.view endEditing:YES];
    
    [self saveState];

    [self composeEmail];
}

@end

