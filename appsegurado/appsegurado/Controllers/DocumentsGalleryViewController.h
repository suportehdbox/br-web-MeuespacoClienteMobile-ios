//
//  DocumentsGalleryViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "DocumentsGalleryView.h"
#import "DocumentsModel.h"


@protocol DocumentsGalleryDelegate <NSObject>

@optional
-(void) didSelectedDocument:(DocumentBeans*)beans;
-(void) didSelectedImage:(UIImage*)image;

@end
@interface DocumentsGalleryViewController : BaseViewController <UICollectionViewDelegate,UICollectionViewDataSource, DocumentsModelDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic,assign) id<DocumentsGalleryDelegate> delegate;


- (id)initWithPhotos:(NSMutableArray*) photos;
- (id)initWithDocuments:(NSString*)policyNumber;
@end
