//
//  NotificationDetailView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/07/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface NotificationDetailView : BaseView
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIView *box_view;

-(void) loadView:(NSString*)detailText;
@end
