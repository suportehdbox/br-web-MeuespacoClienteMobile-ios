//
//  ActivationViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/08/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "ActivationViewController.h"

@interface ActivationViewController (){
    LoginModel *model;
}

@end

@implementation ActivationViewController

- (id)initWithDictionary:(NSDictionary*) content{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"ActivationViewController"];
    
    
    if (self) {
        model = [[LoginModel alloc] init];
        [model setDelegate:self];
        [model sendActivation:content];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)activationReturn:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"AvisoProrrogar", @"") message:[message stringByReplacingOccurrencesOfString:@"\\\\n" withString:@"\n"] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //do nothing
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
