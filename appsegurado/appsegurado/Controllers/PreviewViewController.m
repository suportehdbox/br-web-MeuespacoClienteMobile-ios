//
//  PreviewViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 09/10/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController (){
    UIImage *currentImage;
    PreviewView *view;
}

@end

@implementation PreviewViewController

- (id)initWithImage:(UIImage *) img
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"PreviewViewController"];
    if (self) {
        [self setDisplayImage:img];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (PreviewView *) self.view;
    [view configureScrollView:self image:currentImage];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title =NSLocalizedString(@"DocumentosFotos", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setDisplayImage:(UIImage*)img{
    currentImage = img;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return view.imageView;
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
