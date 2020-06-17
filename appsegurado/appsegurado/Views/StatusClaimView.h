//
//  StatusClaimView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "ClaimBeans.h"

@interface StatusClaimView : BaseView
@property (strong, nonatomic) IBOutlet UITableView *table;

-(void) loadView;
-(void) unloadView;
-(void) loadClaims:(NSArray*) array;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath target:(id) target action:(SEL)action ;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
