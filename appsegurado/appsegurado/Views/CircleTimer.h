//
//  CircleTimer.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 05/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleTimer : UIView

-(void) setOverArcPercent:(float)percent color:(UIColor*) color;
-(void) setTitle:(NSString*)t;
-(void) setNumDays:(NSString*) num;
@end
