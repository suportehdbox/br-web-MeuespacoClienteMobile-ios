//
//  DocumentsGalleryView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
@interface DocumentsCollectionCell : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UIImageView *imageCell;
@property (nonatomic,strong) IBOutlet UIButton *btSelected;
@end

@interface DocumentsGalleryView : BaseView

@property(nonatomic,strong) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic,strong) IBOutlet UILabel *lblLoading;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath image:(UIImage*)image;
-(void) stopLoading;
-(void) startLoading:(NSString*)message;
-(void) loadView;
-(void) updateScreen;
-(void) showNoDocumentsMessage;
@end


