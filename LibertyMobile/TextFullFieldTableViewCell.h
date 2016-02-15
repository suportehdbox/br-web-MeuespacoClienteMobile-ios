//
//  TextFullFieldTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/27/12.
//
//

#import <UIKit/UIKit.h>

@interface TextFullFieldTableViewCell : UITableViewCell {
    UITextField* txtField;
}

@property(nonatomic,retain)IBOutlet UITextField* txtField;

@end
