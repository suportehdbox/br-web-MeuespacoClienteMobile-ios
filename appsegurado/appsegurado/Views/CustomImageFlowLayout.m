//
//  CustomImageFlowLayout.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "CustomImageFlowLayout.h"
@interface CustomImageFlowLayout (){
    int numberOfColumns;

}
@end
@implementation CustomImageFlowLayout

- (id)initWithNumberOfColumns:(int)columns
{
    self = [super init];
    if (self)
    {
        numberOfColumns = columns;
        self.minimumLineSpacing = 1.0;
        self.minimumInteritemSpacing = 1.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (CGSize)itemSize
{

    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - (numberOfColumns - 1)) / numberOfColumns;
    return CGSizeMake(itemWidth, itemWidth);
}

@end
