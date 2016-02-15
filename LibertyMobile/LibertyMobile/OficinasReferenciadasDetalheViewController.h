//
//  OficinasReferenciadasDetalheViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OficinasReferenciadasDetalheViewControllerDelegate;

@interface OficinasReferenciadasDetalheViewController : UIViewController {
    IBOutlet UIButton* btnPhone;
    NSMutableDictionary* cellDict;
    IBOutlet UIWebView *webInfo;
    
	id<OficinasReferenciadasDetalheViewControllerDelegate> delegate;
}

@property(nonatomic,retain)NSMutableDictionary* cellDict;
@property(nonatomic,retain)IBOutlet UIWebView *webInfo;

@property (nonatomic, assign) id<OficinasReferenciadasDetalheViewControllerDelegate> delegate;

//- (IBAction)btnMenu:(id)sender;
- (IBAction)btnCallPhone:(id)sender;
- (IBAction)btnMapa:(id)sender;

@end

@protocol OficinasReferenciadasDetalheViewControllerDelegate <NSObject>

@optional

- (void)oficinaDetalheViewController:(OficinasReferenciadasDetalheViewController *)controller dict:(NSMutableDictionary*)dict;

@end
