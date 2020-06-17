//
//  ContactViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "ContactModel.h"

@interface ContactViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource,ContactModelDelegate>

-(void) hideMenuButton;
@end
