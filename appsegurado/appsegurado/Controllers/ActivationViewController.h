//
//  ActivationViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/08/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginModel.h"

@interface ActivationViewController : BaseViewController <LoginModelDelegate>

- (id)initWithDictionary:(NSDictionary*) content;
@end
