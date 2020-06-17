//
//  ExtractViewController.h
//  appsegurado
//
//  Created by Luiz Zenha on 04/06/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "Vision360Model.h"
#import "Vision360Beans.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExtractViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, VisionModelDelegate>

-(void) setPolicy:(NSString*)policy;

@end



NS_ASSUME_NONNULL_END
