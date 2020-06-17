//
//  NotificationModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 14/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"


@protocol NotificationModelDelegate <NSObject>
-(void) returnNotifications:(NSMutableArray*)notifications;
-(void) notificationsError:(NSString*)message;

@end
@interface NotificationModel : BaseModel <ConexaoDelegate>

@property (nonatomic) id<NotificationModelDelegate> delegate;

-(void) getNotifications;
-(void) deleteNotification:(int)idNotification;

@end
