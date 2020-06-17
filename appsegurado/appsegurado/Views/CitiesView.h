//
//  CitiesView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 04/01/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CitiesCell.h"

@interface CitiesView : BaseView
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bgView;


-(void) loadView;
-(void) unloadView;
-(void) loadCities:(NSArray*) array;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;


@end


