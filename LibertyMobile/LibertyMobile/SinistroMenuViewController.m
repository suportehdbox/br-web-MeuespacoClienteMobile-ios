//
//  SinistroMenuViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroMenuViewController.h"
#import "LibertyMobileAppDelegate.h"
#import "SinistroMenuHeaderTableViewCell.h"
#import "SinistroNovoViewController.h"
#import "Constants.h"
#import "DetailLabelTableViewCell.h"


@implementation SinistroMenuViewController

@synthesize menuTableView;
@synthesize managedObjectContext;
@synthesize iCountEvents;
@synthesize dadosLoginSegurado;

#define ROW_HEADER_MENU         0
#define ROW_NOVO_SINISTRO       1
#define ROW_CONSULTA_SINISTROS  2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
        dadosLoginSegurado = appDelegate.dadosSegurado;
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
    
    //Incluindo os Menus
    // Pegar o caminho do plist
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"SinistroMenu" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    menuItens = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];        

    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Sinistros";
    
    [GoogleAnalyticsManager send:@"Comunicação de Acidente"];
    
    [Util dropTableBackgroudColor:self.menuTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"btn-menu-lm.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnMenu:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    
    iCountEvents = [self getCountEvents];
    
    [menuTableView registerNib:[UINib nibWithNibName:@"SinistroMenuHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellSinistroHeader"];
    [menuTableView registerNib:[UINib nibWithNibName:@"DetailLabelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellDetail"];
}

- (void)viewDidUnload
{
    [menuItens dealloc];
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
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
    return [menuItens count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case ROW_HEADER_MENU:
            {
                SinistroMenuHeaderTableViewCell *cell = (SinistroMenuHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellSinistroHeader"];
                cell.userInteractionEnabled = NO;
                return cell;
            } break;
            
        default:
            {
                DetailLabelTableViewCell *cell = (DetailLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellDetail"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                NSMutableDictionary* dict = [menuItens objectAtIndex:indexPath.row - 1];
                cell.lblMenuItem.text = [dict objectForKey:@"menuItem"];
                
                cell.lblTextInfo.text = @"";
                if (iCountEvents != 0 && indexPath.row == ROW_CONSULTA_SINISTROS) {
                    cell.lblTextInfo.text = [NSString stringWithFormat:@"%d", iCountEvents];
                }
                
                return cell;
            }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == ROW_NOVO_SINISTRO) {
        SinistroNovoViewController *newSinistro = [[SinistroNovoViewController alloc] init];
        newSinistro.dadosLoginSegurado = self.dadosLoginSegurado;
        
        //Add Event in Database
        Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:[self managedObjectContext]];
        [event setEventType:[NSNumber numberWithInt:LMLineOfBusinessTypeAuto]];
        [event setCreateDateTime:[NSDate date]];
        [event setEventStatus:@"Draft"];
        [(LibertyMobileAppDelegate *) [[UIApplication sharedApplication] delegate] saveState];
        
        iCountEvents++;
        [menuTableView reloadData];
        
        newSinistro.managedObjectContext = self.managedObjectContext;
        newSinistro.event = event;
        [self.navigationController pushViewController:newSinistro animated:YES];
        [newSinistro release];
    }
    else if (indexPath.row == ROW_CONSULTA_SINISTROS) {
        SinistroConsultaViewController *consultaSinistro = [[SinistroConsultaViewController alloc] init];
        consultaSinistro.dadosLoginSegurado = self.dadosLoginSegurado;
        consultaSinistro.managedObjectContext = self.managedObjectContext;
        consultaSinistro.delegate = self;
        [self.navigationController pushViewController:consultaSinistro animated:YES];
        [consultaSinistro release];
    }
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Methods
- (NSInteger)getCountEvents
{
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    //Get the data
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    
    NSUInteger iCount = [mutableFetchResults count];

    [mutableFetchResults release];
    [fetchRequest release];

    return iCount;
}

#pragma mark - Consulta View Controller Delegate

- (void)backSinistroConsultaViewController
{
    iCountEvents = [self getCountEvents];
    [menuTableView reloadData];
}


#pragma mark - Actions

- (IBAction)btnMenu:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
