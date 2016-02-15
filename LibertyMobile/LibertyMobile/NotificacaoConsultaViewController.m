//
//  NotificacaoConsultaViewController.m
//  LibertyMobile
//
//  Created by Evandro Oliveira on 13/01/15.
//  Copyright 2015 Liberty Seguros. All rights reserved.
//

#import "NotificacaoConsultaViewController.h"
#import "LoginManterLogadoTableViewCell.h"
#import "Util.h"

@implementation NotificacaoConsultaViewController

@synthesize consultaTableView;

// SETUP desabilitado
//#define SECTION_SETUP               0
//#define SECTION_NOTIFICACAO         1
//#define SECTION_TOTAL               2


#define DELETE_CLAIM_ALERT_TAG      1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    
    // Alocar e inicializar o array com os conteúdos do plist
    arrayFields = [[NSMutableArray alloc] initWithContentsOfFile:[NotificacaoConsultaViewController getPathNotificationPlist]];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Notificações";
    
    [GoogleAnalyticsManager send:@"Notificações"];
   
    [Util dropTableBackgroudColor:self.consultaTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"btn-menu-lm.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnMenu:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    if ([arrayFields count] >= 1) {
        //Adicionando o botão direito na NavigationBar
        UIBarButtonItem *editButton = [Util addCustomButtonNavigationBar:self action:@selector(btnEdit:) imageName:@"btn-editar-lm.png"];
        self.navigationItem.rightBarButtonItem = editButton;
        [editButton release];
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [consultaTableView setDelegate:self];
    [consultaTableView setDataSource:self];
 
    // SETUP desabilitado
    //[consultaTableView registerNib:[UINib nibWithNibName:@"LoginManterLogadoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellLoginManterLogado"];
    [consultaTableView registerNib:[UINib nibWithNibName:@"NotificacaoConsultaTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellNotificacao"];
    
    // remove o badgeNumber uma vez que visualizou a notificação
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)viewDidUnload
{
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
    // SETUP desabilitado
	//return SECTION_TOTAL;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // SETUP desabilitado
    //NSInteger numberOfRowsInSection = 1;
    //if (SECTION_NOTIFICACAO == section) {
    //    numberOfRowsInSection = arrayFields.count;
    //}
    //return numberOfRowsInSection;
    
    return arrayFields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    // SETUP desabilitado
    /*switch (indexPath.section){

        case SECTION_SETUP:{
            
            //TODO add segment
            
            cell = (LoginManterLogadoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"CellLoginManterLogado"];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
            }
            
            ((LoginManterLogadoTableViewCell *)cell).lblInfo.text = @"Receber Notificações";
            ((LoginManterLogadoTableViewCell *)cell).lblInfo.textColor = [Util getColorHeader];
            [((LoginManterLogadoTableViewCell *)cell).lblInfo setFont:[UIFont boldSystemFontOfSize:14.0f]];
            ((LoginManterLogadoTableViewCell *)cell).userInteractionEnabled = YES;
            [((LoginManterLogadoTableViewCell *)cell).switchOnOff addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            
            tableView.separatorColor = [UIColor lightGrayColor];
            //TODO deixar marcado ou não!!
            
        }break;
            
        case SECTION_NOTIFICACAO:{*/
            
            cell = (NotificacaoConsultaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellNotificacao"];
            
            // LINHA
            
            NSDictionary *pushNotification = [arrayFields objectAtIndex:indexPath.row];
            
            // CAMPOS
            NSDate *date = [pushNotification objectForKey:@"date"];
            NSString *alert = [pushNotification objectForKey:@"alert"];
            
            NSDateFormatter *dateFormatterSinistro = [[NSDateFormatter alloc] init];
            [dateFormatterSinistro setDateFormat:@"dd/MM/yyyy"]; //@"dd/MM/yyyy 'às' HH:mm:ss"
            NSString *stringFromDate = [dateFormatterSinistro stringFromDate:date];
            
            ((NotificacaoConsultaTableViewCell *)cell).lblDate.text = stringFromDate;
            [dateFormatterSinistro release];
            
            ((NotificacaoConsultaTableViewCell *)cell).txtAlert.text = alert;

        /* }break;
            
        default:
            break;
    }*/
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // SETUP desabilitado
    // Return YES if you want the specified item to be editable.
    //BOOL canEdit = YES;
    //if (SECTION_SETUP == indexPath.section) {
    //    canEdit = NO;
    //}
    //return canEdit;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        // remove a notificação
        [arrayFields removeObjectAtIndex:indexPath.row];
        // atualiza o arquivo
        [arrayFields writeToFile:[NotificacaoConsultaViewController getPathNotificationPlist] atomically:YES];
        [self setEditing:NO];
        
        [self viewDidLoad];
        
        [tableView reloadData];
	}
}

#pragma mark -s Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // SETUP desabilitado
    //CGFloat heightForRowAtIndexPath = 120.0;
    //if (SECTION_SETUP == indexPath.section) {
    //    heightForRowAtIndexPath = 44.0;
    //}
    //return heightForRowAtIndexPath;
    
    return 120.0;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
    
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.consultaTableView setEditing:editing animated:animated];

    if (editing) {
        [self.navigationItem.leftBarButtonItem setEnabled:FALSE];
        
        //Adicionando o botão direito na NavigationBar
        UIBarButtonItem *okButton = [Util addCustomButtonNavigationBar:self action:@selector(btnOk:) imageName:@"btn-ok-lm.png"];
        self.navigationItem.rightBarButtonItem = okButton;
        [okButton release];
    }
    else {
        [self.consultaTableView setEditing:NO animated:YES];
        
        [self.navigationItem.leftBarButtonItem setEnabled:TRUE];
        
        //Adicionando o botão direito na NavigationBar
        UIBarButtonItem *editButton = [Util addCustomButtonNavigationBar:self action:@selector(btnEdit:) imageName:@"btn-editar-lm.png"];
        self.navigationItem.rightBarButtonItem = editButton;
        [editButton release];
    }
}

#pragma mark - Actions

- (void)switchAction:(id)sender
{
    bool isOn = [sender isOn];
    
    if (isOn) {
        // caso on: Registrar novamente
     //TODO re-register
        
    } else {
        // caso off: avisar!
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Liberty\" não lhe enviará Notificações"
                                                        message:@"A Liberty deixará de lhe enviar notificações."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancelar"
                                              otherButtonTitles:@"Confirmar", nil];
        [alert show];
        [alert release];
    }
    
    receberNotificacoes = isOn;
}

- (IBAction)btnMenu:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEdit:(id)sender
{
    [self setEditing:TRUE animated:TRUE];
}

- (IBAction)btnOk:(id)sender
{
    [self setEditing:FALSE animated:TRUE];
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //TODO unregister
    }
}

+ (NSString*) getPathNotificationPlist
{
    //return [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"Contents/Notificacao.plist"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *pathNotificationPlist = [documentsPath stringByAppendingPathComponent:@"notificacao.plist"]; // Correct path to Documents Dir in the App Sand box
    return pathNotificationPlist;
}

+ (void) addAndSaveNotificationPlist:(NSMutableDictionary*)pushNotification
{
    NSString *path = [NotificacaoConsultaViewController getPathNotificationPlist];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableArray *notifications = nil;
    
    if ([fileManager fileExistsAtPath: path]) {
        // Caso arquivo exista - carrega lista
        notifications = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    else {
        // Caso arquivo nã exista - cria file e inicializa a lista
        notifications = [[NSMutableArray alloc] init];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notifications];
        [fileManager createFileAtPath:path contents:data attributes:attributes];
    }
    // insere data de recebimento
    [pushNotification setValue:[[NSDate alloc] init]forKey:@"date"];
    // adiciona notificação
    [notifications addObject:pushNotification];
    // atualiza arquivo
    [notifications writeToFile:[NotificacaoConsultaViewController getPathNotificationPlist] atomically:YES];
}

@end
