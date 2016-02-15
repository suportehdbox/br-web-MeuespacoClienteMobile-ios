//
//  SinistroNovoTipoSinistroViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoTipoSinistroViewController.h"
#import "Util.h"
#import "LibertyMobileAppDelegate.h"


@implementation SinistroNovoTipoSinistroViewController

@synthesize tipoSinistroTableView;
@synthesize selTipoSinistro;
@synthesize managedObjectContext;
@synthesize event;
@synthesize editable;

-(id)initWithEventType:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext  andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoTipoSinistroViewController" bundle:nil])) 
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
    [super viewDidLoad];
    
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    
    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Tipo de Sinistro";
    
    [Util dropTableBackgroudColor:self.tipoSinistroTableView];

    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"TipoSinistro" ofType:@"plist"];
    tipoSinistros = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];
    
    self.selTipoSinistro = event.eventSubType;
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tipoSinistros count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    NSString* sTipo = [tipoSinistros objectAtIndex:indexPath.row];
    cell.textLabel.text = sTipo;


    if ([sTipo isEqualToString:self.selTipoSinistro]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editable) {
        if (self.selTipoSinistro != nil) {
            NSInteger index = [tipoSinistros indexOfObject:self.selTipoSinistro];
            NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
            checkedCell.accessoryType = UITableViewCellAccessoryNone;
        }

        // Set the checkmark accessory for the selected row
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    

        // Update the type of claim selected
        self.selTipoSinistro = [tipoSinistros objectAtIndex:indexPath.row];
    }

    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Custom Methods

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


#pragma mark -s Actions

- (IBAction)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnConcluido:(id)sender {
    [self.event setEventSubType:selTipoSinistro];
    [self saveState];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
