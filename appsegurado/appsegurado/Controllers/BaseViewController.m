//
//  BaseViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseView.h"
#import "ContactViewController.h"
#import "PoliticsViewController.h"
//#import <DirectAssistLib/GoogleAnalyticsManager.h>
#import "AppDelegate.h"
@import Firebase;

@interface BaseViewController (){
   UIBarButtonItem* revealButtonItem;
   UIBarButtonItem* contactButtonItem;
    
    
}

@end

@implementation BaseViewController
@synthesize showsContactButton,analyticsTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    showsContactButton = true;
    [self.navigationController.navigationBar setTintColor:[BaseView getColor:@"Branco"]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [FIRAnalytics setScreenName:analyticsTitle screenClass:NULL];
    
}

-(void) sendActionEvent:(NSString*) action label:(NSString*)label{

    [FIRAnalytics logEventWithName:analyticsTitle parameters:@{kFIRParameterItemName:action,
                                                                    kFIRParameterValue: label
                                                                    }];


}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(showsContactButton){
        [self addContactButton];
    }
    AppDelegate *appDelegate = (AppDelegate*)  [[UIApplication sharedApplication] delegate];
    
    [appDelegate setCurrent_controller:self];
}

-(void) addLeftMenu{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
        [self.navigationController.navigationBar.topItem setLeftBarButtonItem:revealButtonItem];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    
}

-(void) addContactButton{

    contactButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contact_button.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showContactViewController)];
    if(![Config isAliroProject]){
        [contactButtonItem setTintColor:[BaseView getColor:@"Verde"]];
    }
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:contactButtonItem];

}

-(void) showContactViewController{
    //ContactScreen
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactViewController *vc = (ContactViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ContactScreen"];
    self.title = @"";
    [vc hideMenuButton];
    [self.navigationController showViewController:vc sender:nil];
}

-(void) openTerms{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PoliticsViewController *vc = (PoliticsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PolitcsScreen"];
    self.title = @"";
    [self.navigationController showViewController:vc sender:nil];
}

-(IBAction)openLGPDSite:(id)sender{
    NSString *urlStr = NSLocalizedString(@"LGPDLink", @"");
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
   } else {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
   }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}




@end
