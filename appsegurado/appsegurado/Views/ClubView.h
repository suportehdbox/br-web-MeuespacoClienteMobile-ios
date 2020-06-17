//
//  ClubView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 04/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomButton.h"

@interface ClubView : BaseView <UIWebViewDelegate>

@property (nonatomic,strong) IBOutlet UIView *viewDescription;
@property (nonatomic,strong) IBOutlet UIWebView *webView;
@property (nonatomic,strong) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong) IBOutlet UILabel *lblDescription;
@property (nonatomic,strong) IBOutlet CustomButton *btAccess;
@property (nonatomic,strong) IBOutlet CustomButton *btLogin;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthScroll;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *betweenButtonSpace;


-(void) loadView;
-(void) loadOffView;
-(void) loadRequest:(NSURLRequest*) request;
-(void) updateClubImage:(UIImage*) image;
@end
