//
//  AutoWorkShopsViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 31/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "AutoWorkShopsViewController.h"

#import "AutoWorkShopCell.h"
#import "MapPin.h"

@interface AutoWorkShopsViewController (){
    AutoWorkShopView *view;
    AutoWorkShopModel *model;
    NSMutableArray *array;
    bool shouldCenter;
}

@end

@implementation AutoWorkShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super addLeftMenu];
    view = (AutoWorkShopView*) self.view;
    [view loadView];
    
    
    [view showMessage:NSLocalizedString(@"BuscandoSuaPosição", @"")];
    self.title = NSLocalizedString(@"TituloOficinas",@"");
    array = [[NSMutableArray alloc] init];
    model = [[AutoWorkShopModel alloc] init];
    [model setDelegate:self];
    SWRevealViewController *revealViewController = self.revealViewController;
    if(revealViewController){
        [revealViewController setDelegate:self];
    }
    
//    if([model shouldShowInfo]){
        [view showPopUpInfo];
//    }
    [self setAnalyticsTitle:@"Busca de Oficinas"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"TituloOficinas", @"");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [model getNearestAutoWorkShop];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [view unloadView];
}
-(void)dealloc{
    [model setDelegate:nil];
    model = nil;
    
}
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position{
    [view hideKeyboard];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
    shouldCenter = true;
 
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(shouldCenter && userLocation.coordinate.latitude != 0 && userLocation.coordinate.longitude != 0){
        shouldCenter = false;
        [view centerMapToUser];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //AutoWSCell
    static NSString *CellIdentifier = @"AutoWSCell";
    
    AutoWorkShopCell *cell = (AutoWorkShopCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath: indexPath];

    MapPin *near = [array objectAtIndex:indexPath.row];
    
    [cell.detailView setFrame: CGRectMake(0, 0, cell.frame.size.width-5, cell.frame.size.height-5)];
    [cell.detailView loadView:near.autoWork.indication];
    [cell.detailView setName:near.autoWork.name];
    [cell.detailView setAddress:near.autoWork.address];
    [cell.detailView setPhoneNumber:near.autoWork.phone];
    [cell.detailView setDistance:near.autoWork.distance];
    [cell.detailView setOfficeHours:[near.autoWork getWorkingHoursPhrase]];
    [cell.detailView setLatitude:[NSString stringWithFormat:@"%f",near.autoWork.coordinate.latitude]];
    [cell.detailView setLongitude:[NSString stringWithFormat:@"%f",near.autoWork.coordinate.longitude]];
    
    if(!near.autoWork.available){
        [cell.detailView setUnavailable];
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapPin *near = [array objectAtIndex:indexPath.row];
    if(near.autoWork.indication)
        return [view rowHeight] + 20;
    
    return [view rowHeight] ;
}


#pragma mark - Model Delegate
-(void)locationManagerAuthorizationDenied{
    //change screen;
    [view showLocationNotFound];
//    [self presentViewController:alert animated:YES completion:nil];
}

-(void) locationZipCodeNotFound{
    [view showLocationNotFound];
//    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addressFoundSearchShops{
    if([model kindSearch] == Score){
        [view showMessage:NSLocalizedString(@"BuscandoOficinasRecomendadas", @"")];
    }else{
        [view showMessage:NSLocalizedString(@"BuscandoOficinasProximas", @"")];
    }
}
-(void) returnAutoWorkShops:(NSMutableArray *)arrayShops{
    array = arrayShops;
    [view showAutoWorksMap:arrayShops];
}

-(void) returnErrorAutoWorkShops{
    [view showNetworkError];
}

-(void) returnErrorOpenRoute:(NSString *)appName{
    [self.navigationController showViewController:[view showErrorApp:appName] sender:nil];;
}

#pragma mark - Actions
- (IBAction)showPopUpSearch:(id)sender{
    [view showPopUpSearch];
    
}

- (IBAction)closePopupInfo:(id)sender {
    [view hidePopUpInfo];
}

-(IBAction)changeOrdering:(id)sender{
    if([model kindSearch] == Nearest){
        [model setKindSearch:Score];
        [view showMessage:NSLocalizedString(@"BuscandoOficinasRecomendadas", @"")];
        [view setNearest];
    }else{
        [model setKindSearch:Nearest];
        [view showMessage:NSLocalizedString(@"BuscandoOficinasProximas", @"")];
        [view setScore];
    }
    [array removeAllObjects];
    [view reloadTable];
    [model repeatLastConnection];
    
}
-(void)searchClicked:(NSString *)address zipCode:(NSString *)zipCode{
    if([[address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] && [[zipCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        UIAlertController *alert = [view showErrorSearch];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [model searchAutoWorksByAddress:address andCEP:zipCode];
    [view showMessage:NSLocalizedString(@"BuscandoOficinasProximasEndereco", @"")];
    [view hidePopUpSearch];

}
@end
