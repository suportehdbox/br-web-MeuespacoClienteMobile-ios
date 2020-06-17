//
//  WelcomeHomeViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "WelcomeHomeViewController.h"
#import "WelcomeHomeView.h"
#import "AppDelegate.h"



@interface WelcomeHomeViewController (){
    WelcomeHomeView *view;
    WelcomeHomeModel *model;
    AppDelegate *appDelegate;
    PopUpFreeNavigationController *popup;
    NSTimer *timerPopUp;
}

@end

@implementation WelcomeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setShowsContactButton:NO];
    
    view = (WelcomeHomeView*) self.view;
    [view loadView];
    model = [[WelcomeHomeModel alloc] init];
    [model setDelegate:self];
    UIImage *cachedBG = [model loadCachedImage];
    if(cachedBG != nil){
        [view updateBackgroundImage:cachedBG];
    }
    [model getWelcomeBackgroundImage];
    self.title = @"";
    [self setAnalyticsTitle:@"Tela Inicial"];
    
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    

    
    
    popup = [[PopUpFreeNavigationController alloc] init];
    [popup setDelegate:self];
    if([popup shouldDisplayPopUp]){
        [appDelegate setShouldShowRMessage:NO];
        timerPopUp = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(checkToShowPopUp) userInfo:nil repeats:YES];
    }else{
        [self finishedPopUp];
    }
    
}
-(void) checkToShowPopUp{
    if([appDelegate currentSr] != nil){
        if([appDelegate currentSr].sdState == SD_AVAILABLE){
            [self presentViewController:popup animated:YES completion:nil];
        }else{
            [self finishedPopUp];
        }
        [timerPopUp invalidate];
    }


}
-(void) finishedPopUp{
    //goLogin
    [appDelegate setShouldShowRMessage:YES];
    NSString *authToken = [appDelegate getAuthToken];
    if(![authToken isEqualToString:@""]){
        [self performSegueWithIdentifier:@"goLogin" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if([appDelegate gotoLoginView]){
        [appDelegate setGotoLoginView:NO];
        [self performSegueWithIdentifier:@"goLogin" sender:nil];
    }

}
-(void)dealloc{
    if(model != nil){
        [model setDelegate:nil];
        model = nil;
    }
    
}
- (IBAction)btDoLoginLater:(id)sender {
    [self performSegueWithIdentifier:@"OpenWithouLogin" sender:nil];
}

- (IBAction)btGotoContact:(id)sender {
    [super sendActionEvent:@"Clique" label:@"Atendimento"];
    [self performSegueWithIdentifier:@"ShowContact" sender:nil];
    
}
-(void) updateBackgroundImage:(UIImage*)image{
    [view updateBackgroundImage:image];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
