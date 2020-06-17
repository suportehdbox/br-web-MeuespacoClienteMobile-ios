//
//  AutoWorkShopsViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 31/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchPopUpView.h"
#import "AutoWorkShopModel.h"
#import "AutoWorkShopView.h"
@interface AutoWorkShopsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, SearchPopUpViewDelegate, AutoWorkShopModelDelegate, MKMapViewDelegate, SWRevealViewControllerDelegate>
- (IBAction)showPopUpSearch:(id)sender;

- (IBAction)closePopupInfo:(id)sender;


@end
