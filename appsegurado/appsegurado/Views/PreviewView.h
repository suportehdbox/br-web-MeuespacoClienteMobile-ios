//
//  PreviewView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 09/10/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface PreviewView : BaseView

@property(nonatomic,strong) IBOutlet UIImageView *imageView;
@property(nonatomic,strong) IBOutlet UIScrollView *scrollView;

-(void) configureScrollView:(id<UIScrollViewDelegate>) delegate image:(UIImage*) image;
@end
