//
//  UploadPicturesViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 19/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "UploadPicturesViewController.h"

#import "AppDelegate.h"
@interface UploadPicturesViewController (){
    UploadPicturesView *view;
    ClaimModel *model;
    AppDelegate *appDelegate;
    NSMutableArray *arrayImages;
    NSString *claimNumber;
    NSString *policyNumber;
}

@end

@implementation UploadPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    view = (UploadPicturesView*) self.view;
    [view loadView];
    model = [[ClaimModel alloc] init];
    [model setDelegate:self];
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [self setAnalyticsTitle:@"Upload Foto Sinisitro Em Aberto"];
    [super addContactButton];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"Sinistro", @"");
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"";
}

-(void) setClaimNumber:(NSString*) number policyNumber:(NSString*) policy{
    claimNumber = number;
    policyNumber = policy;
}

-(IBAction)uploadImages:(id)sender{
    if([arrayImages count] > 0){
        [view startLoading:NSLocalizedString(@"EnviandoSinistroArquivos", @"")];
        [model sendAudioImages:arrayImages audio:@"" sinisterNumber:claimNumber];
    }else{
         [view showMessage:NSLocalizedString(@"AvisoUpload",@"") message:NSLocalizedString(@"UploadMinimoFotos",@"")];
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
    [view updateArrayImages:arrayImages];
    
}

-(void) openImagePicker:(UIImagePickerController*) controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    });
    
}
-(void) openDocumentsPicker:(UIViewController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:controller animated:YES];
    });
}

-(IBAction) openOptionsPhoto{
    
    if([arrayImages count]< 8){
        [self.navigationController presentViewController:[model showOptionsCamera:policyNumber] animated:YES completion:^{
            
        } ];
    }else{
        [view showMessage:NSLocalizedString(@"AvisoUpload",@"") message:NSLocalizedString(@"LimiteFotos",@"")];
    }
}

-(void)claimUploadSuccess:(NSString *)msg{

    [view stopLoading];
    if(msg != nil && ![msg isEqualToString:@""]){
        [view showMessage:NSLocalizedString(@"AvisoUpload", @"") message:msg];
    }else{
        [view showSuccessPopUp:claimNumber];
    }
}

-(void)claimError:(NSString *)msg{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle", @"") message:msg];
}


-(IBAction)closeScreen:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrayImages count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [view collectionView:collectionView cellForItemAtIndexPath:indexPath delegate:self];
    
}

-(void) photoSelected:(NSIndexPath*)indexpath{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TituloDeletarFoto",@"") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sim", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [model removePhotoAtIndex:indexpath.row];
    }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"Nao", "") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //do nothing
    }];
    
    [controller addAction:action];
    [controller addAction:actionNo];
    
    
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self photoSelected:indexPath];
}
- (IBAction)requestHelp:(id)sender{
    [super showContactViewController];
}

@end
