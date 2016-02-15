//
//  PoliticaPrivacidadeViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PoliticaPrivacidadeViewController : UIViewController {
    UIWebView *webInfo;
}

@property (nonatomic, retain) IBOutlet UIWebView *webInfo;
@property (nonatomic) int origemDaTela; // 1 = menu/ 0 = cadastro;

//- (IBAction)btnMenu:(id)sender;

@end
