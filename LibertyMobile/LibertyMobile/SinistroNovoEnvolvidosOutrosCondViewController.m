//
//  SinistroNovoEnvolvidosOutrosCondViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoEnvolvidosOutrosCondViewController.h"
#import "Util.h"
#import "TextFieldTableViewCell.h"
#import "TextViewFieldTableViewCell.h"
#import "KeyboardNavigationBar.h"
#import "LibertyMobileAppDelegate.h"


@implementation SinistroNovoEnvolvidosOutrosCondViewController

@synthesize managedObjectContext;
@synthesize editable;
@synthesize newRecord;
@synthesize driver;
@synthesize uiAlertView;
@synthesize uiActionSheet;

//Tag's Defines
#define FIELD_TAG_NAME                  1
#define FIELD_TAG_LASTNAME              2
#define FIELD_TAG_PHONE                 3
#define FIELD_TAG_EMAIL                 4
#define FIELD_TAG_INSUANCECOMPANY       5
#define FIELD_TAG_POLICY                6
#define FIELD_TAG_YEAR                  7
#define FIELD_TAG_MAKE                  8
#define FIELD_TAG_MODEL                 9
#define FIELD_TAG_COLOR                 10
#define FIELD_TAG_LICENSE_PLATE_NUMBER  11
#define FIELD_TAG_NOTES                 12

#define SECTION_DADOS_CONTATO       0
#define SECTION_DADOS_VEICULO       1
#define SECTION_DADOS_NOTAS         2
#define SECTION_DELETE              3


-(id)initWithOtherDriver:(Driver *)driverInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andIsNew:(BOOL)isNew andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoEnvolvidosOutrosCondViewController" bundle:nil])) 
    {
        self.driver = driverInit;
        self.managedObjectContext = theManagedObjectContext;
        self.newRecord = isNew;
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
    
    // Pegar o caminho do plist
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"SinistroNovoEnvolvidosOutrosCondutores" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    arrayFields = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];        
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Outros condutores";
    
    [Util dropTableBackgroudColor:self.camposTableView];

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
        
        SECTION_TOTAL = 4;
    } else {
        SECTION_TOTAL = 3;
    }
    
    [self.camposTableView setDelegate:self];
    [self.camposTableView setDataSource:self];
    
    [self.camposTableView setContentInset:UIEdgeInsetsMake(20, self.camposTableView.contentInset.left, self.camposTableView.contentInset.bottom, self.camposTableView.contentInset.right)];
    
    [self.camposTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellTextField"];
    [self.camposTableView registerNib:[UINib nibWithNibName:@"TextViewFieldTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellViewField"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	//Push changes into model before rolling back
	[activeTextField resignFirstResponder];
	
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
    static NSString *CellIdentifier = @"Cell";
    int iSection = indexPath.section;
    int iPositionReal = [Util getPositionSectionArray:iSection numRow:indexPath.row sourceArray:arrayFields];
    NSMutableDictionary* dict = [arrayFields objectAtIndex:iPositionReal];
    BOOL bHeader = [[dict objectForKey:@"header"] boolValue];
    int iTag = [[dict objectForKey:@"tag"] intValue];


    if (bHeader == YES) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [dict objectForKey:@"menuItem"];
        cell.textLabel.textColor = [Util getColorHeader];
        
        return cell;
    }
    
    if (iSection == SECTION_DADOS_NOTAS && indexPath.row == 1) {
        
        TextViewFieldTableViewCell *cell = (TextViewFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellViewField"];
        
        cell.txtField.delegate = self;
        cell.txtField.tag = iTag;
        cell.txtField.text = self.driver.notes;
        cell.txtField.keyboardType = UIKeyboardTypeAlphabet;

        return cell;
    }
    
    TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTextField"];
    
    cell.txtField.delegate = self;
    cell.lblField.text = [dict objectForKey:@"menuItem"];
    cell.txtField.tag = iTag;
    cell.txtField.placeholder = [dict objectForKey:@"placeholder"];

    ///---------
    //Which table/cell are we talking about   
    switch (iTag)
    {
        case FIELD_TAG_NAME:
            cell.txtField.text = self.driver.firstName;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_LASTNAME:
            cell.txtField.text = self.driver.lastName;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_PHONE:
            cell.txtField.text = self.driver.homePhone;
            cell.txtField.keyboardType = UIKeyboardTypePhonePad;
            break;
        case FIELD_TAG_EMAIL:
            cell.txtField.text = self.driver.emailAddress;
            cell.txtField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case FIELD_TAG_INSUANCECOMPANY:
            cell.txtField.text = self.driver.insuranceCompany;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_POLICY:
            cell.txtField.text = self.driver.policyNumber;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_YEAR:
            if (self.driver.driverVehicle.year != 0) {
                cell.txtField.text = [NSString stringWithFormat:@"%i", [self.driver.driverVehicle.year intValue]];
            }
            else {
                cell.txtField.text = @"";
            }
            cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case FIELD_TAG_MAKE:
            cell.txtField.text = self.driver.driverVehicle.make;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_MODEL:
            cell.txtField.text = self.driver.driverVehicle.model;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_COLOR:
            cell.txtField.text = self.driver.driverVehicle.color;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_LICENSE_PLATE_NUMBER:
            cell.txtField.text = self.driver.driverVehicle.registrationNumber;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
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
    int iPositionReal = [Util getPositionSectionArray:indexPath.section numRow:indexPath.row sourceArray:arrayFields];
    NSMutableDictionary* dict = [arrayFields objectAtIndex:iPositionReal];
    BOOL bHeader = [[dict objectForKey:@"header"] boolValue];
        
    if (bHeader) return 35.0;
        
    if (indexPath.section == SECTION_DADOS_NOTAS && indexPath.row == 1) {
        return 90;
    }
    
    return tableView.rowHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_DELETE) return 50;
	return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == SECTION_DELETE && !newRecord) {
        return [Util getViewButtonTableView:self action:@selector(btnDelete:) textButton:@"Remover" imageName: @"bar-amarelo-lm.png"];
    }
    
    return nil;
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger lengthAfterChange = [textField.text length] + [string length];   
    NSInteger maxLength = [Util getFieldLengthByFieldTagArray:textField.tag sourceArray:arrayFields];
    
    //only allow the max characters
    if (lengthAfterChange  > maxLength)
    {
        return FALSE;
    }
    
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    if ([theTextField isKindOfClass:[UITextField class]]){
        
        if([theTextField text]){
            
            NSString *mystring = [[NSString alloc] initWithString:[theTextField text]];
            
            switch ([theTextField tag]){
                case FIELD_TAG_NAME:
                    [self.driver setFirstName:mystring];
                    break;
                case FIELD_TAG_LASTNAME:
                    [self.driver setLastName:mystring];
                    break;
                case FIELD_TAG_PHONE:
                    [self.driver setHomePhone:mystring];
                    break;
                case FIELD_TAG_EMAIL:
                    [self.driver setEmailAddress:mystring];
                    break;
                case FIELD_TAG_INSUANCECOMPANY:
                    [self.driver setInsuranceCompany:mystring];
                    break;
                case FIELD_TAG_POLICY:
                    [self.driver setPolicyNumber:mystring];
                    break;
                case FIELD_TAG_YEAR:
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [self.driver.driverVehicle setYear:[numberFormatter numberFromString:mystring]];
                    [numberFormatter release];
                }break;
                case FIELD_TAG_MAKE:
                    [self.driver.driverVehicle setMake:mystring];
                    break;
                case FIELD_TAG_MODEL:
                    [self.driver.driverVehicle setModel:mystring];
                    break;
                case FIELD_TAG_COLOR:
                    [self.driver.driverVehicle setColor:mystring];
                    break;
                case FIELD_TAG_LICENSE_PLATE_NUMBER:
                    [self.driver.driverVehicle setRegistrationNumber:mystring];
                    break;
            }
            
            [mystring release];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    return self.editable;
}


#pragma mark - Text View Delegate Methods

- (void) textViewDidBeginEditing:(UITextView *)theTextView 
{
    UITextView *myTextField = [theTextView retain];
    self.activeTextField = (UIControl*) myTextField;
    [myTextField release];
}

- (BOOL)textView:(UITextView *)theTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger lengthAfterChange = [theTextView.text length] + [text length];   
    
    //only allow 1000 characters
    if (lengthAfterChange  > 1000){
        return FALSE;
    }
    
    //for any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if ([theTextView isKindOfClass:[UITextView class]]){
        
        if([theTextView text]){
            
            NSString *mystring = [[NSString alloc] initWithString:[theTextView text]];
            
            switch ([theTextView tag]){
                case FIELD_TAG_NOTES:
                    [self.driver setNotes:mystring];
                    break;
            }
            
            [mystring release];
        }
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
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
	[activeTextField resignFirstResponder];
	
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
    
    if(![Util fieldIsValidString:self.driver.firstName andMinChars:1 andMaxChars:35])
    {
        return NO;
    }
    else if(![Util fieldIsValidString:self.driver.lastName andMinChars:1 andMaxChars:40])
    {
        return NO;
    }
    else if(![Util fieldIsValidString:self.driver.homePhone andMinChars:8 andMaxChars:12])
    {
        return NO;
    }
    return YES;
}


- (IBAction)btnDelete:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:nil
								  delegate:self 
								  cancelButtonTitle:@"Cancelar" 
								  destructiveButtonTitle:@"Remover" 
								  otherButtonTitles: nil];
	self.uiActionSheet = actionSheet;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	//if the user selected 'Delete'
	if (buttonIndex == 0)
	{
        //delete this object from the data model
        [self.managedObjectContext deleteObject:self.driver]; 
        [self saveState];
        [self.navigationController popViewControllerAnimated:YES];
	}
} 

@end
