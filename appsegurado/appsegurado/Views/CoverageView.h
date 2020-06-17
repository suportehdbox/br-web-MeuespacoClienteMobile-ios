//
//  CoverageView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/04/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "JNExpandableTableView.h"
#import "CoverageCell.h"

@interface CoverageView : BaseView

@property (strong, nonatomic) IBOutlet JNExpandableTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *bgTitleCoverage;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleCoverage;
@property (strong, nonatomic) IBOutlet UILabel *lblOtherCoverage;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;



-(void) loadView:(NSArray*) array titleCoverage:(NSString*)title;
-(void) unloadView;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(JNExpandableTableView *)tableView canExpand:(NSIndexPath *)indexPath;
-(void) hideOtherCoverages:(BOOL) hide;
@end
