//
//  SinistroNovoEnvolvidosViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoEnvolvidosViewController.h"
#import "Util.h"
#import "SinistroNovoAddTableViewCell.h"
#import "SinistroNovoEnvolvidosOutrosCondViewController.h"
#import "SinistroNovoEnvolvidosTestemunhaViewController.h"
#import "SinistroNovoEnvolvidosPolicialViewController.h"


@implementation SinistroNovoEnvolvidosViewController

@synthesize listaTableView;

@synthesize managedObjectContext;
@synthesize event;
@synthesize otherDrivers;
@synthesize witnesses;
@synthesize policeOfficers;
@synthesize uiAlertView;
@synthesize editable;

#define SECTION_OTHER_DRIVER    0
#define SECTION_WITNESS         1
#define SECTION_POLICE_OFFICER  2

#define SECTION_TOTAL           3

-(id)initWithNovoEventContact:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoEnvolvidosViewController" bundle:nil])) 
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
    
    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Contatos dos envolvidos";
    
    [Util dropTableBackgroudColor:self.listaTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *sinistroButton = [Util addCustomButtonNavigationBar:self action:@selector(btnSinistroNovo:) imageName:@"05_sinistrosdados-btn-novo.png"];
//    self.navigationItem.leftBarButtonItem = sinistroButton;
//    [sinistroButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnSinistroNovo:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    

    [self.listaTableView registerNib:[UINib nibWithNibName:@"SinistroNovoAddTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellSinistroAdd"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.otherDrivers = [event.eventDrivers allObjects];
    self.witnesses = [event.eventWitnesses allObjects];
    self.policeOfficers = [event.eventPoliceOfficers allObjects];
    
    [self.listaTableView reloadData];
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
    NSInteger rows = 0;
    
    switch (section)
    {
        case SECTION_OTHER_DRIVER:
            rows = [otherDrivers count] + (editable ? 2 : 1);
            break;
        case SECTION_WITNESS:
            rows = [witnesses count] + (editable ? 2 : 1);
            break;
        case SECTION_POLICE_OFFICER:
            rows = [policeOfficers count] + (editable ? 2 : 1);
            break;
        default:
            break;
            
    }
    
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    int iSection = indexPath.section;
    int iRow = indexPath.row;
    int iCount = 0;

    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        if (iSection == SECTION_OTHER_DRIVER) {
            cell.textLabel.text = @"Outros condutores";
        }
        else if (iSection == SECTION_WITNESS) {
            cell.textLabel.text = @"Testemunhas";
        }
        else if (iSection == SECTION_POLICE_OFFICER) {
            cell.textLabel.text = @"Policial";
        }
        
        cell.textLabel.textColor = [Util getColorHeader];
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    BOOL addButton = FALSE;
    
    switch (indexPath.section)
    {
        case SECTION_OTHER_DRIVER:
            iCount = [event.eventDrivers count];
            if (iCount + 1 == iRow) {
                addButton = TRUE;
            }
            else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                }

                Driver *otherDriver = [otherDrivers objectAtIndex:iRow - 1];
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", otherDriver.firstName, otherDriver.lastName];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.userInteractionEnabled = YES;
                return cell;
            }
            break;
        case SECTION_WITNESS:
            iCount = [event.eventWitnesses count];
            if (iCount + 1 == iRow) {
                addButton = TRUE;
            }
            else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                }

                Witness *witness = [witnesses objectAtIndex:iRow - 1];
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", witness.firstName, witness.lastName];        
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.userInteractionEnabled = YES;
                return cell;
            }
            break;
        case SECTION_POLICE_OFFICER:
            iCount = [event.eventPoliceOfficers count];
            if (iCount + 1 == iRow) {
                addButton = TRUE;
            }
            else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                }

                PoliceOfficer *policeOfficer = [policeOfficers objectAtIndex:iRow - 1];
                cell.textLabel.text = [NSString stringWithFormat:@"%@", policeOfficer.firstName];        
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.userInteractionEnabled = YES;
                return cell;
            }
            break;
        default:
            break;
            
    }
    
    if (addButton) {
        SinistroNovoAddTableViewCell *cell = (SinistroNovoAddTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellSinistroAdd"];
        
        return cell;        
    }
    
    return nil;
}



#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row > 0) {
        if (indexPath.section == SECTION_OTHER_DRIVER) {
            if ([event.eventDrivers count] + 1 == indexPath.row && editable) {
                [self addOtherDriver];
            }
            else {
                Driver *otherDriver = [otherDrivers objectAtIndex:indexPath.row - 1];
                SinistroNovoEnvolvidosOutrosCondViewController *viewTela = [[SinistroNovoEnvolvidosOutrosCondViewController alloc] initWithOtherDriver:otherDriver andManagedObjectContext:self.managedObjectContext andIsNew:FALSE andCanEdit:editable];
                [self.navigationController pushViewController:viewTela animated:YES];
                [viewTela release];
            }
        }
        else if (indexPath.section == SECTION_WITNESS) {
            if ([event.eventWitnesses count] + 1 == indexPath.row && editable) {
                [self addWitness];
            }
            else {
                Witness *witness = [witnesses objectAtIndex:indexPath.row - 1];
                SinistroNovoEnvolvidosTestemunhaViewController *viewTela = [[SinistroNovoEnvolvidosTestemunhaViewController alloc] initWithWitness:witness andManagedObjectContext:self.managedObjectContext andIsNew:FALSE andCanEdit:editable];  
                [self.navigationController pushViewController:viewTela animated:YES];
                [viewTela release];
            }
        }
        else if (indexPath.section == SECTION_POLICE_OFFICER) {
            if ([event.eventPoliceOfficers count] + 1 == indexPath.row && editable) {
                [self addPoliceOfficer];
            }
            else {
                PoliceOfficer *policeOfficer = [policeOfficers objectAtIndex:indexPath.row - 1];
                SinistroNovoEnvolvidosPolicialViewController *viewTela = [[SinistroNovoEnvolvidosPolicialViewController alloc] initWithPoliceOfficer:policeOfficer andManagedObjectContext:self.managedObjectContext andIsNew:FALSE andCanEdit:editable];  
                [self.navigationController pushViewController:viewTela animated:YES];
                [viewTela release];
            }
        }
    }

    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}

#pragma mark -s Custom Methods

-(void) addOtherDriver
{
    //user is only allowed to add two other drivers - check how many they already have first
    if([otherDrivers count] > 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:@"Você já inseriu o máximo de condutores" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
		self.uiAlertView = alert;
        [alert show];
        [alert release];
    }
    else
    {
        Driver *newDriver = (Driver *)[NSEntityDescription insertNewObjectForEntityForName:@"Driver" inManagedObjectContext:[self managedObjectContext]];
        [self.event addEventDriversObject:newDriver];
        
        Vehicle *newVehicle = (Vehicle *)[NSEntityDescription insertNewObjectForEntityForName:@"Vehicle" inManagedObjectContext:[self managedObjectContext]];
        newDriver.driverVehicle = newVehicle;
        
        SinistroNovoEnvolvidosOutrosCondViewController *viewTela = [[SinistroNovoEnvolvidosOutrosCondViewController alloc] initWithOtherDriver:newDriver andManagedObjectContext:self.managedObjectContext andIsNew:TRUE andCanEdit:TRUE];  
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
}

-(void) addWitness
{
    //user is only allowed to add two witnesses - check how many they already have first
    if([witnesses count] > 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:@"Você já inseriu o máximo de testemunhas" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
		self.uiAlertView = alert;
		[alert show];
        [alert release];
    }
    else
    {
        Witness *newWitness = (Witness *)[NSEntityDescription insertNewObjectForEntityForName:@"Witness" inManagedObjectContext:[self managedObjectContext]];
        [self.event addEventWitnessesObject:newWitness];
        
        SinistroNovoEnvolvidosTestemunhaViewController *viewTela = [[SinistroNovoEnvolvidosTestemunhaViewController alloc] initWithWitness:newWitness andManagedObjectContext:self.managedObjectContext andIsNew:TRUE andCanEdit:TRUE];  
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
}

-(void) addPoliceOfficer
{
    //user is only allowed to add two police officers - check how many they already have first
    if([policeOfficers count] > 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:@"Você já inseriu o máximo de policiais" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
		self.uiAlertView = alert;
        [alert show];
        [alert release];
    }
    else
    {
        PoliceOfficer *newPoliceOfficer = (PoliceOfficer *)[NSEntityDescription insertNewObjectForEntityForName:@"PoliceOfficer" inManagedObjectContext:[self managedObjectContext]];
		newPoliceOfficer.contactAddress = (Address *) [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:[self managedObjectContext]];
        [self.event addEventPoliceOfficersObject:newPoliceOfficer];
       
        SinistroNovoEnvolvidosPolicialViewController *viewTela = [[SinistroNovoEnvolvidosPolicialViewController alloc] initWithPoliceOfficer:newPoliceOfficer andManagedObjectContext:self.managedObjectContext andIsNew:TRUE andCanEdit:TRUE];  
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
}

#pragma mark -s Actions

- (IBAction)btnSinistroNovo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
