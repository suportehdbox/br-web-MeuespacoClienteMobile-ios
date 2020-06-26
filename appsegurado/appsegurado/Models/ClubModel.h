//
//  ClubModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 03/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
@protocol ClubModelDelegate <NSObject>
-(void) clubeError:(NSString*)message;
-(void) clubeSession:(NSString*)sessionID url:(NSString*) url;
-(void) updateClubImage:(UIImage*)image;
@end
@interface ClubModel : BaseModel  <ConexaoDelegate>

@property (nonatomic) id<ClubModelDelegate> delegate;
-(void) getClientSession;
-(void) getClubImage;
-(BOOL) getAlreadyAgreed;
-(void) setAgreedTerms;
@end
