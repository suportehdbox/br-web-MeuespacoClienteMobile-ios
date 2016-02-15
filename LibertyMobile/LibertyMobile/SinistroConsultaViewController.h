//
//  SinistroConsultaViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinistroConsultaTableViewCell.h"
#import "Event.h"
#import "Address.h"
#import "DadosLoginSegurado.h"

@protocol SinistroConsultaViewControllerDelegate;

@interface SinistroConsultaViewController : UIViewController <NSFetchedResultsControllerDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *consultaTableView;

	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *fetchedResultsController;
	BOOL reorderingTableRows;

    NSIndexPath *selectedItem;
    UIActionSheet *uiActionSheet;

	id<SinistroConsultaViewControllerDelegate> delegate;

    DadosLoginSegurado *dadosLoginSegurado;
}

@property (nonatomic, retain) IBOutlet UITableView *consultaTableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSIndexPath *selectedItem;
@property (nonatomic, retain) UIActionSheet *uiActionSheet;
@property (nonatomic, assign) id<SinistroConsultaViewControllerDelegate> delegate;
@property (nonatomic, assign) DadosLoginSegurado *dadosLoginSegurado;

- (void) configureCell:(SinistroConsultaTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
//- (IBAction) btnMenu:(id)sender;
- (IBAction) btnEdit:(id)sender;
- (IBAction) btnOk:(id)sender;

@end

@protocol SinistroConsultaViewControllerDelegate <NSObject>

@optional
- (void)backSinistroConsultaViewController;

@end
