//
//  OficinasReferenciadasDetalheViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OficinasReferenciadasDetalheViewController.h"
#import "Util.h"



@implementation OficinasReferenciadasDetalheViewController

@synthesize cellDict;
@synthesize webInfo;
@synthesize delegate;

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];    
    self.title = [cellDict objectForKey:@"Nome"];
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"53_oficinas-btn-oficinas.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnMenu:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    

    //Adicionando o botão direito na NavigationBar
    UIBarButtonItem *mapaButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMapa:) imageName:@"57_clube-lojadet-btn-nomapa.png"];
    self.navigationItem.rightBarButtonItem = mapaButton;
    [mapaButton release];

    NSString *webViewPath = [[NSBundle mainBundle] pathForResource:@"infoOficinaReferenciada" ofType:@"html"];
    NSString *webViewString = [NSString stringWithContentsOfFile:webViewPath encoding:NSUTF8StringEncoding error:NULL];
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%Nome" withString:[cellDict objectForKey:@"Nome"]];
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%Endereco" withString:[NSString stringWithFormat:@"%@: %@, %@", [cellDict objectForKey:@"Logradouro"], [cellDict objectForKey:@"Endereco"], [cellDict objectForKey:@"Numero"]]];
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%BairroCidadeEstado" withString:[NSString stringWithFormat:@"%@-%@/%@", [cellDict objectForKey:@"Bairro"], [cellDict objectForKey:@"Cidade"], [cellDict objectForKey:@"UF"]]];
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%CEP" withString:[NSString stringWithFormat:@"CEP: %@", [cellDict objectForKey:@"CEP"]]];
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%Especialidades" withString:[NSString stringWithFormat:@"%@", [cellDict objectForKey:@"Marca"]]];
    [self.webInfo loadHTMLString:webViewString baseURL:nil];

    [self.webInfo setUserInteractionEnabled:YES];
    [self.webInfo setOpaque:NO];
 
    [btnPhone setTitle:[NSString stringWithFormat:@"%@ %@", [cellDict objectForKey:@"DDD"], [cellDict objectForKey:@"Telefone"]] forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -s Actions

- (IBAction)btnMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnMapa:(id)sender {
    [self.delegate oficinaDetalheViewController:self dict:cellDict];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnCallPhone:(id)sender {
    NSString* phoneCall = [cellDict objectForKey:@"Telefone"];
    NSString* msgCall = [NSString stringWithFormat:@"%@ %@", @"Deseja ligar para ", [cellDict objectForKey:@"Nome"]];
    [Util callAlert:self alertTitle:msgCall alertNumber:phoneCall];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 1) {
        [Util callNumber:self phoneNumber:alertView.message];
	}
}

@end
