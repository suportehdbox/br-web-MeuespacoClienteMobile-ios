//
//  DocumentsGalleryView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "DocumentsGalleryView.h"
@implementation DocumentsCollectionCell
@synthesize imageCell;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
@implementation DocumentsGalleryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
    [_activity setHidden:YES];
    [_lblLoading setFont:[BaseView getDefatulFont:Micro bold:YES]];
    [_lblLoading setNumberOfLines:3];
    [_lblLoading setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblLoading setTextAlignment:NSTextAlignmentCenter];
    [_lblLoading setTextColor:[BaseView getColor:@"CinzaEscuro"]];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.frame));
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath image:(UIImage*)image{
    DocumentsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellImage" forIndexPath:indexPath];
    [cell.imageCell setImage:image];
    return cell;
}
-(void)updateScreen{
    [_collectionView reloadData];
}

-(void) startLoading:(NSString*)message{
    [_collectionView setHidden:YES];
    
    [_activity startAnimating];
    [_activity setHidden:NO];
    [_lblLoading setText:message];
    [_lblLoading setHidden:NO];
}

-(void) stopLoading{
    [_collectionView setHidden:NO];
    [_activity setHidden:YES];
    [_lblLoading setHidden:YES];
}

-(void) showNoDocumentsMessage{
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_lblLoading setText:NSLocalizedString(@"NenhumDocumento", @"")];
    [_lblLoading setNumberOfLines:0];
    [_lblLoading setHidden:NO];
}
@end
