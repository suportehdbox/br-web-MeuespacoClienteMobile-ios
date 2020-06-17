//
//  WelcomeHomeModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
@protocol WelcomeHomeModelDelegate <NSObject>

-(void) updateBackgroundImage:(UIImage*)image;
@end
@interface WelcomeHomeModel : BaseModel <ConexaoDelegate>
@property (nonatomic,weak) id<WelcomeHomeModelDelegate> delegate;
-(void) getWelcomeBackgroundImage;
-(UIImage*) loadCachedImage;
@end
