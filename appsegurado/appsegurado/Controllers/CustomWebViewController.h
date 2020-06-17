//
//  CustomWebViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 16/04/18.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"


@interface CustomWebViewController : BaseViewController <UIWebViewDelegate>

@property (nonatomic,strong) IBOutlet UIWebView *webview;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activity;
-(void) setUrl:(NSString*) toload;
- (id)initWithUrl:(NSString*)url;
- (id)initWithUrlRequest:(NSURLRequest*)urlRequest;
- (id)initWithLocalFileRequest:(NSURLRequest*)urlRequest;
- (id)initWithAssistWithRequest:(NSURLRequest*)urlRequest;
@end
