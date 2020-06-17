//
//  NotificationDetailView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/07/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "NotificationDetailView.h"

@implementation NotificationDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView:(NSString*)detailText{
    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
    NSString *html = [NSString stringWithFormat:@"<html>\
    <head></head>\
    <style>\
    .body{\
        font-family: Arial, Helvetica, sans-serif;\
    color:'#616265';\
        font-size: 12px;\
    margin: 10px;\
    }\
    </style><body>%@</body></html>", detailText];
    [BaseView addDropShadow:_box_view];
    [_webView loadHTMLString:html baseURL:nil];
    
}

@end
