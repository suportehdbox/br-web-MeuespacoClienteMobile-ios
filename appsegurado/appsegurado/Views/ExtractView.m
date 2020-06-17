//
//  ExtractView.m
//  appsegurado
//
//  Created by Luiz Zenha on 04/06/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//

#import "ExtractView.h"

@interface ExtractView(){
    NSMutableArray *array;
    UIActivityIndicatorView *activity;
}
@end

@implementation ExtractView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_table setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_bgTable setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
//    [BaseView addDropShadow:_bgTable];
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setCenter:self.center];
    [activity startAnimating];
    [self addSubview:activity];
}

-(void) reloadTable{
    [_table reloadData];
}

-(void) showLoading{
    [activity startAnimating];
    [activity setHidden:NO];
    [_bgTable setHidden:YES];


}
-(void) stopLoading{
    [activity stopAnimating];
    [activity setHidden:YES];
    [_bgTable setHidden:NO];

}
    
@end
