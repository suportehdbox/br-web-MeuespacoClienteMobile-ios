//
//  CustomButton.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "CustomButton.h"
@interface CustomButton(){
    UIColor *_backgroundColorHighlighted;
    UIColor *_borderColorHighlighted;
    BOOL noRoundedEffect;
}
@end
@implementation CustomButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self reloadCustomization];
}

-(void) setNoRounedEffect{
    noRoundedEffect = true;
}

-(void) customizeBackground:(UIColor*)color{
    _backgroundColor = color;
    
    [self updateBackgroundColorHighlight];
    
    [self reloadCustomization];
}

-(void) customizeBorderColor:(UIColor*)color borderWidth:(CGFloat)width borderRadius:(CGFloat) radius {
    _borderColor= color ;
    _borderWidth= width;
    _borderRound = radius;
    
    [self updateBorderColorHighlight];
    
    [self reloadCustomization];
}
-(void) updateBorderColorHighlight{
    CGFloat r1, g1, b1, a1;
    [_borderColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    CGFloat r = r1 - 0.1f;
    CGFloat g = g1 - 0.1f;
    CGFloat b = b1 - 0.1f;
    _borderColorHighlighted = [UIColor colorWithRed:r green:g blue:b alpha:1.f];

}
-(void) updateBackgroundColorHighlight{
    CGFloat r1, g1, b1, a1;
    if(_backgroundColor == nil){
        _backgroundColor = [UIColor clearColor];
        _backgroundColorHighlighted = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:0.25];
    }else{
        [_backgroundColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
        
        CGFloat r = r1 - 0.1f;
        CGFloat g = g1 - 0.1f;
        CGFloat b = b1 - 0.1f;
        _backgroundColorHighlighted = [UIColor colorWithRed:r green:g blue:b alpha:1.f];
    }
   

}

-(void) reloadCustomization{
    self.layer.borderColor = [_borderColor CGColor];
    self.layer.borderWidth = _borderWidth;

    if(!noRoundedEffect){
        if(self.frame.size.height == 0){
            self.layer.cornerRadius = 25;
        }else{
            self.layer.cornerRadius =  self.frame.size.height/2;
        }
    }else{
        self.layer.cornerRadius = 0;
    }

    self.layer.backgroundColor = [_backgroundColor CGColor];
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    
    if (highlighted) {
        
        if(_borderColorHighlighted == nil || _backgroundColorHighlighted == nil){
            [self updateBorderColorHighlight];
            [self updateBackgroundColorHighlight];
        }
        
        self.layer.backgroundColor = [_backgroundColorHighlighted CGColor];
        self.layer.borderColor = [_borderColorHighlighted CGColor];
    }
    else {
        self.layer.backgroundColor = [_backgroundColor CGColor];
        self.layer.borderColor = [_borderColor CGColor];
    }

}

@end
