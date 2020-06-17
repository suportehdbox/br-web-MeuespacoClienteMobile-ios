//
//  PoliticsViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "PoliticsViewController.h"
#import "PoliticsView.h"
@interface PoliticsViewController ()
{

    PoliticsView *view;
}

@end

@implementation PoliticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (PoliticsView*) self.view;
    [view loadView];
    self.title = NSLocalizedString(@"PoliticaPrivacidadeTitulo", @"");
    [view loadText:NSLocalizedString(@"PoliticaPrivacidade", @"")];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"PoliticaPrivacidadeTitulo", @"");
}

-(void) viewWillDisappear:(BOOL)animated{
    self.title = @"";
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
