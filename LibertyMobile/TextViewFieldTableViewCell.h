//
//  TextViewFieldTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextViewFieldTableViewCell : UITableViewCell {
    UITextView* txtField;   
}

@property(nonatomic,retain)IBOutlet UITextView* txtField;

@end
