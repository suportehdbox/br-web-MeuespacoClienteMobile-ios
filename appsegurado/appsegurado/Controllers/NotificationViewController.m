//
//  NotificationViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 14/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationView.h"
#import "NotificationBeans.h"
@interface NotificationViewController ()
{
    NotificationView *view;
    NotificationModel *model;
    NSMutableArray *arrayNotifictaions;
}
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super addLeftMenu];
    view = (NotificationView*) self.view;
    [view loadView];
    arrayNotifictaions = [[NSMutableArray alloc] init];
    
    model = [[NotificationModel alloc] init];
    [model setDelegate:self];
    [model getNotifications];
    
    [view showLoading];
    
    self.title = NSLocalizedString(@"NotificacoesMenu", @"");
    
    [self setAnalyticsTitle:@"Notificações"];
    //
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"NotificacoesMenu", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    if(model != nil){
        [model setDelegate:nil];
        model = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [view numberOfSectionsInTableView:tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [view tableView:tableView numberOfRowsInSection:section];
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [view tableView:tableView viewForFooterInSection:section];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [view tableView:tableView viewForHeaderInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [view tableView:tableView heightForHeaderInSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [view tableView:tableView heightForRowAtIndexPath:indexPath];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return [view tableView:tableView heightForFooterInSection:section];
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [view tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(NSArray*) tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    // action one
    UITableViewRowAction *deleteAction = [UITableViewRowAction  rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"Apagar",@"") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //Delete

        [self deleteRow:indexPath];        
    }];
    
    deleteAction.backgroundColor = [UIColor blueColor];
    return [[NSArray alloc] initWithObjects:deleteAction, nil];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
//        [dataArray removeObjectAtIndex:indexPath.row];
    }
    
    
//    [tableView reloadData];
}

-(void) deleteRow:(NSIndexPath*) indexPath{
    NotificationBeans *beans = (NotificationBeans*)[arrayNotifictaions objectAtIndex:indexPath.section];
    [model deleteNotification:beans.idNotification];
    [arrayNotifictaions removeObjectAtIndex:indexPath.section];
    [view setArrayAfterDelete:arrayNotifictaions atIndexPath:indexPath];
    //Should call model
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    InsuranceBeans *beans = [view getInsuranceClickedAtIndexPath:indexPath];
    //    [self performSegueWithIdentifier:@"ShowDetailPolicy" sender:beans];
    
//    PaymentBeans *payment = [parcels objectAtIndex:indexPath.row - 1];
//    ExtendParcelViewController *extends = [[ExtendParcelViewController alloc] initPaymentBeans:payment contract:currentBeans.contract issuance:currentBeans.issuance ciaCode:currentBeans.ciaCode ClientCode:currentBeans.cifCode];
//    [self presentViewController:extends animated:YES completion:nil];
    
}

#pragma mark Delegate
-(void) returnNotifications:(NSMutableArray*)notifications{
    
    arrayNotifictaions = notifications;
    if([notifications count] > 0){
        [view loadNotifications:arrayNotifictaions];
    }else{
        [view stopLoading];
        [view showLoadingMessage:NSLocalizedString(@"NenhumaNotificacao", @"")];
    }
    

}
-(void) notificationsError:(NSString*)message{
//    [view showMessage:NSLocalizedString(@"ErrorTitle",@"")  message:message];
    [view stopLoading];
    [view showLoadingMessage:NSLocalizedString(@"NenhumaNotificacao", @"")];
    
}

@end
