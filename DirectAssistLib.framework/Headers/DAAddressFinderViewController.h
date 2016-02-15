//
//  DAAddressFinderViewController.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAGeocoder.h"

enum {
	kDAAddressSearchTypeZipcode = 0,
	kDAAddressSearchTypeStreetAndCity = 1
};
typedef NSInteger kDAAddressSearchType;

@class DAAddress, DAProgressHUD;
@protocol DAAddressFinderViewControllerDelegate;

@interface DAAddressFinderViewController : UITableViewController <UISearchBarDelegate, DAGeocoderDelegate> {
	IBOutlet UISearchBar *searchBar;
	NSArray *searchResult;
	
	id <DAAddressFinderViewControllerDelegate> __unsafe_unretained delegate;
	DAProgressHUD *progressHUD;
}

@property (nonatomic, unsafe_unretained) id <DAAddressFinderViewControllerDelegate> delegate;
@property (assign) kDAAddressSearchType addressSearchType;

- (void)setScopeDisplay:(NSInteger)selectedScopeIndex;
- (IBAction)btnCancel:(id)sender;

@end

@protocol DAAddressFinderViewControllerDelegate <NSObject>

@optional
- (void)addressFinderViewController:(DAAddressFinderViewController *)addressFinderViewController
				   didSelectAddress:(DAAddress *)selectedAddress;

@end

