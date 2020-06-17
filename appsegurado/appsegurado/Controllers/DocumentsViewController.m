//
//  DocumentsViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "DocumentsViewController.h"
#import "DocumentsGalleryViewController.h"
#import "DocumentsView.h"
#import "PreviewViewController.h"


@interface DocumentsViewController () {
    DocumentsModel *model;
    ClaimModel *claimModel;
    DocumentsGalleryViewController *documents;
    NSString *policyNumber;
    NSMutableArray *arrayImages;
    DocumentsView *view;
    NSMutableArray *arrayDocs;
}

@end

@implementation DocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [[DocumentsModel alloc] init];
    claimModel = [[ClaimModel alloc] init];
    [model setDocumentsDelegate:self];
    [claimModel setDelegate:self];
//    [model setDelegate:self];
    [model getPolicyDocuments:policyNumber];
    view = (DocumentsView*) self.view;
    arrayDocs = [[NSMutableArray alloc] init];
    arrayImages = [[NSMutableArray alloc] init];
    [view loadView];
    [view startLoading:NSLocalizedString(@"BuscandoDocumentos", @"")];
    
    // Do any additional setup after loading the view.
}

-(void) setPolicyNumber:(NSString*) policy{
    policyNumber = policy;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.title =NSLocalizedString(@"DocumentosFotos", @"");
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"";
}



-(IBAction)uploadImages:(id)sender{
    if([arrayImages count] > 0){
        [view startLoading:NSLocalizedString(@"EnviandoSinistroArquivos", @"")];
//        [model sendAudioImages:arrayImages audio:@"" sinisterNumber:claimNumber];
        [self hideButtons:YES];
        [model  uploadDocument:policyNumber arrayDocuments:arrayImages];
    }else{
        [view showMessage:NSLocalizedString(@"AvisoUpload",@"") message:NSLocalizedString(@"UploadMinimoFotosDocuments",@"")];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void) imagesArrayUpdated:(NSMutableArray *)array{
    arrayImages = array;
    [self updateArrays];
    
}

-(void) openImagePicker:(UIImagePickerController*) controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    });
    
}

-(IBAction) openOptionsPhoto{
    
    if([arrayDocs count] + [arrayImages count] < 5){
        [self.navigationController presentViewController:[claimModel showOptionsCamera:nil] animated:YES completion:^{
            
        } ];
    }else{
        [view showMessage:NSLocalizedString(@"AvisoUpload",@"") message:NSLocalizedString(@"LimiteDocs",@"")];
    }
}

-(void)claimUploadSuccess:(NSString *)msg{
    
    [view stopLoading];
    if(msg != nil && ![msg isEqualToString:@""]){
        [view showMessage:NSLocalizedString(@"AvisoUpload", @"") message:msg];
    }else{
        [view showSuccessPopUp:@""];
    }
}

-(void)claimError:(NSString *)msg{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:msg];
}


-(IBAction)closeScreen:(id)sender{
    [view closeSuccessPopUp];
    //[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrayDocs count] + [arrayImages count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [view collectionView:collectionView cellForItemAtIndexPath:indexPath target:self action:@selector(touchCell:)];
    
}

-(IBAction)touchCell:(id)sender {
    

    UIButton *bt = sender;
    
    NSMutableArray *finalarray =  [[NSMutableArray alloc] initWithArray:arrayDocs];
    [finalarray addObjectsFromArray:arrayImages];
    
    if(bt.tag < [finalarray count]){
        id object = [finalarray objectAtIndex:bt.tag];
        UIImage *display = nil;
        if([object isKindOfClass:[UIImage class]]){
            display = object;
        }else{
            display = [(DocumentBeans*)object image];
        }
        PreviewViewController *previewImage = [[PreviewViewController alloc] initWithImage:display];
        [self.navigationController showViewController:previewImage sender:nil];
        
    }
    
    
}


-(void) previewImage:(UIImage *)img{
    
}

- (IBAction)requestHelp:(id)sender{
    [super showContactViewController];
}

-(IBAction)deletePictures:(id)sender{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TituloDeletarFoto",@"") message:@"" preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sim", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSNumber *index in [view getSelecteds]) {
            if([index intValue] < [arrayDocs count]){
                DocumentBeans *beans = [arrayDocs objectAtIndex:[index integerValue]];
                [tempArray addObject:beans.idDocumento];
            }else{
                int newIndex = [index intValue];
                if([arrayDocs count] > 0){
                    newIndex = (int) ([arrayDocs count] - [index intValue]);
                }
                [arrayImages removeObjectAtIndex:newIndex];
            }
        }
        if([tempArray count] > 0){
            [model deleteDocuments:tempArray forPolicy:policyNumber];
            [view startLoading:NSLocalizedString(@"DeletingFiles", @"")];

        }else{
            [self updateArrays];
        }
    }];

    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"Nao", "") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //do nothing
    }];

    [controller addAction:action];
    [controller addAction:actionNo];


    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
    
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
    NSMutableArray *finalarray =  [[NSMutableArray alloc] initWithArray:arrayDocs];
    [finalarray addObjectsFromArray:arrayImages];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view updateArrayImages:finalarray];
    });

}
-(void) documentsError:(NSString*)description closeScreen:(BOOL)shouldClose{
    [view stopLoading];
    [self hideButtons:NO];
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:description];
    [self updateArrays];
    if(shouldClose){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void) returnUploadDocuments:(BOOL) success{
    [arrayImages removeAllObjects];
    [arrayDocs removeAllObjects];
    [self hideButtons:NO];
    if(success){
        [view showSuccessPopUp:NSLocalizedString(@"ArquivosEnviados",@"")];
    }else{
        [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:NSLocalizedString(@"ArquivosErroUpload",@"")];
    }

    [model getPolicyDocuments:policyNumber];
}

-(void)deletedDocumentsSuccess{
    [arrayImages removeAllObjects];
    [arrayDocs removeAllObjects];
    [self hideButtons:NO];

    [view showSuccessPopUp:NSLocalizedString(@"ImagesDeleted", @"")];

    [view startLoading:@"Carregando"];
    [model getPolicyDocuments:policyNumber];
}




-(void) hideButtons:(BOOL) hide{
     [self.navigationItem setHidesBackButton:hide];
     if(hide){
         self.navigationItem.rightBarButtonItem = nil;
     }else{
         [super addContactButton];
     }
 
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
