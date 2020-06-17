//
//  SecondPolicyViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/09/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolicyModel.h"
#import "PolicyBeans.h"
#import "CustomWebViewController.h"

@protocol SecondPolicyDelegate
-(void) loadPDFViewController:(CustomWebViewController*) viewController;
@end
@interface SecondPolicyViewController : UIViewController <PolicyModelDelegate>


typedef NS_ENUM(NSInteger, SearchType) {
    SearchTypeUknow,
    SearchTypeNexts,
    SearchTypeCurrents,
    SearchTypeOlds
    
};
- (id)initPolicy:(PolicyBeans*)policy delegate:(id<SecondPolicyDelegate>) customDelegate;
@end
