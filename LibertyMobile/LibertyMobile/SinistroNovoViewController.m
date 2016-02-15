//
//  SinistroNovoViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoViewController.h"
#import "Util.h"
#import "SinistroNovoApolicesViewController.h"
#import "SinistroNovoFotosViewController.h"
#import "SinistroNovoObsViewController.h"
#import "SinistroNovoCompartilharViewController.h"
#import "DetailLabelTableViewCell.h"
#import "LibertyMobileAppDelegate.h"
#import "BotaoAmareloTableViewCell.h"
#import "SinistroNovoApoliceTableViewCell.h"


@implementation SinistroNovoViewController

@synthesize menuTableView;

@synthesize event;
@synthesize managedObjectContext;
@synthesize dadosLoginSegurado;
@synthesize editable;

#define ROW_APOLICE             0
#define ROW_DADOS_CONTATO       0
#define ROW_TIPO_SINISTRO       0
#define ROW_DATA_HORA           1
#define ROW_LOCAL               2
#define ROW_DADOS_ENVOLVIDOS    3
#define ROW_FOTO                4
#define ROW_OBSERVACOES         5
#define ROW_COMPARTILHAR        0

#define SECTION_APOLICE         0
#define SECTION_DADOS_CONTATOS  1
#define SECTION_INFORMACOES     2
#define SECTION_COMPARTILHAR    3
#define SECTION_ENVIAR          4

#define SECTION_TOTAL           5

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
    NSString* pathArray = [[NSBundle mainBundle] pathForResource:@"SinistroNovo" ofType:@"plist"];
    // Alocar e inicializar o array com os conteúdos do plist
    menuItens = [[NSMutableArray alloc] initWithContentsOfFile:pathArray];        

    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Novo Sinistro";
    
    editable = (![event.eventStatus isEqualToString:@"Sent"]);
    
    if (editable) {
        [GoogleAnalyticsManager send:@"Comunicação de Acidente: Novo Sinistro"];
    } else {
        [GoogleAnalyticsManager send:@"Comunicação de Acidente: Detalhe"];
    }
    
    [Util dropTableBackgroudColor:self.menuTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *voltarButton = [Util addCustomButtonNavigationBar:self action:@selector(btnBack:) imageName:@"19_sinistro-meussinistros-btn-sinistro.png"];
//    self.navigationItem.leftBarButtonItem = voltarButton;
//    [voltarButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnBack:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    
    [menuTableView setDelegate:self];
    [menuTableView setDataSource:self];
    
    [menuTableView registerNib:[UINib nibWithNibName:@"SinistroNovoApoliceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellSinistroApolice"];
    [menuTableView registerNib:[UINib nibWithNibName:@"DetailLabelTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellDetail"];
    [menuTableView registerNib:[UINib nibWithNibName:@"BotaoAmareloTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellButton"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    editable = (![event.eventStatus isEqualToString:@"Sent"]);
    [self.menuTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    return SECTION_TOTAL - (editable ? 0 : 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int iCount = [Util getCountSectionArray:section sourceArray:menuItens];
    return iCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int iPositionReal = [Util getPositionSectionArray:indexPath.section numRow:indexPath.row sourceArray:menuItens];
    NSDictionary * dict = [menuItens objectAtIndex:iPositionReal];
    
    UITableViewCell *cell = nil;
    
    
    // Label TextInfo
    switch (indexPath.section)
    {
        case SECTION_APOLICE:
            cell = (SinistroNovoApoliceTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CellSinistroApolice"];
            ((SinistroNovoApoliceTableViewCell*)cell).lblTextInfo.text = event.policyNumber;
            break;
            
        case SECTION_DADOS_CONTATOS:
            cell = (DetailLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellDetail"];
            ((DetailLabelTableViewCell*)cell).lblTextInfo.text = event.eventUser.firstName;
            break;
            
        case SECTION_INFORMACOES:
        {
            cell = (DetailLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellDetail"];
            ((DetailLabelTableViewCell*)cell).lblTextInfo.text = @"";
            
            switch (indexPath.row)
            {
                case ROW_TIPO_SINISTRO:
                    ((DetailLabelTableViewCell*)cell).lblTextInfo.text = event.eventSubType;
                    break;
                    
                case ROW_DATA_HORA:
                    if (event.incidentDateTime) {
                        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
                        NSString *stringFromDate = [NSString stringWithString:[dateFormatter stringFromDate:event.incidentDateTime]];
                        ((DetailLabelTableViewCell*)cell).lblTextInfo.text = stringFromDate;
                        [dateFormatter release];
                    }
                    break;
                    
                case ROW_LOCAL:
                    ((DetailLabelTableViewCell*)cell).lblTextInfo.text = event.eventLocation.streetAddress;
                    break;
                    
                case ROW_DADOS_ENVOLVIDOS:
                {
                    int iCount = [event.eventDrivers count] + [event.eventPoliceOfficers count] + [event.eventWitnesses count];
                    if (iCount == 0) {
                        ((DetailLabelTableViewCell*)cell).lblTextInfo.text = @"";
                    }
                    else {
                        ((DetailLabelTableViewCell*)cell).lblTextInfo.text = [NSString stringWithFormat:@"%i", iCount];
                    }
                }break;
                    
                case ROW_FOTO:
                {
                    NSUInteger iCount = [event.eventPhotos count];
                    if (iCount == 0) {
                        ((DetailLabelTableViewCell*)cell).lblTextInfo.text = @"";
                    }
                    else {
                        ((DetailLabelTableViewCell*)cell).lblTextInfo.text = [NSString stringWithFormat:@"%i", iCount];
                    }
                }break;
                    
                case ROW_OBSERVACOES:
                {
                    BOOL existsVoiceNote = NO;
                    BOOL existsTextNote = NO;
                    
                    if ([self.event.pathToVoiceNote length] != 0) {
                        existsVoiceNote = YES;
                    }
                    if ([self.event.notes length] > 0) {
                        existsTextNote = YES;
                    }
                    
                    NSMutableString *subLabelText = [NSMutableString stringWithFormat:@""];
                    [subLabelText appendFormat:@"%@", existsVoiceNote ? @"Voz" : @""];
                    [subLabelText appendFormat:@"%@", existsVoiceNote && existsTextNote ? @" + " : @""];
                    [subLabelText appendFormat:@"%@", existsTextNote ? @"Texto" : @""];
                    
                    ((DetailLabelTableViewCell*)cell).lblTextInfo.text = subLabelText;
                }break;
            }
        }break;
            
        case SECTION_COMPARTILHAR:
            cell = (DetailLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellDetail"];
            ((DetailLabelTableViewCell*)cell).lblTextInfo.text = @"";
            break;
            
        case SECTION_ENVIAR:
            // Caso seja a linha do Botão Amarelo
            cell = [Util getViewButtonTableViewCell:self action:@selector(btnEnviar:) textButton:[dict objectForKey:@"menuItem"] tableView:tableView];
            break;
    }
    
    // Label MenuItem
    if (indexPath.section != SECTION_ENVIAR){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        ((DetailLabelTableViewCell *)cell).lblMenuItem.text = [dict objectForKey:@"menuItem"];
    }
    
    return cell;
    
}


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ROW_APOLICE && indexPath.section == SECTION_APOLICE) {
        SinistroNovoApolicesViewController *viewTela = [[SinistroNovoApolicesViewController alloc] initWithEvent:self.event andManagedObjectContext:self.managedObjectContext andCanEdit:editable];
        viewTela.dadosLoginSegurado = self.dadosLoginSegurado;
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    else if (indexPath.row == ROW_DADOS_CONTATO && indexPath.section == SECTION_DADOS_CONTATOS) {

        if (!event.eventUser)
        {
            User *newUser = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
            newUser.contactAddress = (Address *) [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:[self managedObjectContext]];
            self.event.eventUser = newUser;
            [self saveState];
        }

        SinistroNovoContatoViewController *viewTela = [[SinistroNovoContatoViewController alloc] initWithEvent:self.event.eventUser andManagedObjectContext:self.managedObjectContext andCanEdit:editable];
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    else if (indexPath.row == ROW_TIPO_SINISTRO && indexPath.section == SECTION_INFORMACOES) {
        SinistroNovoTipoSinistroViewController *viewTela = [[SinistroNovoTipoSinistroViewController alloc] initWithEventType:self.event andManagedObjectContext:self.managedObjectContext andCanEdit:editable];
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    else if (indexPath.row == ROW_DATA_HORA && indexPath.section == SECTION_INFORMACOES) {
        SinistroNovoDataHoraViewController *viewTela = [[SinistroNovoDataHoraViewController alloc] initWithEventTime:self.event andManagedObjectContext:self.managedObjectContext andCanEdit:editable];
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    else if (indexPath.row == ROW_LOCAL && indexPath.section == SECTION_INFORMACOES) {
        if (event.eventLocation == nil)
        {
            Address *newAddress = (Address *)[NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:[self managedObjectContext]];
            self.event.eventLocation = newAddress;
            [self saveState];
        }

        SinistroNovoLocalViewController *viewTela = [[SinistroNovoLocalViewController alloc] initWithEventLocal:self.event.eventLocation andManagedObjectContext:self.managedObjectContext andCanEdit:editable];
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    else if (indexPath.row == ROW_DADOS_ENVOLVIDOS && indexPath.section == SECTION_INFORMACOES) {
        SinistroNovoEnvolvidosViewController *viewTela = [[SinistroNovoEnvolvidosViewController alloc] initWithNovoEventContact:self.event andManagedObjectContext:self.managedObjectContext andCanEdit:editable];
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    else if (indexPath.row == ROW_FOTO && indexPath.section == SECTION_INFORMACOES) {
        SinistroNovoFotosViewController *viewTela = [[[SinistroNovoFotosViewController alloc] initWithEventPhoto:self.event andManagedObjectContext:self.managedObjectContext andCanEdit:editable] autorelease];
        [self.navigationController pushViewController:viewTela animated:YES];
        //[viewTela release];
    }
    else if (indexPath.row == ROW_OBSERVACOES && indexPath.section == SECTION_INFORMACOES) {
        SinistroNovoObsViewController *viewTela = [[SinistroNovoObsViewController alloc] initWithEventObs:self.event andManagedObjectContext:self.managedObjectContext andCanEdit:editable];
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    else if (indexPath.row == ROW_COMPARTILHAR && indexPath.section == SECTION_COMPARTILHAR) {
        if (!event.eventUser)
        {
            User *newUser = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
            newUser.contactAddress = (Address *) [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:[self managedObjectContext]];
            self.event.eventUser = newUser;
            [self saveState];
        }

        SinistroNovoCompartilharViewController *viewTela = [[SinistroNovoCompartilharViewController alloc] initWithEventShare:self.event.eventUser andManagedObjectContext:self.managedObjectContext andCanEdit:editable];
        [self.navigationController pushViewController:viewTela animated:YES];
        [viewTela release];
    }
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ROW_APOLICE && indexPath.section == SECTION_APOLICE) {
        return 70;
    }
    return tableView.rowHeight;
}

#pragma mark - Validation

- (void)checkCompletion
{
    minimumReqs = YES;
    
    if([[event eventPhotos] count] > 0)
    {
        pictures = YES;
    }
    else
    {
        pictures = NO;
    }
    
    if(event.eventSubType)
    {
        subType = YES;
    }
    else
    {
        subType = NO;
    }
    
    if(self.event.eventLocation || self.event.incidentDateTime)
    {
        timeLocation = YES;
        
        if(!self.event.incidentDateTime)
        {
            //date of loss must be provided to continue
            minimumReqs = NO;
        }
    }
    else
    {
        timeLocation = NO;
        
        //date of loss must be provided to continue
        minimumReqs = NO;
    }
    
    if([self.event.eventWitnesses count] > 0 || [self.event.eventDrivers count] > 0 || [self.event.eventPoliceOfficers count] > 0 )
    {
        contactInfo = YES;
    }
    else
    {
        contactInfo = NO;
    }
    
    if(self.event.lengthOfVoiceNote > 0)
    {
        voiceNote = YES;
    }
    else
    {
        voiceNote = NO;
    }
    
    if([self.event.notes length] > 0)
    {
        textNote = YES;
    }
    else
    {
        textNote = NO;
    }
    
    // << EPO - 
    
    if ([self.event.eventUser.firstName length] < 1)
    {
        userInfo = NO;
        minimumReqs = NO;
    }
    else     if ([self.event.eventUser.lastName length] < 1)
    {
        userInfo = NO;
        minimumReqs = NO;
    }
    else if (! ([Util fieldIsValidString:self.event.eventUser.homePhone andMinChars:8 andMaxChars:12]
                || [Util fieldIsValidString:self.event.eventUser.mobilePhone andMinChars:8 andMaxChars:12]))
    {
        userInfo = NO;
        minimumReqs = NO;
    }
    
    /*
    
    //check to see if user info has been completed
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                                    error:&error]mutableCopy];
    
    if(mutableFetchResults == nil)
    {
        //TODO: handle error
    }
    
    if([mutableFetchResults count] == 0)
    {
        userInfo = NO;
        
        //user info must be completed to submit
        minimumReqs = NO;
    }
    else
    {
        userInfo = YES;
        
        //There should only ever be one instance of user info, so use the first one
        User *theUser = (User *)[mutableFetchResults objectAtIndex:0]; // EPO O ERRO ESTA AKI!!!!! ZERO???
        
        //make sure they have at least a first name, last name and phone number
        if([theUser.lastName length] < 1)
        {
            userInfo = NO;
            minimumReqs = NO;
        }
        else if (! ([Util fieldIsValidString:theUser.homePhone andMinChars:8 andMaxChars:12] || [Util fieldIsValidString:theUser.mobilePhone andMinChars:8 andMaxChars:12]))
        {
            userInfo = NO;
            minimumReqs = NO;
        }
    }
    [mutableFetchResults release];
    [fetchRequest release];
    */
    
    // >>
    
}

#pragma mark -s Actions

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEnviar:(id)sender
{
    [self checkCompletion];
    
    if(minimumReqs)
    {
        SinistroNovoEnviarViewController *nextViewController = nil;
        nextViewController = [[SinistroNovoEnviarViewController alloc] initWithEvent:self.event
                                                   andManagedObjectContext:self.managedObjectContext];
        nextViewController.delegate = self;
        [self.navigationController pushViewController:nextViewController animated:YES];
        [nextViewController release];
    }
    else
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Requisitos Mínimos"
                                                message:@"Para enviar o aviso de sinistro é necessário que preencha o seu sobrenome, telefone e a data do sinistro."
                                                delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];

        [alert show];
        [alert release];
    }
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

#pragma mark -
#pragma mark Send Info Delegate Methods
- (void)enviarSinistroViewController:(SinistroNovoEnviarViewController *)controller didDismissView:(BOOL)viewDismissed {
	if (viewDismissed) {

	}
}


@end
