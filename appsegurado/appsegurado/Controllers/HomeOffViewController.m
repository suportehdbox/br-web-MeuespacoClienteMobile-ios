//
//  HomeOffViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "HomeOffViewController.h"
#import "AppDelegate.h"
#import <appsegurado-Swift.h>

@interface HomeOffViewController (){
    AutoWorkShopModel *model;
    BOOL alreadyLoaded;
    NewClubViewController *club;
}

@end

@implementation HomeOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super addLeftMenu];

    [_homeView loadView];
    self.title = NSLocalizedString(@"TituloHomeDeslogada",@"");
    model = [[AutoWorkShopModel alloc] init];
    [model setDelegate:self];
    
    [self setAnalyticsTitle:@"Home Deslogado"];
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"TituloHomeDeslogada",@"");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"";
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!alreadyLoaded){
        alreadyLoaded = true;
        [_homeView loadView];
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(loadAutoWorkShop) userInfo:nil repeats:NO];
    }

    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if([appDelegate gotoLoginView]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
-(void)dealloc{
    [model setDelegate:nil];
    model = nil;
    
}
-(void)loadAutoWorkShop{
    [_homeView showMessage:NSLocalizedString(@"BuscandoSuaPosição", @"")];
    [model getNearestAutoWorkShop];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)locationManagerAuthorizationDenied{
    //change screen;
    UIAlertController *alert = [_homeView showLocationNotFound];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) locationZipCodeNotFound{
    UIAlertController *alert = [_homeView showLocationNotFound];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addressFoundSearchShops{
    [_homeView showMessage:NSLocalizedString(@"BuscandoOficinasProximas", @"")];
}
-(void) returnAutoWorkShops:(NSMutableArray *)arrayShops{
    if([arrayShops count] > 0){
        [_homeView showAutoWorksMap:arrayShops];
    }else{
        [self returnErrorAutoWorkShops];
    }
    
    
}

-(void) returnErrorAutoWorkShops{
    UIAlertController *alert = [_homeView showLocationNotFound];
    [self presentViewController:alert animated:YES completion:nil];
}
-(IBAction)doLogin:(id)sender{
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate setGotoLoginView:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)showClub:(id)sender {
    if(club == nil){
        club = [[NewClubViewController alloc] init];
    }
    [self.navigationController pushViewController:club animated:true];
//    [self performSegueWithIdentifier:@"ShowClub" sender:nil];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   self.title = @"";
    
    
    
}


@end
