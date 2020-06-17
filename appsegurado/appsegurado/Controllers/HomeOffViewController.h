//
//  HomeOffViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeOffView.h"
#import "AutoWorkShopModel.h"
@interface HomeOffViewController : BaseViewController <AutoWorkShopModelDelegate>

@property (nonatomic, assign) IBOutlet HomeOffView *homeView;
-(IBAction)doLogin:(id)sender;
@end
