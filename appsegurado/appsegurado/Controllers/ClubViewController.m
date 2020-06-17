//
//  ClubViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 03/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClubViewController.h"
#import "ClubView.h"
#import "AppDelegate.h"

@interface ClubViewController (){
    NSString *sessionId;
    ClubModel *model;
    ClubView *view;
    BOOL openClub;
    AppDelegate *appDelegate;
}

@end

@implementation ClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super addLeftMenu];
    self.title = NSLocalizedString(@"ClubeVantagensTitulo",@"");
    view = (ClubView *) self.view;
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    model = [[ClubModel alloc] init];
    [model setDelegate:self];
    
    if(![appDelegate isUserLogged]){
        [view loadOffView];
    }else{
        [view loadView];
        openClub = false;
        [model getClientSession];
    }
    [model getClubImage];
    
    [self setAnalyticsTitle:@"Clube Liberty"];
//    [GoogleAnalyticsManager send:@"Clube Liberty de Vantagens"];
//    

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title = NSLocalizedString(@"ClubeVantagensTitulo",@"");

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"";
}
-(void) loadClub{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@%@",[model getClubUrl], sessionId]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];

    [view loadRequest: request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clubeSession:(NSString *)sessionID{
    sessionId = sessionID;
    if(openClub){
        [self loadClub];
    }
}

-(void)updateClubImage:(UIImage *)image{
    dispatch_async(dispatch_get_main_queue(), ^{
        [view updateClubImage:image];
    });
}

-(void)clubeError:(NSString *)message{


}
- (IBAction)openClub:(id)sender {
    if(![appDelegate isUserLogged]){
        [self performSegueWithIdentifier:@"gotoRegister" sender:nil];
    }else{
        if(sessionId == nil || [sessionId isEqualToString:@""]){
            openClub = true;
            [model getClientSession];
        }else{
            [self loadClub];
        }
    }
}
- (IBAction)gotoLogin:(id)sender {
    [appDelegate setGotoLoginView:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
