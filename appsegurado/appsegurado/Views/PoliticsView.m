//
//  PoliticsView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "PoliticsView.h"

@implementation PoliticsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
    [self.webView setUserInteractionEnabled:YES];
//    [self.webView setOpaque:YES];
//    [self.webView setScalesPageToFit:YES];
}


-(void) loadText:(NSString*) text{
    [self.webView loadHTMLString:text baseURL:nil];
}

@end
