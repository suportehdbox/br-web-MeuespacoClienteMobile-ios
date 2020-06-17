//
//  ContactView.h
//
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface ContactView : BaseView
@property (strong, nonatomic) IBOutlet UILabel *lblTalkLiberty;
@property (strong, nonatomic) IBOutlet UITableView *table;

-(void) loadView;
-(void) unloadView;
-(void) loadAgentsPhone:(NSArray*) array;
-(void) setAssistFirst:(BOOL)yesNo;
-(void) setLoading:(BOOL) loading;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
@end
