
//
//  SinistroNovoEnvolvidosPolicialViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoEnvolvidosPolicialViewController.h"
#import "Util.h"
#import "TextFieldTableViewCell.h"
#import "TextViewFieldTableViewCell.h"
#import "KeyboardNavigationBar.h"
#import "LibertyMobileAppDelegate.h"


@implementation SinistroNovoEnvolvidosPolicialViewController

//@synthesize camposTableView;
@synthesize managedObjectContext;
@synthesize policeOfficer;
@synthesize newRecord;
@synthesize editable;
@synthesize uiAlertView;
@synthesize uiActionSheet;

//Tag's Defines
#define FIELD_TAG_ENTITY            1
#define FIELD_TAG_LOCAL             2
#define FIELD_TAG_NOTES             3

#define SECTION_DADOS_CONTATO       0
#define SECTION_DADOS_NOTAS         1
#define SECTION_DELETE              2


-(id)initWithPoliceOfficer:(PoliceOfficer *)policeOfficerInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andIsNew:(BOOL)isNew andCanEdit:(BOOL)canEdit 
{
    if ((self = [super initWithNibName:@"SinistroNovoEnvolvidosPolicialViewController" bundle:nil])) 
    {
        self.policeOfficer = policeOfficerInit;
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
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    
    // Pegar o caminho do plist
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"SinistroNovoEnvolvidosPolicial" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    arrayFields = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];        
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Policial";
    
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
        
        SECTION_TOTAL = 3;
    } else {
        SECTION_TOTAL = 2;
    }
    
    [camposTableView setDelegate:self];
    [camposTableView setDataSource:self];

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
	[super.activeTextField resignFirstResponder];
	
    //TODO - ask the user if they want to save uncommitted changes?
    [self rollbackState];
    
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        cell.txtField.text = self.policeOfficer.notes;
        cell.txtField.keyboardType = UIKeyboardTypeAlphabet;

        return cell;
    }
    
    TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTextField"];
    
    cell.txtField.delegate = self;
    NSString* sTexto = [dict objectForKey:@"menuItem"];
    cell.lblField.text = sTexto;
    cell.txtField.tag = iTag;
    cell.txtField.placeholder = [dict objectForKey:@"placeholder"];
    
    ///---------
    //Which table/cell are we talking about   
    switch (iTag)
    {
        case FIELD_TAG_ENTITY:
            cell.txtField.text = self.policeOfficer.firstName;
            cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case FIELD_TAG_LOCAL:
            cell.txtField.text = self.policeOfficer.contactAddress.city;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == SECTION_DELETE && !newRecord) {
        return [Util getViewButtonTableView:self action:@selector(btnDelete:) textButton:@"Remover" imageName: @"bar-amarelo-lm.png"];
    }
    
    return nil;
}

#pragma mark - Text Field Delegate Methods
- (void) textFieldDidBeginEditing:(UITextField *)theTextField 
{
    UITextField *myTextField = [theTextField retain];
    super.activeTextField = myTextField;
    [myTextField release];
}

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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
    //make the keyboard go away
	[theTextField resignFirstResponder];
    
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    if ([theTextField isKindOfClass:[UITextField class]]){
        
        if([theTextField text]){
            
            NSString *mystring = [[NSString alloc] initWithString:[theTextField text]];
            
            switch ([theTextField tag]){
                case FIELD_TAG_ENTITY:
                    [self.policeOfficer setFirstName:mystring];
                    break;
                case FIELD_TAG_LOCAL:
                    [self.policeOfficer.contactAddress setCity:mystring];
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
    super.activeTextField = (UIControl*) myTextField;
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
                    [self.policeOfficer setNotes:mystring];
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

-(void) rollbackState
{
    //save the changes to the data model
    [(LibertyMobileAppDelegate *) [[UIApplication sharedApplication] delegate] rollbackState];
}

#pragma mark -
#pragma mark Custom Keyboard Navigation Bar Methods

- (UIView *)inputAccessoryView
{
	
	if (!self.keyboardNavigationBarView) {
		[[NSBundle mainBundle] loadNibNamed:@"KeyboardNavigationBar" owner:self options:nil];
		[self.keyboardNavigationBar setTranslucent:YES];
    }
    
    return self.keyboardNavigationBarView;
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
                                                        message:@"Por favor insira uma entidade e local válidos." 
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
	
	NSLog(@"%@     -/n %@",self.policeOfficer.firstName,self.policeOfficer.contactAddress.city);
    //At a minimum, first name, last name and phone number must be complete
    if(![Util fieldIsValidString:self.policeOfficer.firstName andMinChars:1 andMaxChars:40])
    {
        return NO;
    }
    else if(![Util fieldIsValidString:self.policeOfficer.contactAddress.city andMinChars:1 andMaxChars:40])
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
	uiActionSheet = nil;
    
	//if the user selected 'Delete'
	if (buttonIndex == 0)
	{
        //delete this object from the data model
        [self.managedObjectContext deleteObject:self.policeOfficer]; 
        [self saveState];
        [self.navigationController popViewControllerAnimated:YES];
	}
} 

@end
