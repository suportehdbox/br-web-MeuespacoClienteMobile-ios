//
//  CustomButton.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CustomButton : UIButton
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderRound;
@property (nonatomic) IBInspectable UIColor *backgroundColor;

-(void) customizeBackground:(UIColor*)color;
-(void) customizeBorderColor:(UIColor*)color borderWidth:(CGFloat)width borderRadius:(CGFloat) radius;
-(void) reloadCustomization;
@end
