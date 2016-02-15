//
//  SinistroNovoFotosDetalheViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SinistroNovoFotosDetalheViewControllerDelegate;

@interface SinistroNovoFotosDetalheViewController : UIViewController <UIActionSheetDelegate>
{
    NSUInteger thumbSectionIndex;
	NSUInteger thumbImageIndex;
	UIImageView *photoView;
	UIImage *fullSizedImage;
	UIBarButtonItem *deleteButton;
	UIActionSheet *uiActionSheet;
	BOOL deleteEnabled;
	id<SinistroNovoFotosDetalheViewControllerDelegate> delegate;	

}

@property (nonatomic) NSUInteger thumbSectionIndex;
@property (nonatomic) NSUInteger thumbImageIndex;
@property (nonatomic, retain) IBOutlet UIImageView *photoView;
@property (nonatomic, retain) UIImage *fullSizedImage;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *deleteButton;
@property (nonatomic, retain) UIActionSheet *uiActionSheet;
@property (nonatomic) BOOL deleteEnabled;
@property (nonatomic, assign) id<SinistroNovoFotosDetalheViewControllerDelegate> delegate;

- (IBAction)deletePressed:(id)sender;
//- (IBAction)btnBack:(id)sender;
- (IBAction)deletePhoto;
- (void)applicationEnteredBackground;

@end

@protocol SinistroNovoFotosDetalheViewControllerDelegate <NSObject>

- (void)SinistroNovoFotosDetalheViewController:(SinistroNovoFotosDetalheViewController *)controller didPressDelete:(BOOL)pressedDelete;

@end
