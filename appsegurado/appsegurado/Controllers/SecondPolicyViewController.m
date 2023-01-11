//
//  SecondPolicyViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/09/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "SecondPolicyViewController.h"
#import "SecondPolicyView.h"
#import "AppDelegate.h"



@interface SecondPolicyViewController () {
    
    NSString *currentPolicyNumber;
    SearchType currentType;
    SecondPolicyView *view;
    PolicyModel *model;
    BOOL shouldShare;
    id<SecondPolicyDelegate> delegate;
    
    
}

@end

@implementation SecondPolicyViewController

- (id)initPolicy:(PolicyBeans*)policy delegate:(id<SecondPolicyDelegate>) customDelegate;
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"SecondPolicyViewController"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    if (self) {
        currentType = SearchTypeCurrents;
        
        
        
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *dataEndPolicyDate = [dateformat dateFromString:policy.insurance.dataEndPolicy];
        NSDate *dataStartPolicyDate = [dateformat dateFromString:policy.insurance.dataStartPolicy];
        
        NSComparisonResult resultEnd = [[NSDate date] compare:dataEndPolicyDate];
        NSComparisonResult resultStart = [[NSDate date] compare:dataStartPolicyDate];
        
        if(resultEnd==NSOrderedAscending){
            NSLog(@"dataEndPolicyDate is in the future");
            if(resultStart==NSOrderedAscending){
                NSLog(@"dataStartPolicyDate is in the future");
                //FUTURE Policy
                currentType = SearchTypeNexts;
             }else{
                currentType = SearchTypeCurrents;
             }
        }else if(resultEnd==NSOrderedDescending){
            NSLog(@"dataEndPolicyDate is in the past");
            currentType = SearchTypeOlds;
        }else{
            NSLog(@"Both dates are the same");
            currentType = SearchTypeCurrents;
        }
        
        
        currentPolicyNumber = policy.insurance.policy;
        delegate = customDelegate;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (SecondPolicyView*) self.view;
    [view loadView];
    [view stopLoading];
    model = [[PolicyModel alloc] init];
    [model setDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btCancelClicled:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btShare:(id)sender {
    [view showLoading];
    shouldShare = true;
    [model getSecondPolicyPDF:currentPolicyNumber type:currentType];
    
    return;
    
}

- (IBAction)btDownload:(id)sender {
    [view showLoading];
    shouldShare = false;
    [model getSecondPolicyPDF:currentPolicyNumber type:currentType];
    
    return;
    
}

-(void)pdfDownloaded:(NSString *)path{
    [view stopLoading];
    if(shouldShare){
        [self share:path];
    }else{
        [self openDocument:path];
    }
    
}
-(void) share:(NSString*) path{
    NSURL *urlfile = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",path]];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:urlfile, nil] applicationActivities:nil];
    [self presentViewController:activity animated:YES completion:nil];
}

- (void)openDocument:(NSString *)path {
    NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",path]];
    
    [delegate loadPDFViewController:[[CustomWebViewController alloc] initWithLocalFileRequest:[NSURLRequest requestWithURL:fileURL]]];
}


-(void)pdfError:(NSString *)message{
    [view showMessage:NSLocalizedString(@"Erro", @"") message:message];
    [view stopLoading];
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
