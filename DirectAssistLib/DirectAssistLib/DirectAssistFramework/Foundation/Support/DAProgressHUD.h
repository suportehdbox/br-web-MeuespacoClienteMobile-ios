//
//  DAProgressHUD.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DAProgressHUD : UIAlertView {
    
    UIAlertView *alert;
}

@property (nonatomic, unsafe_unretained) UIImage *backgroundImage;
@property (nonatomic, strong) UILabel *progressMessage;

- (id)initWithLabel:(NSString *)text;
- (void)dismiss;
- (void)showWithNetworkActivityStatus;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end