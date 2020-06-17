//
//  Open24AssistViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 11/10/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "Open24AssistViewController.h"
#import "AppDelegate.h"
#import "ClaimModel.h"
#import "CustomWebViewController.h"
@interface Open24AssistViewController (){
    CustomWebViewController * customWebView;
    NSString *newPlate;
}

@end

@implementation Open24AssistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setPlate:(NSString*)plate{
    newPlate = plate;
//    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
//    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
//
//    NSString *cpf = [appDelegate getCPF];
//    while([cpf length] < 11){
//        cpf = [NSString stringWithFormat:@"0%@",cpf];
//    }
//    //02913865432
//    //001.123.456-78
//    [defaults setValue:cpf forKey:@"DirectAssistCPF"];
//    [defaults setValue:plate forKey:@"DirectAssistPlate"];
//    [defaults setValue:@"" forKey:@"DirectAssistChassi"];
//    //            [defaults setValue:@"9BWAA05UBAT169833" forKey:@"DirectAssistChassi"];
//    [defaults synchronize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)openNewAsssit:(id)sender{
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DirectAssist" bundle:[NSBundle bundleForClass:[CallHelpViewController class]]];
//    CallHelpViewController *directAssist = (CallHelpViewController*) [sb instantiateViewControllerWithIdentifier:@"CallHelpViewController"];
//    [self.navigationController pushViewController:directAssist animated:YES ];
    
    
    ClaimModel *claimModel = [[ClaimModel alloc] init];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?plate=%@",[claimModel getFacilAssist], newPlate]];
    customWebView = [[CustomWebViewController alloc] initWithAssistWithRequest:[NSURLRequest requestWithURL:url]];
    
    [self.navigationController pushViewController:customWebView animated:YES];
    
}


-(IBAction)followAssist:(id)sender{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DirectAssist" bundle:[NSBundle bundleForClass:[MyCasesViewController class]]];
//    MyCasesViewController *directAssist = (MyCasesViewController*) [sb instantiateViewControllerWithIdentifier:@"MyCasesViewController"];
//    [self.navigationController pushViewController:directAssist animated:YES ];
    
}
@end

