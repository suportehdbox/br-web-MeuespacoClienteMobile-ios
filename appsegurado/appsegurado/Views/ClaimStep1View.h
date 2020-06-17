//
//  ClaimStep1View.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface ClaimStep1View : BaseView
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *imgSteps;
@property (strong, nonatomic) IBOutlet CustomButton *btNext;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *betweenSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthSpace;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btDoubts;

@property (strong, nonatomic) IBOutlet UIButton *btChoice1;
@property (strong, nonatomic) IBOutlet UIButton *btChoice2;
@property (strong, nonatomic) IBOutlet UIButton *btChoice3;
@property (strong, nonatomic) IBOutlet UIButton *btChoice4;

-(void) loadView;
-(void) unloadView;
- (IBAction)selectClaimType:(id)sender;
-(int) getSelectedClaim;
@end