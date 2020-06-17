//
//  DetailNotificationViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/07/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "DetailNotificationViewController.h"
#import "NotificationDetailView.h"

@interface DetailNotificationViewController () {
    
    NotificationDetailView *view;
    NSString *text;
}

@end

@implementation DetailNotificationViewController


- (id)initWithText:(NSString*) content{

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"DetailNotificationViewController"];
    
    
    if (self) {
        text = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    view = (NotificationDetailView*) self.view;
    
    [view loadView:text];
    // Do any additional setup after loading the view.
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Notificação";
    [[UIApplication sharedApplication]  setApplicationIconBadgeNumber:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
