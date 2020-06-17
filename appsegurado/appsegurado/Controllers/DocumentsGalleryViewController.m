//
//  DocumentsGalleryViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "DocumentsGalleryViewController.h"

@interface DocumentsGalleryViewController (){
    DocumentsGalleryView *view;
    NSMutableArray *arrayDocs;
    DocumentsModel *model;
    NSString *policyNum;

}

@end

@implementation DocumentsGalleryViewController
@synthesize delegate;
- (id)initWithPhotos:(NSMutableArray*) photos
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"DocumentsGallery"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    if (self) {
        arrayDocs = photos;
    }
    return self;
}

- (id)initWithDocuments:(NSString*)policyNumber
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self = [storyboard instantiateViewControllerWithIdentifier:@"DocumentsGallery"];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    if (self) {
        model = [[DocumentsModel alloc] init];
        policyNum = policyNumber;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setShowsContactButton:NO];
    view = (DocumentsGalleryView*) self.view;
    [view loadView];
    [view startLoading:NSLocalizedString(@"BuscandoDocumentos",@"")];
    [model setDocumentsDelegate:self];
    [model getPolicyDocuments:policyNum];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"DocumentosFotos",@"");
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [model setDocumentsDelegate:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrayDocs count];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [view collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(delegate){
        id displayed = [arrayDocs objectAtIndex:indexPath.row];
        if([displayed isKindOfClass:[UIImage class]]){
            if([delegate respondsToSelector:@selector(didSelectedImage:)]){
                [delegate didSelectedImage:displayed];
            }else{
                NSLog(@"Delegate not implemented didSelectedImage");
            }
        }else{
            if([delegate respondsToSelector:@selector(didSelectedDocument:)]){
                [delegate didSelectedDocument:displayed];
            }else{
                NSLog(@"Delegate not implemented didSelectedDocument");
            }
        }
    }else{
        NSLog(@"Delegate not defined");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    id displayed = [arrayDocs objectAtIndex:indexPath.row];
    
    if([displayed isKindOfClass:[UIImage class]]){
        return [view collectionView:collectionView cellForItemAtIndexPath:indexPath image:displayed];
    }else{
        return [view collectionView:collectionView cellForItemAtIndexPath:indexPath image: ((DocumentBeans* )displayed).image];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.title = @"";
}


#pragma mark - Docs Delegates
-(void) returnDownloadDocument:(DocumentBeans *)beans{
    
    if(beans != nil){
        int index = 0;
        for (DocumentBeans *beansArray in arrayDocs) {
            if([beans.idDocumento isEqualToString:beansArray.idDocumento]){
                [arrayDocs removeObjectAtIndex:index];
                break;
            }
            index++;
        }
        [arrayDocs insertObject:beans atIndex:index];
    }
    [self updateArrays];
    
    
}
-(void) returnDocuments:(NSMutableArray*)array{
    [view stopLoading];
//    if([array count] == 0){
//        return;
//    }
    arrayDocs = array;
    
    [self updateArrays];
    //    documents = [[DocumentsGalleryViewController alloc] initWithPhotos:arrayPhotos];
    //   [self.navigationController pushViewController:documents animated:YES ];
}

-(void) updateArrays{
    dispatch_async(dispatch_get_main_queue(), ^{
        [view updateScreen];
        if([arrayDocs count] <= 0){
            [view showNoDocumentsMessage];
        }
    });
    
}
-(void) documentsError:(NSString*)description closeScreen:(BOOL)shouldClose{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:description];
}




@end
