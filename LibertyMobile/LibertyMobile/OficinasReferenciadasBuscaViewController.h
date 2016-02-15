//
//  OficinasReferenciadasBuscaViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol OficinasReferenciadasBuscaViewControllerDelegate;

@interface OficinasReferenciadasBuscaViewController : UIViewController
{
    IBOutlet UITextField *txtCEP;
	id<OficinasReferenciadasBuscaViewControllerDelegate> delegate;
}

@property (nonatomic,retain)IBOutlet UITextField *txtCEP;
@property (nonatomic, assign) id<OficinasReferenciadasBuscaViewControllerDelegate> delegate;

//- (IBAction)btnMenu:(id)sender;
- (IBAction)btnBuscar:(id)sender;

@end


@protocol OficinasReferenciadasBuscaViewControllerDelegate <NSObject>

@optional

- (void)buscaOficinasViewController:(OficinasReferenciadasBuscaViewController *)controller cepSearch:(NSString *)cepSearch;

@end
