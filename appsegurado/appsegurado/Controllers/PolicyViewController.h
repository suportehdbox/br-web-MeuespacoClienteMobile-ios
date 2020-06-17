//
//  PolicyViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "PolicyModel.h"
#import "ClaimModel.h"
@interface PolicyViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, PolicyModelDelegate, ClaimModelDelegate>
- (IBAction)clickLoadOldPolicy:(id)sender;
-(void) loadOldPolices;
-(void) loadPolicesFromClaim;
-(void) loadPolicesFromClaimOff:(NSString*)platePolicy cpf:(NSString*)cpf;
-(void) loadPolicesFromDocuments;
-(void) setTitleTable:(NSString*) text;
-(void) set24hsAssist;
@end
