//
//  SinistroNovoFotosDetalheViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoFotosDetalheViewController.h"
#import "Util.h"

@implementation SinistroNovoFotosDetalheViewController

@synthesize photoView, fullSizedImage;
@synthesize delegate;
@synthesize thumbSectionIndex, thumbImageIndex;
@synthesize deleteButton, deleteEnabled;
@synthesize uiActionSheet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
	self.title = @"Fotografia";
	self.deleteButton.enabled = self.deleteEnabled;
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *sinistroButton = [Util addCustomButtonNavigationBar:self action:@selector(btnBack:) imageName:@"btn-voltar-lm.png"];
//    self.navigationItem.leftBarButtonItem = sinistroButton;
//    [sinistroButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnBack:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    

    self.photoView.image = fullSizedImage;
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(applicationEnteredBackground) 
												 name:UIApplicationDidEnterBackgroundNotification 
											   object:nil];
}

- (void)applicationEnteredBackground {
	if (uiActionSheet) {
		[uiActionSheet dismissWithClickedButtonIndex:uiActionSheet.cancelButtonIndex animated:NO];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.photoView = nil;
	self.fullSizedImage = nil;
	self.deleteButton = nil;
}

- (void)dealloc {
	[photoView release];
	[fullSizedImage release];
	[deleteButton release];
	[uiActionSheet release];
    [super dealloc];
}


#pragma mark -
#pragma mark Custom CLaim Photo Detail View Controller

- (IBAction)deletePressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
								  initWithTitle:nil
								  delegate:self 
								  cancelButtonTitle:@"Cancelar" 
								  destructiveButtonTitle:@"Remover Foto" 
								  otherButtonTitles: nil];
	self.uiActionSheet = actionSheet;
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (IBAction)deletePhoto {
	[self.delegate SinistroNovoFotosDetalheViewController:self didPressDelete:YES];
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	uiActionSheet = nil;
	
	//if the user selected 'Delete'
	if (buttonIndex == 0)
	{
		[self deletePhoto];
	}
} 


@end
