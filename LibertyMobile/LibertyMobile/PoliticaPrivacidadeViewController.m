//
//  PoliticaPrivacidadeViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PoliticaPrivacidadeViewController.h"
#import "Util.h"


@implementation PoliticaPrivacidadeViewController

@synthesize webInfo;
@synthesize origemDaTela;

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
    if (origemDaTela == 1) {
//        [Util initCustomNavigationBar:self.navigationController.navigationBar];
    }
    [super viewDidLoad];    

    [self.navigationController setNavigationBarHidden:NO];
        
    self.title = @"Política de Privacidade";
    
    [GoogleAnalyticsManager send:@"Política de Privacidade"];
    
    [Util loadHtml:@"infoPoliticaPrivacidade" webViewControl:self.webInfo];
    
    [self.webInfo setUserInteractionEnabled:YES];
    [self.webInfo setOpaque:NO];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnMenu:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnMenu:(id)sender {
    
    if (origemDaTela == 1) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
