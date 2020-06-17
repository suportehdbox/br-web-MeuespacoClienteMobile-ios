//
//  ContactViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactView.h"

@interface ContactViewController ()
{
    ContactView *view;
    ContactModel *model;
    BOOL hideMenuButton;
}
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setShowsContactButton:NO];
    if(!hideMenuButton){
        [super addLeftMenu];
    }
    
    
    view = (ContactView *) self.view;
    [view setLoading:YES];
    [view loadView];
    model = [[ContactModel alloc] init];
    [model setDelegate:self];
    [model getAgentsContact];
    self.title = NSLocalizedString(@"Atendimento", @"");
    
    [self setAnalyticsTitle:@"Atendimento"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [model setDelegate:nil];
    model = nil;
    
}
-(void) hideMenuButton{
    hideMenuButton = true;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [view numberOfSectionsInTableView:tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [view tableView:tableView numberOfRowsInSection:section];
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [view tableView:tableView viewForFooterInSection:section];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [view tableView:tableView heightForHeaderInSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [view tableView:tableView viewForHeaderInSection:section];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [view tableView:tableView heightForRowAtIndexPath:indexPath];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [view tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(void)contactsReturn:(NSArray *)arrayBeans{
    [view loadAgentsPhone:arrayBeans];

}

-(void)contactError:(NSString *)message{
    [view setLoading:NO];
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:message];
}
-(void)contactEmpty{
    [view setLoading:NO];
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
