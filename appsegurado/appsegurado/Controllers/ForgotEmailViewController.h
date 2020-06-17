//
//  ForgotEmailViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 09/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "ForgotEmailModel.h"



@interface ForgotEmailViewController : BaseViewController <ForgotEmailModelDelegate>

- (id)initWithIndexScreen:(int)index arrayQuestions:(NSArray*)questions arrayId:(NSArray*) ids userCPF:(NSString*) userCPF;
@end
