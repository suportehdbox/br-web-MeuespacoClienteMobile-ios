//
//  PolicyView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "InsuranceBeans.h"
@interface PolicyView : BaseView
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightTitle;
-(void) loadView;
-(void) unloadView;
-(void) loadPolicies:(NSArray*) array;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(InsuranceBeans*) getInsuranceClickedAtIndexPath:(NSIndexPath *)indexPath;
-(void) showButonOldPolices:(BOOL)show;
-(void) showLoadingMorePolices;
-(void) setTitleTable:(NSString*)text;
@end
