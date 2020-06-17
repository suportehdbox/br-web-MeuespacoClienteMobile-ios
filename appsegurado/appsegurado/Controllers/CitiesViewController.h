//
//  CitiesViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 04/01/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "CityModel.h"
@protocol CitiesViewControllerDelegate <NSObject>
-(void) citySelected:(CityBeans*)city;
@end
@interface CitiesViewController : BaseViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,assign) id<CitiesViewControllerDelegate> delegate;
-(void) setState:(NSString*) stateSelected;
@end
