//
//  DAAssistanceMenuAllViewController.h
//  DirectAssistHyundai
//
//  Created by Danilo Salvador on 10/29/12.
//  Copyright (c) 2012 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAClientBase.h"
#import "DABannerCell.h"

@protocol DAAssistanceMenuAllDelegate;

@interface DAAssistanceMenuAllViewController : UITableViewController
{
    id <DAAssistanceMenuAllDelegate> delegate;
    
    NSArray *options;
    IBOutlet DABannerCell *banner;
}

@property (nonatomic, strong) id <DAAssistanceMenuAllDelegate> delegate;

- (id)initWithOptions:(NSArray *)menuOptions;
- (IBAction)btnMenu:(id)sender;

@end

@protocol DAAssistanceMenuAllDelegate <NSObject>
@required
- (void) returnDirectAssist:(NSArray *)caseList;

@end
