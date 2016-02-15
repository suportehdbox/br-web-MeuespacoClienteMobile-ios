//
//  ClubeLibertyLocaisDetalheViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ClubeLibertyLocaisDetalheViewController : UIViewController
{
    NSMutableDictionary* cellDict;
    IBOutlet UIWebView *webInfo;
    IBOutlet UIButton *btnCallPhone;
}

@property(nonatomic,retain)NSMutableDictionary* cellDict;
@property(nonatomic,retain)IBOutlet UIWebView *webInfo;

//- (IBAction)btnVoltar:(id)sender;
- (IBAction)btnMapa:(id)sender;
- (IBAction)btnCallPhone_Click:(id)sender;

@end
