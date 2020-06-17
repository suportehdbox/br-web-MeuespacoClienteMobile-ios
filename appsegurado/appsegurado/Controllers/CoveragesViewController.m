//
//  CoveragesViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/04/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "CoveragesViewController.h"

@interface CoveragesViewController (){

    CoverageView *view;
    InsuranceBeans *currentBeans;
    

}

@end

@implementation CoveragesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (CoverageView*) self.view;
    
    [view loadView:[[currentBeans.itens objectAtIndex:0] coveragesArray] titleCoverage:[[currentBeans.itens objectAtIndex:0] desc]];
    
    if([currentBeans.itens count] <= 1){
        [view hideOtherCoverages:YES];
    }
    self.title = NSLocalizedString(@"Apolices", @"");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setCoveragesInsurace:(InsuranceBeans*)beans{
    currentBeans = beans;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)tableView:(JNExpandableTableView *)tableView canExpand:(NSIndexPath *)indexPath
{
    return [view tableView:tableView canExpand:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [view tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [view tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(IBAction) changeCoverages:(id)sender{
    if([currentBeans.itens count] <= 1){
        return;
    }
    [[UILabel appearanceWhenContainedIn:[UIAlertController class], nil] setNumberOfLines:2];
    [[UILabel appearanceWhenContainedIn:[UIAlertController class], nil] setFont:[UIFont systemFontOfSize:8.0]];
    [[UILabel appearanceWhenContainedIn:[UIAlertController class], nil] setAdjustsFontSizeToFitWidth:YES];

    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Escolha o item que deseja",@"") message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (ItemInsurance *item in currentBeans.itens) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:item.desc style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [view loadView:[item coveragesArray] titleCoverage:[NSString stringWithFormat:@"%@",[item desc]]];
        }];
        
        [controller addAction:action];
    }
    [self presentViewController:controller animated:YES completion:nil];
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [view tableView:tableView viewForHeaderInSection:section];
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [view tableView:tableView heightForRowAtIndexPath:indexPath];
//}

@end
