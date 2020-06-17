//
//  HomeModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 05/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
#import "UserBeans.h"
#import "InsuranceBeans.h"
#import "PolicyBeans.h"

@protocol HomeModelDelegate <NSObject>

-(void) homeSuccessV2:(PolicyBeans*)beans;
-(void) paymentsSuccess:(PolicyBeans*)beans; 
-(void) homeError:(NSString*)message;

@optional
-(void) homeSuccess:(InsuranceBeans*)beans __deprecated_msg("Use homeSuccessV2(PolicyBeans*) instead");
@end
@interface HomeModel : BaseModel<ConexaoDelegate>

@property (nonatomic) id<HomeModelDelegate> delegate;
-(void) getHome;
-(void) getPaymentInfo;
-(void) askToUseTouchId;
@end
