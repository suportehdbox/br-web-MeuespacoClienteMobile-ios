//
//  AccidentView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 02/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CircleButton.h"

@interface AccidentView : BaseView
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblFooter;
@property (strong, nonatomic) IBOutlet UILabel *lblMyAssistances;
@property (strong, nonatomic) IBOutlet CircleButton *btSinister;
@property (strong, nonatomic) IBOutlet CircleButton *bt24Assist;
@property (strong, nonatomic) IBOutlet CircleButton *btGlassAssist;
@property (strong, nonatomic) IBOutlet UIButton *btHelp;
@property (strong, nonatomic) IBOutlet CustomButton *btStatusClaim;
@property (strong, nonatomic) IBOutlet CustomButton *btMyAssistances;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *glass_assist_const;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sinister_const;

-(void) loadView :(BOOL) userLogged;

@end
