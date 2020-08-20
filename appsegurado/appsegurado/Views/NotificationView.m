//
//  NotificationView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 14/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "NotificationView.h"
#import "NotificationViewCell.h"
#import "NotificationBeans.h"
@interface NotificationView(){
    NSMutableArray *array;
    UIActivityIndicatorView *activity;
}
@end
@implementation NotificationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
    array = [[NSMutableArray alloc] init];
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [BaseView addDropShadow:_bgTable];
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setCenter:self.center];
    [activity startAnimating];
    [self addSubview:activity];
    
    [_btLGPD setAttributedTitle:[self getLGPDText] forState:UIControlStateNormal];
    [_btLGPD.titleLabel setNumberOfLines:6];
    [_btLGPD.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_btLGPD.titleLabel setMinimumScaleFactor:0.5];

}
-(void) unloadView{
    
}
-(void) showLoading{
    [activity startAnimating];
    [activity setHidden:NO];
    [_table setHidden:YES];
}
-(void) stopLoading{
    [activity stopAnimating];
    [activity setHidden:YES];
    [_table setHidden:NO];
}

-(void) setArrayAfterDelete:(NSArray*) arrayBase atIndexPath:(NSIndexPath *)indexPath{
    array = [[NSMutableArray alloc] initWithArray:arrayBase];
    [_table deleteSections:[[NSIndexSet alloc] initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

-(void) loadNotifications:(NSArray*) arrayBase{
    [self stopLoading];
    array = [[NSMutableArray alloc] initWithArray:arrayBase];
    [_table reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NotificationViewCell *cell =  (NotificationViewCell*) [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    
    NotificationBeans *beans = [array objectAtIndex:indexPath.section];
    NSString *body = [NSString stringWithFormat:@"<style>body{font-family:Arial;font-size:14px;padding:5px;color:%@;}</style><p>%@",NSLocalizedString(@"AzulEscuro",@"") , beans.alert];
    [cell.webview loadHTMLString:body baseURL:nil];
    [cell.webview setDelegate:self];
    [cell setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [BaseView addDropShadow:cell.bgView];

    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [array count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}
@end
