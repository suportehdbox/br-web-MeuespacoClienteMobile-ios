//
//  ExtractView.h
//  appsegurado
//
//  Created by Luiz Zenha on 04/06/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface ExtractView : BaseView
    
@property (strong, nonatomic) IBOutlet UIView *bgTable;
@property (strong, nonatomic) IBOutlet UITableView *table;
    
    
-(void) loadView;
-(void) showLoading;
-(void) stopLoading;
-(void) reloadTable;

@end
