//
//  PoliticsView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface PoliticsView : BaseView
@property (nonatomic,strong) IBOutlet UIWebView *webView;

-(void) loadView;
-(void) loadText:(NSString*) text;
@end
