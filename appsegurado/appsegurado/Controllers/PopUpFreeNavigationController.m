//
//  PopUpFreeNavigationController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 16/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "PopUpFreeNavigationController.h"
#import "PopUpFreeNavigationView.h"




@interface PopUpFreeNavigationController (){
    PopUpFreeNavigationView *view;

}

@end

@implementation PopUpFreeNavigationController
@synthesize delegate;

- (id)init;
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"PopUpFreeNavigation"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (PopUpFreeNavigationView*) self.view;
    [view loadView];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btOkAction:(id)sender{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setBool:[view.check isOn] forKey:@"DontDisplay"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if(delegate){
            [delegate finishedPopUp];
        }
    }];
}

-(BOOL) shouldDisplayPopUp{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    return ![defaults boolForKey:@"DontDisplay"];
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
