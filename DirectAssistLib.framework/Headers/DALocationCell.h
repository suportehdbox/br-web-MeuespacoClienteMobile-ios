//
//  DALocationCell.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 12/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAAddress;

@interface DALocationCell : UITableViewCell {
	IBOutlet UITextView *txtLocation;
	IBOutlet UILabel *locationLabel;
}

@property (nonatomic, strong) IBOutlet UITextView *txtLocation;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;

- (void) setCellDataWithAddress:(DAAddress *)address;
- (void) setFontColor:(UIColor *)fontColor;

@end
