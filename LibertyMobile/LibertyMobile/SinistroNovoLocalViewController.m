//
//  SinistroNovoLocalViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoLocalViewController.h"
#import "Util.h"
#import "TextFieldTableViewCell.h"
#import "LibertyMobileAppDelegate.h"
#import "AtendimentoViewController.h"

@implementation SinistroNovoLocalViewController

@synthesize managedObjectContext;
@synthesize eventLocation;
@synthesize editable;

#define FIELD_TAG_ADDRESS       1
#define FIELD_TAG_CITY          2
#define FIELD_TAG_ZIPCODE       3

#define MAX_FIELD_TAG           3


#define ROW_LOCALIZAR_MAPA      0
#define ROW_ENDERECO            0
#define ROW_CIDADE              1
#define ROW_CEP                 2

#define SECTION_LOCALIZAR_MAPA  0
#define SECTION_DADOS_ENDERECO  1

#define SECTION_TOTAL           2

-(id)initWithEventLocal:(Address *)eventLocationInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoLocalViewController" bundle:nil])) 
    {
        self.eventLocation = eventLocationInit;
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
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Local do Sinistro";
   
    [Util dropTableBackgroudColor:self.camposTableView];

    // Pegar o caminho do plist
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"SinistroNovoLocal" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    camposItens = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];        

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
    int iCount = [Util getCountSectionArray:section sourceArray:camposItens];
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iSection = indexPath.section;
    
    if (iSection == SECTION_LOCALIZAR_MAPA) {
        
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = @"Localizar sinistro no Mapa";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
        
        if (!editable) [cell setHidden:YES];
        
        return cell;
    }
    else {
        
        TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTextField"];
        [cell.txtField setDelegate:self];
        
        int iPositionReal = [Util getPositionSectionArray:iSection numRow:indexPath.row sourceArray:camposItens];
        
        NSMutableDictionary* dict = [camposItens objectAtIndex:iPositionReal];
        NSString* sCampo = [dict objectForKey:@"menuItem"];
        cell.lblField.text = sCampo;
        
        int iTag = [[dict objectForKey:@"tag"] intValue];
        
        cell.txtField.tag = iTag;
        cell.txtField.placeholder = [dict objectForKey:@"placeholder"];
        
        ///---------
        //Which table/cell are we talking about   
        switch (iTag)
        {
            case FIELD_TAG_ADDRESS:
                cell.txtField.text = self.eventLocation.streetAddress;
                cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
                break;
            case FIELD_TAG_CITY:
                cell.txtField.text = self.eventLocation.city;
                cell.txtField.keyboardType = UIKeyboardTypeAlphabet;
                break;
            case FIELD_TAG_ZIPCODE:
                cell.txtField.text = self.eventLocation.zipCode;
                cell.txtField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            default:
                break;
        }
        //----------------------------------
        
        if (!editable) cell.txtField.clearButtonMode = UITextFieldViewModeNever;

        return cell;
    }
    
    return nil;
}


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ROW_LOCALIZAR_MAPA && indexPath.section == SECTION_LOCALIZAR_MAPA && editable) {
        SinistroNovoLocalMapaViewController *viewTela = [[SinistroNovoLocalMapaViewController alloc] init];
        viewTela.delegate = self;
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ROW_LOCALIZAR_MAPA && indexPath.section == SECTION_LOCALIZAR_MAPA && !editable) {
        return 0;
    }
    return tableView.rowHeight;
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger lengthAfterChange = [textField.text length] + [string length];   
    NSInteger maxLength = [Util getFieldLengthByFieldTagArray:textField.tag sourceArray:camposItens];
    
    //only allow the max characters
    if (lengthAfterChange  > maxLength){
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    return self.editable;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    if ([theTextField isKindOfClass:[UITextField class]]){
        
        if([theTextField text]){
            
            NSString *mystring = [[NSString alloc] initWithString:[theTextField text]];
            
            switch ([theTextField tag]){
                case FIELD_TAG_ADDRESS:
                    [self.eventLocation setStreetAddress:mystring];
                    break;
                case FIELD_TAG_CITY:
                    [self.eventLocation setCity:mystring];
                    break;
                case FIELD_TAG_ZIPCODE:
                    [self.eventLocation setZipCode:mystring];
                    break;
            }
            
            [mystring release];
        }
    }
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

#pragma mark -s MapView Local Delegate

- (void)mapaViewLocalViewController:(SinistroNovoLocalMapaViewController *)controller address:(NSString *)address city:(NSString *)city zipoCode:(NSString *)zipCode
{
    self.eventLocation.streetAddress = address;
    self.eventLocation.city = city;
    self.eventLocation.zipCode = zipCode;
    
    [self.camposTableView reloadData];
}

#pragma mark -s Actions

- (IBAction)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) btnConcluido:(id)sender {
	//Push changes into model before rolling back
	//[super.activeTextField resignFirstResponder];
    
    [self saveState];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

