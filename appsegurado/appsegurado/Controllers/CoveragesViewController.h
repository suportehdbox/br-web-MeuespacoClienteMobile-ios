//
//  CoveragesViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/04/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "JNExpandableTableView.h"
#import "InsuranceBeans.h"

#import "CoverageView.h"

@interface CoveragesViewController : BaseViewController <JNExpandableTableViewDelegate, JNExpandableTableViewDataSource>

-(void) setCoveragesInsurace:(InsuranceBeans*)beans;

@end
