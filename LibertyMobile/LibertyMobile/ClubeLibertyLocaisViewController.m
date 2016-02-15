//
//  ClubeLibertyLocaisViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ClubeLibertyLocaisViewController.h"
#import "Util.h"
#import "ClubeLibertyLocaisTableViewCell.h"
#import "ClubeLibertyLocaisDetalheViewController.h"


@implementation ClubeLibertyLocaisViewController

@synthesize locaisTableView;
@synthesize clubeLiberty;
@synthesize categoria;

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
    self.title = @"Categoria";
   
    [GoogleAnalyticsManager send:@"Clube Liberty: Categoria"];
    
    [Util dropTableBackgroudColor:self.locaisTableView];
    
    //Populando o Array de Locais, filtrados a partir do Array clubeLiberty
    locais = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in clubeLiberty) {
        NSString *categoriaDict = [dict objectForKey:@"Servico"];
        if ([categoriaDict isEqualToString:self.categoria]) {
            [locais addObject:dict];
        }
    }

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *voltarButton = [Util addCustomButtonNavigationBar:self action:@selector(btnVoltar:) imageName:@"59_clube-ecommerce-btn-clube.png"];
//    self.navigationItem.leftBarButtonItem = voltarButton;
//    [voltarButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnVoltar:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    [locaisTableView setDelegate:self];
    [locaisTableView setDataSource:self];
    
    [locaisTableView registerNib:[UINib nibWithNibName:@"ClubeLibertyLocaisTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellClubeLibertyLocais"];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locais count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClubeLibertyLocaisTableViewCell *cell = (ClubeLibertyLocaisTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellClubeLibertyLocais"];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSMutableDictionary* dict = [locais objectAtIndex:indexPath.row];
    
    cell.lblNome.text = [dict objectForKey:@"Titulo"];
    
    cell.lblEndereco.text = @"";
    cell.lblBairroCidadeUF.text = @"";
    
    //Verificando se o primeiro registro tem loja
    NSMutableArray *arrayContatos = [dict objectForKey:@"Contatos"];
    NSDictionary *dictContato = [arrayContatos objectAtIndex:0];
    
    if (![[dictContato objectForKey:@"Endereco"] isEqualToString:@""]) {
            cell.lblEndereco.text = [dictContato objectForKey:@"Endereco"];
            if (![[dictContato objectForKey:@"Bairro"] isEqualToString:@""]) {
                cell.lblBairroCidadeUF.text = [NSString stringWithFormat:@"%@-%@/%@", [dictContato objectForKey:@"Bairro"], [dictContato objectForKey:@"Cidade"], [dictContato objectForKey:@"Estado"]];
            }
    }
    else {
        cell.lblEndereco.text = @"* Ofertas somente pelo site";
    }
    
    if ([dict objectForKey:@"Imagem"] != nil)
        [cell.imgLogo setImage:[UIImage imageWithData:[dict objectForKey:@"Imagem"]]];

    return cell;
}



#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* dict = [locais objectAtIndex:indexPath.row];
    
    ClubeLibertyLocaisDetalheViewController *defaultViewController = [[ClubeLibertyLocaisDetalheViewController alloc] init];
    defaultViewController.cellDict = dict;
    [self.navigationController pushViewController:defaultViewController animated:YES];
    [defaultViewController release];
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark -s Actions

- (IBAction)btnVoltar:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
