//
//  UploadPicturesViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 19/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "ClaimModel.h"
#import "UploadPicturesView.h"

@interface UploadPicturesViewController : BaseViewController <ClaimModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UploadPhotoCellDelegate>


-(void) setClaimNumber:(NSString*) number policyNumber:(NSString*) policy;

@end
