//
//  TextFieldTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldTableViewCell : UITableViewCell {
    UILabel* lblField;
    UITextField* txtField;
}

@property(nonatomic,retain)IBOutlet UILabel* lblField;
@property(nonatomic,retain)IBOutlet UITextField* txtField;

@end
