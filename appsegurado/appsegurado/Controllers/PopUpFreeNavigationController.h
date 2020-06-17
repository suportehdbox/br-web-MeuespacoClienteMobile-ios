//
//  PopUpFreeNavigationController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 16/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpFreeNavigationDelegate <NSObject>
-(void) finishedPopUp;
@end

@interface PopUpFreeNavigationController : UIViewController
- (id)init;
-(BOOL) shouldDisplayPopUp;
@property (nonatomic,assign) id<PopUpFreeNavigationDelegate> delegate;
@end
