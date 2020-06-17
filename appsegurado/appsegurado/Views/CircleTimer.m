//
//  CircleTimer.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 05/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "CircleTimer.h"
#import "BaseView.h"
@interface CircleTimer(){
    float overArc;
    UIColor *overColorArc;
    NSString *title;
    UILabel *lblTitle;
    UILabel *lblMissing;
    UILabel *lblNumDays;
    NSString *numDays;
    UILabel *lblDays;
    
}
@end
@implementation CircleTimer
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    NSLog(@"aqui %f ",rect.size.height);
    int maxSize = 90;
    if(rect.size.width > maxSize){
        
        CGRect newRect = CGRectMake((rect.size.width-maxSize)/2, 30, maxSize, rect.size.height);
        rect = newRect;
    }
    
    [self drawArcRect:rect percent:1.0f color:[UIColor lightGrayColor]];
    [self drawArcRect:rect percent:overArc color:overColorArc];
    
    if(lblMissing){
        [lblMissing removeFromSuperview];
    }
    lblMissing = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, -20, rect.size.width, 20)];
    
    
    if([numDays intValue] <= 1){
        [lblMissing setText:@"Falta"];
    }else{
        [lblMissing setText:@"Faltam"];
    }
    
    
    [lblMissing setTextAlignment:NSTextAlignmentCenter];
    [lblMissing setAdjustsFontSizeToFitWidth:YES];
    [lblMissing setMinimumScaleFactor:0.25f];
    [lblMissing setFont:[BaseView getDefatulFont:Small bold:NO]];
    [lblMissing setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [self addSubview:lblMissing];
    
    
    if(![title isEqualToString:@""]){
        if(lblTitle){
            [lblTitle removeFromSuperview];
        }
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.size.height-20, rect.size.width, 30)];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        if([title containsString:@" "]){
            [lblTitle setNumberOfLines:2];
        }else{
            [lblTitle setNumberOfLines:1];
        }
        [lblTitle setAdjustsFontSizeToFitWidth:YES];
        [lblTitle setMinimumScaleFactor:0.25f];
        [lblTitle setText:title];
        [lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
        [lblTitle setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [self addSubview:lblTitle];
    }
    if(lblNumDays){
        [lblNumDays removeFromSuperview];
    }
    lblNumDays = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x + 5, 0, rect.size.width-10, rect.size.width)];
    [lblNumDays setTextAlignment:NSTextAlignmentCenter];
    [lblNumDays setNumberOfLines:0];
    [lblNumDays setAdjustsFontSizeToFitWidth:YES];
    [lblNumDays setMinimumScaleFactor:0.5f];
    [lblNumDays setText:numDays];
    [lblNumDays setFont:[BaseView getDefatulFont:Large bold:NO]];
    [lblNumDays setTextColor:overColorArc];
    [self addSubview:lblNumDays];
   
    if(lblDays){
        [lblDays removeFromSuperview];
    }
    lblDays = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x+5, 20, rect.size.width-10, rect.size.width)];
    [lblDays setTextAlignment:NSTextAlignmentCenter];
    [lblDays setNumberOfLines:0];
    [lblDays setAdjustsFontSizeToFitWidth:YES];
    [lblDays setMinimumScaleFactor:0.5f];
    if([numDays intValue] > 1){
        [lblDays setText:NSLocalizedString(@"DIAS",@"")];
    }else{
        [lblDays setText:NSLocalizedString(@"DIA",@"")];
    }
    [lblDays setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [lblDays setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [self addSubview:lblDays];

}



-(void) drawArcRect:(CGRect) rect percent:(float)percent color:(UIColor*) color{
    
    if(percent > 1){
        percent = 1;
    }
    if(percent < 0){
        percent = 0;
    }
    
  
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef arc = CGPathCreateMutable();
    
    CGPathAddArc(arc, NULL,
                 CGRectGetMidX(rect), CGRectGetMidX(rect), //center point
                 (rect.size.width/2)-5,//radius
                 DEGREES_TO_RADIANS(270),//startAngle
                 DEGREES_TO_RADIANS(-90 + (360 * (1 - percent) )),//FinishAngle
                 YES);
    
    CGFloat lineWidth = 3;
    if([UIColor lightGrayColor] == color){
        lineWidth = 2.0f;
    }
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   lineWidth,
                                   kCGLineCapButt,
                                   kCGLineJoinMiter, // the default
                                   10); // 10 is default miter limit
    
    CGContextSaveGState(context);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddPath(c, strokedArc);
    CGContextSetFillColorWithColor(c, color.CGColor);
    CGContextDrawPath(c, kCGPathFill);
    CGContextRestoreGState(context);
    
    CFRelease(arc);

}
-(void) setOverArcPercent:(float)percent color:(UIColor*) color{
    overArc = percent;
    overColorArc = color;
}

-(void) setTitle:(NSString*)t{
    title = t;
}
-(void) setNumDays:(NSString*) num{
    numDays = num;
    if([numDays intValue] <= 1){
        [lblMissing setText:@"Falta"];
    }
}
@end
