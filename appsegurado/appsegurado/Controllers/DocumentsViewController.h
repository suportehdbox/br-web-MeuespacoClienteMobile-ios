//
//  DocumentsViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "DocumentsModel.h"
#import "ClaimModel.h"
@interface DocumentsViewController : BaseViewController <DocumentsModelDelegate, ClaimModelDelegate>

-(void) setPolicyNumber:(NSString*) policy;
@end
