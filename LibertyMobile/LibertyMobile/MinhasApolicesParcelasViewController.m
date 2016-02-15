//
//  MinhasApolicesParcelasViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MinhasApolicesParcelasViewController.h"
#import "Util.h"
#import "MinhasApolicesParcelasTableViewCell.h"
#import "MinhasApolicesParcelasHeaderTableViewCell.h"

@implementation MinhasApolicesParcelasViewController

@synthesize parcelas;
@synthesize parcelasTableView;

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
    self.title = @"Parcelas";
    
    [GoogleAnalyticsManager send:@"Minhas Apólices: Parcelas"];

    [Util dropTableBackgroudColor:self.parcelasTableView];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *voltarButton = [Util addCustomButtonNavigationBar:self action:@selector(btnVoltar:) imageName:@"71_Corretor-btn-apolices.png"];
//    self.navigationItem.leftBarButtonItem = voltarButton;
//    [voltarButton release];
        
    [Util addBackButtonNavigationBar:self action:@selector(btnVoltar:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    [parcelasTableView setDelegate:self];
    [parcelasTableView setDataSource:self];
    
    [parcelasTableView registerNib:[UINib nibWithNibName:@"MinhasApolicesParcelasHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellMinhasApolicesParcelasHeader"];
    [parcelasTableView registerNib:[UINib nibWithNibName:@"MinhasApolicesParcelasTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellMinhasApolicesParcelas"];
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
    return [parcelas count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            {
                MinhasApolicesParcelasHeaderTableViewCell * cell = (MinhasApolicesParcelasHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellMinhasApolicesParcelasHeader"];
                return cell;
            } break;
            
        default:
            {
                MinhasApolicesParcelasTableViewCell *cell = (MinhasApolicesParcelasTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellMinhasApolicesParcelas"];
                
                NSMutableDictionary* dict = [parcelas objectAtIndex:indexPath.row - 1];
                
                cell.lblParcela.text = [dict objectForKey:@"NumeroParcela"];
                
                NSString* sVencimento = [dict objectForKey:@"DataVencimento"];
                NSMutableString *fmtVencimento = [[NSMutableString alloc] initWithFormat:@"%@%@/%@%@/%@%@%@%@",
                                                  [sVencimento substringWithRange:NSMakeRange(8, 1)],
                                                  [sVencimento substringWithRange:NSMakeRange(9, 1)],
                                                  [sVencimento substringWithRange:NSMakeRange(5, 1)],
                                                  [sVencimento substringWithRange:NSMakeRange(6, 1)],
                                                  [sVencimento substringWithRange:NSMakeRange(0, 1)],
                                                  [sVencimento substringWithRange:NSMakeRange(1, 1)],
                                                  [sVencimento substringWithRange:NSMakeRange(2, 1)],
                                                  [sVencimento substringWithRange:NSMakeRange(3, 1)]];
                
                cell.lblVencimento.text = fmtVencimento;
                
                cell.lblValor.text = [dict objectForKey:@"ValorParcela"];
                
                if ([[dict objectForKey:@"Quitada"] boolValue]) {
                    cell.lblStatus.text = @"Quitado";
                }
                else {
                    cell.lblStatus.text = @"Aberto";
                }
                
                [fmtVencimento release];
                
                return cell;
            } break;
    }
}


#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    return tableView.rowHeight;
}

- (IBAction)btnVoltar:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
