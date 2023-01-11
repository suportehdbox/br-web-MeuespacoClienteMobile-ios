//
//  StatusClaimViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "StatusClaimViewController.h"
#import "StatusClaimView.h"
#import "UploadPicturesViewController.h"

@interface StatusClaimViewController ()
{
    ClaimModel *claimModel;
    StatusClaimView  *view;
    NSMutableArray *array;
}

@end

@implementation StatusClaimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (StatusClaimView *) self.view;
    [view loadView];
    

    claimModel = [[ClaimModel alloc] init];
    [claimModel setDelegate:self];
    [claimModel getClainsStatus];
     self.title = NSLocalizedString(@"Sinistro", @"");
    
    [self setAnalyticsTitle:@"Acompanhar Sinistros"];
    // Do any additional setup after loading the view.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title = NSLocalizedString(@"Sinistro", @"");
    
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    if(claimModel != nil){
        [claimModel setDelegate:nil];
        claimModel = nil;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [view numberOfSectionsInTableView:tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [view tableView:tableView numberOfRowsInSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [view tableView:tableView viewForHeaderInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [view tableView:tableView heightForRowAtIndexPath:indexPath];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [view tableView:tableView heightForHeaderInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [view tableView:tableView cellForRowAtIndexPath:indexPath target:self action:@selector(gotoUploadScreen:)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //do nothing
}

-(void)claimStatusItens:(NSMutableArray *)arrayItens{
    [view loadClaims:arrayItens];
    array = arrayItens;
    if([arrayItens count] <= 0){
        [view showLoadingMessage:NSLocalizedString(@"ErroNenhumSinistro",@"")];
    }
    
    
}

-(IBAction)gotoUploadScreen:(id)sender{
    //OpenUploadPictures
    UIButton *bt = (UIButton*) sender;
    [self performSegueWithIdentifier:@"OpenUploadPictures" sender:[array objectAtIndex:bt.tag]];
}

-(void)claimError:(NSString *)message{
    
//    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
    
   UIAlertController *controller = [view showTryAgainTitle:@"" message:message handler:^(UIAlertAction *action) {
        [claimModel getClainsStatus];
    } handlerNo:^(UIAlertAction *actionNo) {
        //
        [view showLoadingMessage:NSLocalizedString(@"ErroNenhumSinistro",@"")];
    }];
    [self presentViewController:controller animated:YES completion:nil];
   
}

-(void) claimStatusError:(NSString *)msg{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [view showLoadingMessage:NSLocalizedString(@"ErroNenhumSinistro",@"")];
    }];

    [controller addAction:action];

    [self presentViewController:controller animated:YES completion:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.title = @"";
    
    if([segue.identifier isEqualToString:@"OpenUploadPictures"]){
        UploadPicturesViewController *upload = (UploadPicturesViewController*) [segue destinationViewController];
        ClaimBeans *beans  = (ClaimBeans*) sender;
        [upload setClaimNumber:beans.number policyNumber:beans.policy];
    }
   
}

@end
