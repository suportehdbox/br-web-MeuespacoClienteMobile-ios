//
//  SinistroNovoFotosViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Event.h"
#import "EventPhoto.h"
#import "SinistroNovoFotosDetalheViewController.h"
#import "ThumbnailImageView.h"


@interface SinistroNovoFotosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ThumbnailImageViewSelectionDelegate, SinistroNovoFotosDetalheViewControllerDelegate>
{
    UITableView *listaTableView;

	NSManagedObjectContext *managedObjectContext;
	Event *event;
	BOOL editable;
    NSUInteger sectionToAddPhoto;

	UIAlertView *uiAlertView;
	UIActionSheet *uiActionSheet;
    
    NSString *webViewString;
}

@property (nonatomic, retain) IBOutlet UITableView *listaTableView;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL editable;
@property (nonatomic) NSUInteger sectionToAddPhoto;
@property (nonatomic, retain) UIAlertView *uiAlertView;
@property (nonatomic, retain) UIActionSheet *uiActionSheet;
@property (nonatomic, retain) NSString *webViewString;

- (id) initWithEventPhoto:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit;

- (void) addClaimPhotoButtonPressed:(NSUInteger)section;
- (void) takeNewPhoto;
- (void) selectExistingPhoto;

- (UIImage *) thumbnailFromImage:(UIImage *)originalImage width:(float)width height:(float)height;
- (NSNumber *) determineNextImagePositionForSection:(NSUInteger)sectionNumber;

- (void) saveState;

- (IBAction) btnSinistroNovo:(id)sender;

@end
