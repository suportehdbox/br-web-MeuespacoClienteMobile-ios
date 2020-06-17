//
//  ExtractTableViewCell.h
//  appsegurado
//
//  Created by Luiz Zenha on 04/06/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vision360EventBeans.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    NSTop,
    NSBottom,
    NSBoth,
    NSNone,
} NSDirection;



@interface HeaderExtractTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *bg;

-(void) addShadow;
@end

@interface FooterExtractTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblValueTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblPhrase;
-(void) addShadow;
@end

@interface ExtractTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UILabel *mounthLabel;
@property (weak, nonatomic) IBOutlet UIView *vlineBot;
@property (weak, nonatomic) IBOutlet UIView *vlineTop;
@property (weak, nonatomic) IBOutlet UIView *viewNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

-(void) configLayout:(NSDirection)direction beans:(Vision360EventBeans *)beans indexPath:(NSString*)indexPath;

+(CGFloat) returnHeightRowWithBeans:(Vision360EventBeans *)beans;
@end


@interface HeaderAssistExtractTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *bg;

-(void) addShadow;
@end

@interface AssistItemExtractTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet UIView *viewInfo;

-(void) addShadow;
-(void) configLayoutBeans:(Vision360EventBeans *)beans;
@end

NS_ASSUME_NONNULL_END
