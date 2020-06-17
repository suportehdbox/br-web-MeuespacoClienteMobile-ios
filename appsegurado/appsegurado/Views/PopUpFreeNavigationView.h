//
//  PopUpFreeNavigationView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 16/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface PopUpFreeNavigationView : BaseView


@property (nonatomic,strong) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong) IBOutlet UILabel *lblDescription;
@property (nonatomic,strong) IBOutlet UILabel *lblCheck;
@property (nonatomic,strong) IBOutlet UISwitch *check;
@property (nonatomic,strong) IBOutlet CustomButton *btOK;
@property (nonatomic,strong) IBOutlet UIView *bgPopUp;

-(void) loadView;
@end
