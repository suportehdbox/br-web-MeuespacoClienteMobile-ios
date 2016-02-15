//
//  OficinasReferenciadasBuscaViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OficinasReferenciadasBuscaViewController.h"
#import "Util.h"

@implementation OficinasReferenciadasBuscaViewController

@synthesize txtCEP;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Buscar por CEP";
    
    [GoogleAnalyticsManager send:@"Oficinas Referenciadas: Buscar por CEP"];
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"btn-voltar-lm.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnMenu:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger lengthAfterChange = [textField.text length] + [string length];   
    
    //only allow the max characters
    if (lengthAfterChange  > 8){
        return FALSE;
    }
    
    return TRUE;
}

- (IBAction) btnMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) btnBuscar:(id)sender
{
    [Constants setPesquisa:LMPesquisa_CEP];
    [self.delegate buscaOficinasViewController:self cepSearch:txtCEP.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end