//
//  ClubeLibertyLocaisDetalheViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ClubeLibertyLocaisDetalheViewController.h"
#import "Util.h"
#import "ClubeLibertyLocaisMapaViewController.h"
#import "Constants.h"


@implementation ClubeLibertyLocaisDetalheViewController

@synthesize cellDict;
@synthesize webInfo;

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
    [super viewDidLoad];
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];

    [self.navigationController setNavigationBarHidden:NO];    
    self.title = [cellDict objectForKey:@"Titulo"];
    
    [GoogleAnalyticsManager send:[NSString stringWithFormat:@"%@%@", @"Clube Liberty: Detalhe - ", [cellDict objectForKey:@"Titulo"]]];
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *voltarButton = [Util addCustomButtonNavigationBar:self action:@selector(btnVoltar:) imageName:@"59_clube-ecommerce-btn-clube.png"];
//    self.navigationItem.leftBarButtonItem = voltarButton;
//    [voltarButton release];

    [Util addBackButtonNavigationBar:self action:@selector(btnVoltar:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    //Verificando se o primeiro registro tem loja
    NSMutableArray *arrayContatos = [cellDict objectForKey:@"Contatos"];
    NSDictionary *dictContato = [arrayContatos objectAtIndex:0];

    if (![[dictContato objectForKey:@"Endereco"] isEqualToString:@""]) {
        //Adicionando o botão direito na NavigationBar
        UIBarButtonItem *mapaButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMapa:) imageName:@"57_clube-lojadet-btn-nomapa.png"];
        self.navigationItem.rightBarButtonItem = mapaButton;
        [mapaButton release];
    }

    NSString *webViewPath = [[NSBundle mainBundle] pathForResource:@"infoClubeLiberty" ofType:@"html"];
    NSString *webViewString = [NSString stringWithContentsOfFile:webViewPath encoding:NSUTF8StringEncoding error:NULL];
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%Titulo" withString:[cellDict objectForKey:@"Titulo"]];
    
    
    if (![[dictContato objectForKey:@"Endereco"] isEqualToString:@""]) {
        webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%Endereco" withString:[dictContato objectForKey:@"Endereco"]];
        if (![[dictContato objectForKey:@"Bairro"] isEqualToString:@""]) {
            webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%BairroCidadeEstado" withString:[NSString stringWithFormat:@"%@-%@/%@", [dictContato objectForKey:@"Bairro"], [dictContato objectForKey:@"Cidade"], [dictContato objectForKey:@"Estado"]]];
        }
    }
    else {
        webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%Endereco" withString:@"* Ofertas somente pelo site"];
        webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%BairroCidadeEstado" withString:@""];
    }

    
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%Beneficio" withString:[cellDict objectForKey:@"Beneficio"]];
    
    NSString *imagem = [NSString stringWithString:[cellDict objectForKey:@"Logo"]];
    imagem = [imagem stringByReplacingOccurrencesOfString:LMUrlInterna withString:LMUrlExterna];

    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%Logo" withString:imagem];
    
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%Abrangencia" withString:[cellDict objectForKey:@"Abrangencia"]];
    webViewString = [webViewString stringByReplacingOccurrencesOfString:@"%ComoUsar" withString:[cellDict objectForKey:@"ComoUsar"]];
    [self.webInfo loadHTMLString:webViewString baseURL:nil];

    [self.webInfo setUserInteractionEnabled:YES];
    [self.webInfo setOpaque:NO];

    if (![[dictContato objectForKey:@"Telefone"] isEqualToString:@""]) {
        [btnCallPhone setTitle:[dictContato objectForKey:@"Telefone"] forState:UIControlStateNormal];
    }
    else {
        btnCallPhone.hidden = TRUE;
        CGRect rect = self.webInfo.frame;
        rect.size.height += btnCallPhone.frame.size.height;
        [self.webInfo setFrame:rect];
    }
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

- (IBAction)btnVoltar:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnMapa:(id)sender {
    ClubeLibertyLocaisMapaViewController *defaultViewController = [[ClubeLibertyLocaisMapaViewController alloc] init];
    defaultViewController.cellDict = cellDict;
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
}

- (IBAction)btnCallPhone_Click:(id)sender {
    NSMutableArray *arrayContatos = [cellDict objectForKey:@"Contatos"];
    NSDictionary *dictContato = [arrayContatos objectAtIndex:0];
    NSString* phoneCall = [dictContato objectForKey:@"Telefone"];
    NSString* msgCall = [NSString stringWithFormat:@"%@ %@", @"Deseja ligar para: ", [cellDict objectForKey:@"Titulo"]];
    [Util callAlert:self alertTitle:msgCall alertNumber:phoneCall];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 1) {
        [Util callNumber:self phoneNumber:alertView.message];
	}
}

@end
