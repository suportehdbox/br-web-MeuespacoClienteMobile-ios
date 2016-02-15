//
//  SinistroNovoContatoViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoContatoViewController.h"
#import "Util.h"
#import "TextFieldTableViewCell.h"
#import "KeyboardNavigationBar.h"
#import "LibertyMobileAppDelegate.h"

@implementation SinistroNovoContatoViewController

@synthesize managedObjectContext;
@synthesize eventUser;
@synthesize editable;
@synthesize uiAlertView;


#define FIELD_TAG_NAME             1
#define FIELD_TAG_LASTNAME         2
#define FIELD_TAG_PHONE            3
#define FIELD_TAG_CELLPHONE        4
#define FIELD_TAG_EMAIL            5
#define FIELD_TAG_ADDRESS          6
#define FIELD_TAG_CITY             7
#define FIELD_TAG_ZIPCODE          8

#define SECTION_DADOS_CONTATO       0
#define SECTION_DADOS_ENDERECO      1

#define SECTION_TOTAL               2


-(id)initWithEvent:(User *)eventUserInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoContatoViewController" bundle:nil])) 
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
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"SinistroNovoContato" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    arrayFields = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];        

    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Dados do Contato";
    
    [Util dropTableBackgroudColor:super.camposTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *cancelButton = [Util addCustomButtonNavigationBar:self action:@selector(btnCancel:) imageName:@"btn-cancelar-lm.png"];
//    self.navigationItem.leftBarButtonItem = cancelButton;
//    [cancelButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnCancel:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    

    if (self.editable) {
        //Adicionando o botão direito na NavigationBar
        UIBarButtonItem *concluidoButton = [Util addCustomButtonNavigationBar:self action:@selector(btnConcluido:) imageName:@"btn-concluido-lm.png"];
        self.navigationItem.rightBarButtonItem = concluidoButton;
        [concluidoButton release];
    }
    
    [camposTableView setDelegate:self];
    [camposTableView setDataSource:self];
    
    [camposTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellTextField"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Push changes into model before rolling back
	//[super.activeTextField resignFirstResponder];
	
    //TODO - ask the user if they want to save uncommitted changes?
    [self rollbackState];
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
    
    TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTextField"];
    [cell.txtField setDelegate:self];
    
    int iPositionReal = [Util getPositionSectionArray:iSection numRow:indexPath.row sourceArray:arrayFields];
    
    NSMutableDictionary* dict = [arrayFields objectAtIndex:iPositionReal];
    int iTag = [[dict objectForKey:@"tag"] intValue];
    cell.lblField.text = [dict objectForKey:@"menuItem"];
    cell.txtField.tag = iTag;
    cell.txtField.placeholder = [dict objectForKey:@"placeholder"];
    
    ///---------
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
        case FIELD_TAG_PHONE:
            cell.txtField.text = self.eventUser.homePhone;
            cell.txtField.keyboardType = UIKeyboardTypePhonePad;
            break;
        case FIELD_TAG_CELLPHONE:
            cell.txtField.text = self.eventUser.mobilePhone;
            cell.txtField.keyboardType = UIKeyboardTypePhonePad;
            break;
        case FIELD_TAG_EMAIL:
            cell.txtField.text = self.eventUser.emailAddress;
            cell.txtField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case FIELD_TAG_ADDRESS:
            cell.txtField.text = self.eventUser.contactAddress.streetAddress;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_CITY:
            cell.txtField.text = self.eventUser.contactAddress.city;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_ZIPCODE:
            cell.txtField.text = self.eventUser.contactAddress.zipCode;
            cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }
    //----------------------------------
    
    if (!editable) cell.txtField.clearButtonMode = UITextFieldViewModeNever;

    return cell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    if ([theTextField isKindOfClass:[UITextField class]]){
        
        if([theTextField text]){
            
            NSString *myString = [[NSString alloc] initWithString:[theTextField text]];
            
            switch ([theTextField tag]){
                case FIELD_TAG_NAME:
                    [self.eventUser setFirstName:myString];
                    break;
                case FIELD_TAG_LASTNAME:
                    [self.eventUser setLastName:myString];
                    break;
                case FIELD_TAG_PHONE:
                    [self.eventUser setHomePhone:myString];
                    break;
                case FIELD_TAG_CELLPHONE:
                    [self.eventUser setMobilePhone:myString];
                    break;
                case FIELD_TAG_EMAIL:
                    [self.eventUser setEmailAddress:myString];
                    break;
                case FIELD_TAG_ADDRESS:
                    [self.eventUser.contactAddress setStreetAddress:myString];
                    break;
                case FIELD_TAG_CITY:
                    [self.eventUser.contactAddress setCity:myString];
                    break;
                case FIELD_TAG_ZIPCODE:
                    [self.eventUser.contactAddress setZipCode:myString];
                    break;
            }
            
            [myString release];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    return self.editable;
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

#pragma mark - Action

- (IBAction)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnConcluido:(id)sender
{
	//Push changes into model before rolling back
	[super.activeTextField resignFirstResponder];
	
    //hide the keyboard
    [self.view endEditing:YES];

    //make sure minimum requirements are met
    if([self validateFields])
    {
        [self saveState];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:@"Por favor insira um nome, sobrenome e telefone válidos." 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
		self.uiAlertView = alert;
        [alert show];
        [alert release];
    }
}

- (BOOL) validateFields
{   
    //At a minimum, first name, last name and phone number must be complete
    
    if(![Util fieldIsValidString:self.eventUser.firstName andMinChars:1 andMaxChars:35])
    {
        return NO;
    }
    else if(![Util fieldIsValidString:self.eventUser.lastName andMinChars:1 andMaxChars:40])
    {
        return NO;
    }
    else if(![Util fieldIsValidString:self.eventUser.homePhone andMinChars:8 andMaxChars:12])
    {
        return NO;
    }
    return YES;
}

@end
