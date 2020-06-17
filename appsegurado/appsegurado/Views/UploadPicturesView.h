//
//  UploadPicturesView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 19/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"


@protocol UploadPhotoCellDelegate <NSObject>

-(void) photoSelected:(int)index button:(UIButton*) button ;
-(void) longPressed:(int) index;

@end
@interface UploadPicturesView : BaseView <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btTakePicture;
@property (strong, nonatomic) IBOutlet UILabel *lblReportPhoto;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionPhotos;
@property (strong, nonatomic) IBOutlet UILabel *lblQtdPhotos;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructionPhoto;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightPhotos;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UILabel *lblLoading;
@property (strong, nonatomic) IBOutlet CustomButton *btNext;
@property (strong, nonatomic) IBOutlet UIButton *btDoubts;
-(void) loadView;
-(void) unloadView;
-(void) updateArrayImages:(NSMutableArray*) array;
-(void) startLoading:(NSString*)message;
-(void) stopLoading;
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath delegate:(id<UploadPhotoCellDelegate>) delegate;
-(void) showSuccessPopUp:(NSString*) claim;


@property (strong, nonatomic) IBOutlet UIView *popUpSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitleSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblClaimNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructions;
@property (strong, nonatomic) IBOutlet CustomButton *btPopUpSuccess;


@end


@interface UploadPhotoCell : UICollectionViewCell <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView* imgPhoto;
@property (strong, nonatomic) IBOutlet UIButton* button;
@property (strong, nonatomic) NSIndexPath* indexpath;
@property (assign, nonatomic) id<UploadPhotoCellDelegate> delegate;
-(void) setSelectedDelete:(BOOL) select;
@end
