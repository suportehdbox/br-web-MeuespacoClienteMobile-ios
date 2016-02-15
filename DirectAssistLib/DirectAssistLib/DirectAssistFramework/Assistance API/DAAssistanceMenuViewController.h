//
//  DAAssistanceMenuViewController.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 7/28/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAClientBase.h"
#import "DABannerCell.h"

@interface DAAssistanceMenuViewController : UITableViewController {

	NSArray *options;

	IBOutlet DABannerCell *banner;
	DAAssistanceType assistanceType;
}

@property (nonatomic, assign) DAAssistanceType assistanceType;

- (id)initWithOptions:(NSArray *)menuOptions;
- (NSString *)assistanceTypeTag;

@end
