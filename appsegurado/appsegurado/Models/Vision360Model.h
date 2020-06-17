//
//  Vision360Model.h
//  appsegurado
//
//  Created by RODRIGO MACEDO on 28/05/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//

#ifndef Vision360Model_h
#define Vision360Model_h
#import "BaseModel.h"
#import "Vision360Model.h"
#import "Vision360EventBeans.h"
#import "Vision360Beans.h"

@protocol VisionModelDelegate <NSObject>
-(void) checkSuccess;
-(void) visionResult:(Vision360Beans * )currentBeans;
-(void) visionError:(NSString*)message;
@end

@interface Vision360Model : BaseModel <ConexaoDelegate>

@property (nonatomic,assign) id<VisionModelDelegate> delegate;

-(void)checkEvent:(NSString*)policy;
-(void) getListEvent:(NSString*)policy;

@end


#endif /* Vision360Model_h */
