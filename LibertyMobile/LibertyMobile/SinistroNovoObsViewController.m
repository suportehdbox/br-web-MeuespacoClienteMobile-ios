//
//  SinistroNovoObsViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoObsViewController.h"
#import "Util.h"
#import "DetailLabelTableViewCell.h"
#import "TextViewFieldTableViewCell.h"
#import "SinistroNovoObsRecViewController.h"
#import "KeyboardNavigationBar.h"
#import "LibertyMobileAppDelegate.h"


@implementation SinistroNovoObsViewController

@synthesize managedObjectContext;
@synthesize event;
@synthesize editable;

//Tag's Defines
#define FIELD_TAG_NOTES             1

#define MAX_FIELD_TAG               1

#define SECTION_DADOS_NOTAS         0
#define SECTION_DADOS_GRAVACAO      1

#define SECTION_TOTAL               2

-(id)initWithEventObs:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoObsViewController" bundle:nil])) 
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
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"SinistroNovoObservacoes" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    arrayFields = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];        
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Observações";
    
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
    }

    [self.camposTableView registerNib:[UINib nibWithNibName:@"DetailLabelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellDetail"];
    [self.camposTableView registerNib:[UINib nibWithNibName:@"TextViewFieldTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellViewField"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.camposTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	//Push changes into model before rolling back
	[super.activeTextField resignFirstResponder];
	
    //TODO - ask the user if they want to save uncommitted changes?
    //[self rollbackState];
    
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SECTION_TOTAL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Caso for a linha onde estive os dados da gravação, não tiver nenhuma gravação de voz e o sinistro foi enviado,
    //não aparecerá as informações
    if (section == SECTION_DADOS_GRAVACAO && self.event.lengthOfVoiceNote == 0 && !editable) return 0;
    
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
        cell.userInteractionEnabled = NO;
        
        return cell;
    }
    
    if (iSection == SECTION_DADOS_NOTAS && indexPath.row == 1) {
        
        TextViewFieldTableViewCell *cell = (TextViewFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellViewField"];
        
        cell.txtField.delegate = self;
        cell.txtField.tag = iTag;
        cell.txtField.text = event.notes;

        return cell;
    }
    
    DetailLabelTableViewCell *cell = (DetailLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellDetail"];
    
    cell.lblMenuItem.text = [dict objectForKey:@"menuItem"];

    NSString * voiceNoteLength = [NSString stringWithFormat:@"%2ld:%02ld", ((long) self.event.lengthOfVoiceNote / 60), ((long)self.event.lengthOfVoiceNote % 60)];
    cell.lblTextInfo.text = voiceNoteLength;        
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}



#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    if (indexPath.section == SECTION_DADOS_GRAVACAO && indexPath.row == 0)
    {
        SinistroNovoObsRecViewController *viewTela = [[SinistroNovoObsRecViewController alloc] initWithEventRecord:self.event andManagedObjectContext:self.managedObjectContext andCanEdit:editable];
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


#pragma mark - Text View Delegate Methods

- (void) textViewDidBeginEditing:(UITextView *)theTextView 
{
    UITextView *myTextField = [theTextView retain];
    super.activeTextField = (UIControl*)myTextField;
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
                    [self.event setNotes:mystring];
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


#pragma mark - Persistence

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

#pragma mark - Action

- (IBAction)btnCancel:(id)sender
{
    [self rollbackState];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnConcluido:(id)sender {
	//Push changes into model before rolling back
	[activeTextField resignFirstResponder];
	
    //hide the keyboard
    [self.view endEditing:YES];
    
    [self saveState];
    [self.navigationController popViewControllerAnimated:YES];
}

@end