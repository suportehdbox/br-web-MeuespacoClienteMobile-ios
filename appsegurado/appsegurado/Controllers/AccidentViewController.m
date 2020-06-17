//
//  AccidentViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 02/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "AccidentViewController.h"
#import "PolicyViewController.h"
#import "AppDelegate.h"
#import "NewClaimOffViewController.h"
#import "CustomWebViewController.h"
#import "BaseModel.h"
#import <appsegurado-Swift.h>



@interface AccidentViewController () <NewAccidentViewDelegate> {
    NewAccidentView *newView;
    AppDelegate *appDelegate;
    
    BOOL is24assist;
    HomeAssistWebViewController *wvc;
}

@end

@implementation AccidentViewController

- (void)loadView{
    appDelegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    newView = [[NewAccidentView alloc] initWithFrame:CGRectZero allowPHS:[[[appDelegate getLoggeduser] policyHome] insurance].allowPHS loggedInUser:[appDelegate isUserLogged]] ;
    [newView setDelegate:self];
    self.view = newView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super addLeftMenu];
        
    self.title = NSLocalizedString(@"AssistenciaTitulo", @"");
    [self setAnalyticsTitle:@"Assistencia24h"];
    is24assist = false;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    is24assist = false;
    self.title = NSLocalizedString(@"AssistenciaTitulo", @"");
    
    
    //    [view loadView:appDelegate.isUserLogged];
    
    
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
    self.title = @"";
    if([segue.identifier isEqualToString:@"ShowPolicyList"]){
        PolicyViewController *controller = (PolicyViewController*) segue.destinationViewController;
        [controller loadPolicesFromClaim];
        if(is24assist){
            [controller set24hsAssist];
        }
    }else if([segue.identifier isEqualToString:@"NewClaimOff"]){
        NewClaimOffViewController *controller = (NewClaimOffViewController*) segue.destinationViewController;
        if(is24assist){
            [controller setAssist24hs];
        }
    }else if([segue.identifier isEqualToString:@"ShowBrowser"]){
        CustomWebViewController *controller = (CustomWebViewController*) segue.destinationViewController;
        BaseModel *baseMode = [[BaseModel alloc]  init];
        [controller setUrl:[baseMode getGlassAssistUrl]];
    }
}


-(void) repaint{
    self.navigationController.navigationBar.barTintColor = [BaseView getColor:@"NavBarCollor"];
}


-(void) openContact{
    [super showContactViewController];
    
}

-(void) openStatusClaim {
    [self performSegueWithIdentifier:@"ShowMyClaims" sender:nil];
}

- (void)openAutoAssist {
    is24assist = true;
    if(appDelegate.isUserLogged){
        [self performSegueWithIdentifier:@"ShowPolicyList" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"NewClaimOff" sender:nil];
    }
}

- (void)openGlassAssist {
    [self performSegueWithIdentifier:@"ShowBrowser" sender:nil];
}

- (void)openHomeAssist {
    if(wvc == nil){
        wvc = [[HomeAssistWebViewController alloc] init];
    }
    
    self.title = @"";
    [self.navigationController pushViewController:wvc animated:NO];
}

- (void)openClaim {
    if(appDelegate.isUserLogged){
        [self performSegueWithIdentifier:@"ShowPolicyList" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"NewClaimOff" sender:nil];
    }
}


@end
