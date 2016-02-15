//
//  PickerTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerTableViewCell : UITableViewCell {
    IBOutlet UITextField* textField;
}

@property(nonatomic,retain)IBOutlet UITextField* textField;

@end
