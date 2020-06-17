//
//  ConectModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
@protocol ContactModelDelegate <NSObject>
-(void) contactsReturn:(NSArray*) arrayBeans;
-(void) contactError:(NSString*)message;
-(void) contactEmpty;
@end
@interface ContactModel : BaseModel <ConexaoDelegate>

@property (nonatomic,assign) id<ContactModelDelegate> delegate;
-(void) getAgentsContact;

@end
