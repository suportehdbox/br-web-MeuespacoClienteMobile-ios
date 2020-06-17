//
//  ClaimStep4View.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
@protocol ClaimPhotoCellDelegate <NSObject>

-(void) photoSelected:(NSIndexPath*)indexpath;

@end
@interface ClaimStep4View : BaseView <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *bgView2;
@property (strong, nonatomic) IBOutlet UIView *bgView3;
@property (strong, nonatomic) IBOutlet UIImageView *imgSteps;
@property (strong, nonatomic) IBOutlet CustomButton *btNext;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *betweenSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthSpace;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btDoubts;
@property (strong, nonatomic) IBOutlet UIButton *btAudio;
@property (strong, nonatomic) IBOutlet UIButton *btDelete;
@property (strong, nonatomic) IBOutlet UIButton *btTakePicture;


@property (strong, nonatomic) IBOutlet UITextView *txtReport;
@property (strong, nonatomic) IBOutlet UILabel *lblReportAudio;
@property (strong, nonatomic) IBOutlet UILabel *lblReportPhoto;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionPhotos;
@property (strong, nonatomic) IBOutlet UILabel *lblQtdPhotos;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructionPhoto;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightPhotos;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UILabel *lblLoading;


-(void) loadView;
-(void) unloadView;
-(void) changeButtonPlay;
-(void) changeButtonPause;
-(void) changeButtonRecord;
-(void) updateArrayImages:(NSMutableArray*) array;
-(void) startLoading:(NSString*)message;
-(void) stopLoading;
-(void) changeButtonRecording;
-(NSString*) getDesc;
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath delegate:(id<ClaimPhotoCellDelegate>) delegate;
-(void) showSuccessPopUp:(NSString*) claim;
-(void) updateLblTimer:(int) seconds;

@property (strong, nonatomic) IBOutlet UIView *popUpSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitleSuccess;
@property (strong, nonatomic) IBOutlet UILabel *lblClaimNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblInstructions;
@property (strong, nonatomic) IBOutlet CustomButton *btPopUpSuccess;


@end


@interface ClaimPhotoCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView* imgPhoto;
@property (strong, nonatomic) NSIndexPath* indexpath;
@property (assign, nonatomic) id<ClaimPhotoCellDelegate> delegate;
@end
