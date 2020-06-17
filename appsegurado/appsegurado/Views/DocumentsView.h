//
//  DocumentsView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 18/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "DocumentsGalleryView.h"
#import "CustomImageFlowLayout.h"
#import "UploadPicturesView.h"
@interface DocumentsView : BaseView <UploadPhotoCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btTakePicture;
@property (strong, nonatomic) IBOutlet UIButton *btDeletePicture;
@property (strong, nonatomic) IBOutlet UILabel *lblReportPhoto;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionPhotos;
@property (strong, nonatomic) IBOutlet UILabel *lblQtdPhotos;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructionPhoto;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightPhotos;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UILabel *lblLoading;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet CustomButton *btNext;
@property (strong, nonatomic) IBOutlet UIButton *btDoubts;
-(void) loadView;
-(void) unloadView;
-(void) updateArrayImages:(NSMutableArray*) array;
-(void) startLoading:(NSString*)message;
-(void) stopLoading;
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath target:(nullable id)target action:(nonnull SEL)action;
-(void) showSuccessPopUp:(NSString*) claim;
-(void) closeSuccessPopUp;
-(NSMutableArray*) getSelecteds;

@property (strong, nonatomic) IBOutlet UIView *popUpSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitleSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblClaimNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructions;
@property (strong, nonatomic) IBOutlet CustomButton *btPopUpSuccess;


@end


