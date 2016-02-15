//
//  SinistroNovoApolicesViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoApolicesViewController.h"
#import "CallWebServices.h"
#import "LibertyMobileAppDelegate.h"
#import "Util.h"


@implementation SinistroNovoApolicesViewController

@synthesize apolicesTableView;
@synthesize selApolice;
@synthesize indicator;
@synthesize imgApolice;
@synthesize lblApolice;
@synthesize txtApolice;
@synthesize dadosLoginSegurado;
@synthesize uiAlertView;

-(id)initWithEvent:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit
{
    if ((self = [super initWithNibName:@"SinistroNovoApolicesViewController" bundle:nil]))
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
    self.title = @"Seleção da Apólice";
    
    [Util dropTableBackgroudColor:self.apolicesTableView];
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *sinistroButton = [Util addCustomButtonNavigationBar:self action:@selector(btnSinistroNovo:) imageName:@"05_sinistrosdados-btn-novo.png"];
//    self.navigationItem.leftBarButtonItem = sinistroButton;
//    [sinistroButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnSinistroNovo:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    
    if (dadosLoginSegurado.logado && self.editable) {
        
        imgApolice.hidden = TRUE;
        lblApolice.hidden = TRUE;
        txtApolice.hidden = TRUE;
        
        // << SN 11947
        if (![Utility hasInternet]) {
            [Utility showNoInternetWarning];
            
            return;
        }
        // >>
        [indicator startAnimating];
        
        CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
        [callWs callGetMeusSegurosLiberty:self cpfCnpj:dadosLoginSegurado.cpf tipoFiltro:@"1"];
    }
    else {
        //Adicionando o botão direito na NavigationBar
        if (self.editable) {
            UIBarButtonItem *concluidoButton = [Util addCustomButtonNavigationBar:self action:@selector(btnConcluido:) imageName:@"btn-concluido-lm.png"];
            self.navigationItem.rightBarButtonItem = concluidoButton;
            [concluidoButton release];
        }
        
        [self.txtApolice setDelegate:self];
        self.txtApolice.text = self.event.policyNumber;
        [indicator stopAnimating];
        
        self.txtApolice.keyboardType = UIKeyboardTypeNumberPad;
        [self.txtApolice becomeFirstResponder];
        
        if ([txtApolice.text length] > 10) {
			NSRange range;
			range.length = 10;
			range.location = 0;
			
            txtApolice.text = [txtApolice.text substringWithRange:range];
        }
        
    }
    
    [apolicesTableView setDelegate:self];
    [apolicesTableView setDataSource:self];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [apolices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSMutableDictionary* dict = [apolices objectAtIndex:indexPath.row];

    NSString* sApolice = [dict objectForKey:@"NumeroApolice"];
    cell.textLabel.text = sApolice;
    
    NSString* sApoliceSel = [self.selApolice objectForKey:@"NumeroApolice"];
    if ([sApolice isEqualToString:sApoliceSel]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.selApolice != nil) {
        NSInteger index = [apolices indexOfObject:self.selApolice];
		NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UITableViewCell *checkedCell = [tableView cellForRowAtIndexPath:selectionIndexPath];
        checkedCell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	// Set the checkmark accessory for the selected row
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	
	// Update the type of claim selected
    NSMutableDictionary* dict = [apolices objectAtIndex:indexPath.row];
    self.selApolice = dict;
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Text Field Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger lengthAfterChange = [textField.text length] + [string length];
    
    if (lengthAfterChange > 10){
        return FALSE;
    }
    return TRUE;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{
    return self.editable;
}

#pragma mark -s Actions

- (IBAction)btnSinistroNovo:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnConcluido:(id)sender
{
    if (!dadosLoginSegurado.logado){
        
        NSString *myString = [[[NSString alloc] initWithString:self.txtApolice.text] autorelease];
        
        if (![Util fieldIsValidString:myString andMinChars:1 andMaxChars:35]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Por favor insira um número de apólice."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            self.uiAlertView = alert;
            [alert show];
            [alert release];
            
            return;
        }
        
        self.event.policyNumber = myString;
        [self saveState];
    }
    else {
        
        //---------------
        //Pegando somente os primeiros números da apólice
        NSRange range;
        range.length = 10;
        range.location = 0;
        
        NSString* sApoliceSel = [[self.selApolice objectForKey:@"NumeroApolice"] substringWithRange:range];
        //------------
        
        if ([sApoliceSel isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Por favor insira um número de apólice."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            self.uiAlertView = alert;
            [alert show];
            [alert release];
            
            return;
        }
        
        self.event.policyNumber = sApoliceSel;
        [self saveState];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - WebServices Delegate

- (void)callWebServicesDidFinish:(CallWebServices *)call
{
    NSMutableArray * retorno = [[NSMutableArray alloc] initWithArray:call.retGetMeusSegurosLiberty];
    
    if (retorno != nil) {
        //filtrando as apólices de auto somente
        //Verifica se a apólice é somente AUTO
        apolices = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in retorno) {
            if ([[dict objectForKey:@"TipoSeguro"] isEqualToString:@"AUTO"]) {
                [apolices addObject:dict];
            }
        }
        
        //Adicionando o botão direito na NavigationBar
        UIBarButtonItem *concluidoButton = [Util addCustomButtonNavigationBar:self action:@selector(btnConcluido:) imageName:@"btn-concluido-lm.png"];
        self.navigationItem.rightBarButtonItem = concluidoButton;
        [concluidoButton release];
        
        //Setando a apólice
        if (![self.event.policyNumber isEqualToString:@""]) {
            for (NSDictionary *dict in apolices) {
                
                NSRange range;
                range.length = 10;
                range.location = 0;
                
                NSString *apolice = [[dict objectForKey:@"NumeroApolice"] substringWithRange:range];
                
                if ([apolice isEqualToString:self.event.policyNumber]) {
                    self.selApolice = dict;
                    break;
                }
            }
        }
        
        [apolicesTableView reloadData];
        
        [retorno release];
    }
    
    [indicator stopAnimating];
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error
{
    [indicator stopAnimating];
    [Util viewMsgErrorConnection:self codeError:error];
}


@end
