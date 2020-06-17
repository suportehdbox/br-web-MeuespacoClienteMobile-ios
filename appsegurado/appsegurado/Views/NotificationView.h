//
//  NotificationView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 14/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface NotificationView : BaseView <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIView *bgTable;

-(void) loadView;
-(void) unloadView;
-(void) setArrayAfterDelete:(NSArray*) arrayBase atIndexPath:(NSIndexPath *)indexPath;
-(void) loadNotifications:(NSArray*) arrayBase;
-(void) showLoading;
-(void) stopLoading;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
