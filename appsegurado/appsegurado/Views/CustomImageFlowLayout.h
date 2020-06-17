//
//  CustomImageFlowLayout.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageFlowLayout : UICollectionViewFlowLayout
- (id)initWithNumberOfColumns:(int)columns;
- (CGSize)itemSize;
@end
