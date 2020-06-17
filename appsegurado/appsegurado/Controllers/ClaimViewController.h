//
//  ClaimViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "OpenClaimBeans.h"
#import "ClaimModel.h"
#import "InsuranceBeans.h"
#import "CitiesViewController.h"

#import "ClaimStep4View.h"
@interface ClaimViewController : BaseViewController <AVAudioSessionDelegate,AVAudioPlayerDelegate, ClaimModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource,ClaimPhotoCellDelegate, CitiesViewControllerDelegate>


- (IBAction)gotoNextScreen:(id)sender;
-(void) setInsurance: (InsuranceBeans*) beans cpf:(NSString*)cpf;
-(void) setIndexScreen:(int) index beans:(OpenClaimBeans*) claimBeans;
@end
