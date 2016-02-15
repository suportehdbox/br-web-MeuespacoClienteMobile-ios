//
//  DACallMaker.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 19/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DAPhone.h"

@interface DACallMaker : NSObject <UIActionSheetDelegate> {
}

- (void)callToClientPhoneNumber:(UIView *)view assistanceType:(DAAssistanceType)assistanceType;
- (void)callToClientPhoneNumber:(UIView *)view;
+ (void)callToPhone:(DAPhone *)phone;
@end
