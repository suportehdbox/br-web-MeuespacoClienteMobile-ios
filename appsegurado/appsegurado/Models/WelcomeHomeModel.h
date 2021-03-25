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
-(void) returnUpdateRequired:(BOOL) required;
@end
@interface WelcomeHomeModel : BaseModel <ConexaoDelegate>
@property (nonatomic,weak) id<WelcomeHomeModelDelegate> delegate;
-(void) getWelcomeBackgroundImage;
-(void) getUpdateRequired;
-(UIImage*) loadCachedImage;
@end
