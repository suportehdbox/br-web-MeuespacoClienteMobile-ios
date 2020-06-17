//
//  CitiesViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 04/01/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "CitiesViewController.h"
#import "CitiesView.h"

@interface CitiesViewController (){
    CitiesView *view;
    NSString *state;
    NSArray *arrayCities;
    NSMutableArray *arrayCitiesScreen;
}
@end

@implementation CitiesViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    view = (CitiesView*) self.view;
    [view loadView];
    
    CityModel * city = [[CityModel alloc] init];
    
    arrayCities = [[NSArray alloc] initWithArray:[city getCityFromState:state]];
    arrayCitiesScreen = [[NSMutableArray alloc] initWithArray:arrayCities];
    [view loadCities:arrayCities];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Cidades";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"";
}
-(void) setState:(NSString*) stateSelected{
    state = stateSelected;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [view tableView:tableView cellForRowAtIndexPath:indexPath];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [view numberOfSectionsInTableView:tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [view tableView:tableView numberOfRowsInSection:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(delegate != nil && [delegate respondsToSelector:@selector(citySelected:)]){
        [delegate citySelected:[arrayCitiesScreen objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self searchBar:searchBar textDidChange:[searchBar text]];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    [self searchBar:searchBar textDidChange:@""];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [arrayCitiesScreen removeAllObjects];
    
    if([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
//        [searchBar setShowsCancelButton:NO];
        [arrayCitiesScreen addObjectsFromArray:arrayCities];
    }else{
//        [searchBar setShowsCancelButton:YES];
        for (CityBeans *beans in arrayCities) {
            if([[beans.city lowercaseString] containsString:[searchText lowercaseString]]){
                [arrayCitiesScreen addObject:beans];
            }
        }
    }
    
    [view loadCities:arrayCitiesScreen];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
