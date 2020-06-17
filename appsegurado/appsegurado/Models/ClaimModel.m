//
//  ClaimModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClaimModel.h"
#import "AppDelegate.h"
#import "ClaimBeans.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "InsuranceItensBeans.h"
#import "DocumentsGalleryViewController.h"
const int maxMBRequest = 10;

@interface ClaimModel(){
    NSMutableArray *arrayPictures;
    NSMutableArray *arrayDocuments;
    UIImagePickerController *imagePickerController;
    AppDelegate *appDelegate;
    NSMutableArray *arrayNewRequest;
    DocumentsGalleryViewController *controller;
    int indImage;
    int claimNumber;
}
@end
@implementation ClaimModel
@synthesize delegate;

-(void) getClainsStatus{

    appDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];

    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Sinistro/StatusSinistro",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    [conn addGetParameters:@"" key:@"a"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(parseClains:)];
    [conn startRequest];

}
-(void)parseClains:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result isKindOfClass:[NSDictionary class]]){
            
            if([result objectForKey:@"message"] != nil && ![[result objectForKey:@"message"] isEqualToString:@""]){
                if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
                    [delegate claimStatusError:[result objectForKey:@"message"]];
                }
            }else{
                @try {
                    NSMutableArray *arrayBeans = [[NSMutableArray alloc] init];
                    NSArray *claims = [result objectForKey:@"claims"];
                    for (NSDictionary *dic in claims) {
                        ClaimBeans *beans = [[ClaimBeans alloc] initWithClaimDictionary:dic];
                        [arrayBeans addObject:beans];
                    }
                    
                    if(delegate && [delegate respondsToSelector:@selector(claimStatusItens:)]){
                        [delegate claimStatusItens:arrayBeans];
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"Exception %@", exception.description);
                    if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
                        [delegate claimError:NSLocalizedString(@"ErroNoSerivdor",@"")];
                    }
                }
            }
            
        }
        
    }else{
        
        
        
        if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
            [delegate claimError:NSLocalizedString(@"ConnectionError",@"") ];
        }
        
        
    }
    
}

-(void) getPolicyItens:(NSDictionary *)dic {

    appDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Sinistro/Itens",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    if(dic == nil){
        [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@", [appDelegate getLoggeduser].access_token] field:@"Authorization"];
        NSString * Cpf = [[appDelegate getLoggeduser] cpfCnpj];
        if(Cpf != nil && ![Cpf isEqualToString:@""]){
            [conn addGetParameters:Cpf key:@"CpfCnpj"];
        }
        
    }else{
        [conn addGetParameters:[dic objectForKey:@"cpf"] key:@"CpfCnpj"];
        NSString *regex1 = @"^[0-9]*$";
        NSPredicate *test1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
        if([test1 evaluateWithObject:[dic objectForKey:@"platePolicy"]]){
            [conn addGetParameters:[dic objectForKey:@"platePolicy"]  key:@"Policy"];
        }else{
            [conn addGetParameters:[[dic objectForKey:@"platePolicy"] uppercaseString] key:@"LicensePlate"];
        }
        
    }
    [conn addGetParameters:brandMarketing key:@"brandMarketing"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [conn addGetParameters:version key:@"AppVersion"];
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(parseItens:)];
    [conn startRequest];

}
-(void)parseItens:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result isKindOfClass:[NSDictionary class]]){
            
            if([result objectForKey:@"message"] != nil && ![[result objectForKey:@"message"] isEqualToString:@""]){
                if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
                    [delegate claimError:[result objectForKey:@"message"]];
                }
            }else{
                @try {
                    NSMutableArray *arrayBeans = [[NSMutableArray alloc] init];
                    NSArray *insurances = [result objectForKey:@"insurances"];
                    for (NSDictionary *dic in insurances) {
                        InsuranceItensBeans *beans = [[InsuranceItensBeans alloc] initWithDictionary:dic];
                        if([beans isAutoPolicy]){
                            [arrayBeans addObject:[[InsuranceBeans alloc] initWithInsuranceIten:beans]];
                        }
                    }
                    
                    if(delegate && [delegate respondsToSelector:@selector(policyItens:)]){
                        [delegate policyItens:arrayBeans];
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"Exception %@", exception.description);
                    if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
                        [delegate claimError:NSLocalizedString(@"ErroNoSerivdor",@"")];
                    }
                }
            }
            
        }
        
    }else{
        
        
        
        if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
            [delegate claimError:NSLocalizedString(@"ConnectionError",@"") ];
        }
        
        
    }

}

-(void) sendClaim:(OpenClaimBeans*)beans cpf:(NSString*) cpf{

    appDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    
    
    if(cpf != nil && ![cpf isEqualToString:@""]){
        conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Sinistro/NovoSinistro",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
        [conn addPostParameters:cpf key:@"CpfCnpj"];
    }else{
        conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Sinistro/",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    }
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
 
    [conn addPostParameters:beans.policy key:@"Policy"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d",beans.claimType] key:@"ClaimType"];
    [conn addPostParameters:beans.licensePlate key:@"LicensePlate"];
    [conn addPostParameters:beans.claimDateTime key:@"ClaimDateTime"];
    if([beans.desc isEqualToString:@""]){
        beans.desc = NSLocalizedString(@"RelatoAudio",@"");
    }
    [conn addPostParameters:beans.desc key:@"Description"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d",beans.itemCode] key:@"ItemCode"];
    [conn addPostParameters:[NSString stringWithFormat:@"%ld",beans.contractCode] key:@"ContractCode"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d",beans.issueCode] key:@"IssueCode"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d",beans.ciaCode] key:@"CIACode"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d",beans.issuingAgency] key:@"IssuingAgency"];
    [conn addPostParameters:beans.userName key:@"UserName"];
    [conn addPostParameters:beans.userEmail key:@"UserEmail"];
    
    [conn addPostParameters:beans.userPhone key:@"UserPhone"];
    [conn addPostParameters:[NSString stringWithFormat:@"%@", (beans.userIsDriver ? @"true" : @"false")] key:@"UserIsDriver"];
    [conn addPostParameters:beans.addressLine1 key:@"AddressLine1"];
    [conn addPostParameters:@"" key:@"AddressLine2"];
    [conn addPostParameters:beans.number key:@"Number"];
    [conn addPostParameters:beans.addressSupport key:@"AddressSupport"];
    [conn addPostParameters:beans.cityBeans.city key:@"City"];
    [conn addPostParameters:[NSString stringWithFormat:@"%d", beans.cityBeans.cityCode] key:@"CityCode"];
    [conn addPostParameters:beans.state key:@"State"];
    [conn addPostParameters:beans.district key:@"District"];
    [conn addPostParameters:beans.driverName key:@"DriverName"];
    [conn addPostParameters:beans.driverBirthDate key:@"DriverBirthDate"];
    [conn addPostParameters:beans.driverPhone key:@"DriverPhone"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(parseClaim:)];
    [conn startRequest];
 
}

-(void)parseClaim:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
  
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    
    //{"message":null,"rowsAffected":0,"numeroAvisoSinistro":1627243,"sucesso":true}
    if(!error){
        if([result isKindOfClass:[NSDictionary class]] &&  [result objectForKey:@"message"] != nil && [result objectForKey:@"message"] != [NSNull null] && ![[result objectForKey:@"message"] isEqualToString:@""]){
            //
            if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
                [delegate claimError:[result objectForKey:@"message"]];
            }
            return;
        }else{
            indImage = 1;
            if(delegate && [delegate respondsToSelector:@selector(claimSent:)]){
                claimNumber = [[result objectForKey:@"numeroAvisoSinistro"] intValue];
                [delegate claimSent:claimNumber];
            }
        }
    }else{
        if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
            [delegate claimError:NSLocalizedString(@"ConnectionError",@"") ];
        }
    }
    
}


-(void)sendAudioImages:(NSArray*) arrayImages audio:(NSString*)audioPath sinisterNumber:(NSString*)number{
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Sinistro/Upload",[super getBaseUrl]] contentType:@"application/json"];
    long sizeRequest = 0;
    NSMutableArray *arrayFiles = [[NSMutableArray alloc] init];
    NSMutableArray *documentsSend = [[NSMutableArray alloc] init];
    audioPath = [audioPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    if([[NSFileManager defaultManager] fileExistsAtPath:audioPath])
    {
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:audioPath];
        sizeRequest += [data length];
        NSString *base64Audio = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: @1, @"TipoDocumento", @"Audio.mp4", @"Nome", base64Audio, @"Conteudo" , nil];
        [arrayFiles addObject:dic];
    }else{
        NSLog(@"File not exits");
    }
    
    
    for (UIImage *image  in arrayImages) {
        int indexDocument = [self indexImageDocument:image];
        if(indexDocument == -1){//Check if it is a document or a new upload
            NSData *data = UIImageJPEGRepresentation(image, 0.7);

            if((sizeRequest + [data length]) /1024.0f/ 1024.0f < maxMBRequest){
                sizeRequest += [data length];
                NSString *base64Audio = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                 NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: @2, @"TipoDocumento", [NSString stringWithFormat:@"Foto%d.jpg",indImage], @"Nome", base64Audio, @"Conteudo" , nil];
                indImage++;
                [arrayFiles addObject:dic];
            }else{
                if(arrayNewRequest == nil){
                    arrayNewRequest = [[NSMutableArray alloc] init];
                }
                [arrayNewRequest addObject:image];
            }
        }else{
            DocumentBeans *beans = [arrayDocuments objectAtIndex:indexDocument];
            [documentsSend addObject:beans.idDocumento];
        }
    }
    
    [conn addBodyParameters:arrayFiles key:@"Arquivos"];
    [conn addBodyParameters:documentsSend key:@"IdDocumentos"];
    [conn addBodyParameters:number key:@"NumeroSinistro"];
    

    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnUpload:)];
    [conn startRequest];
    
    
}

-(int) indexImageDocument:(UIImage *) image{
    if(arrayDocuments == nil || [arrayDocuments count] == 0){
        return -1;
    }
    int ind = 0;
    for (DocumentBeans *doc in arrayDocuments) {
        if(doc.image == image){
            
            return ind;
        }
        ind++;
    }
    return -1;
}

-(void)returnUpload:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);

    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    if(!error){
        if([result isKindOfClass:[NSDictionary class]] &&  [result objectForKey:@"message"] != nil && [result objectForKey:@"message"] != [NSNull null] && ![[result objectForKey:@"message"] isEqualToString:@""]){
            //
            if(delegate && [delegate respondsToSelector:@selector(claimUploadSuccess:)]){
                [delegate claimUploadSuccess:[result objectForKey:@"message"]];
            }
            return;
        }else{
            if(arrayNewRequest != nil && [arrayNewRequest count] > 0){
                [self sendAudioImages:[NSArray arrayWithArray:arrayNewRequest] audio:nil sinisterNumber:[NSString stringWithFormat:@"%d",claimNumber]];
                [arrayNewRequest removeAllObjects];
                arrayNewRequest = nil;
            }else{
                if(delegate && [delegate respondsToSelector:@selector(claimUploadSuccess:)]){
                    NSString *msg = [result objectForKey:@"message"] == [NSNull null] ? @"" : [result objectForKey:@"message"];
                    [delegate claimUploadSuccess:msg];
                }
            }
        }
    }else{
        if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
            [delegate claimError:NSLocalizedString(@"ConnectionError",@"") ];
        }
    }

}

-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(delegate && [delegate respondsToSelector:@selector(claimError:)]){
        [delegate claimError:NSLocalizedString(@"ConnectionError",@"") ];
    }
}




-(UIAlertController*) showOptionsCamera:(NSString*) policyNumber{
    appDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    UIAlertController * controllerAction = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TituloEscolherFoto",@"") message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionDocs = [UIAlertAction actionWithTitle:NSLocalizedString(@"DocumentosSalvos", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openDocuments:policyNumber];
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Galeria", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openGalery];
    }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self openCameraPicker];
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancelar", "") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //do nothing just close
    }];
    if([appDelegate isUserLogged] && policyNumber != nil){
        [controllerAction addAction:actionDocs];
    }
    [controllerAction addAction:action];
    [controllerAction addAction:actionNo];
    [controllerAction addAction:actionCancel];
    
    
    return controllerAction;
}


-(void) openCameraPicker{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [delegate openImagePicker:[self getCameraPicker]];
    } else if(authStatus == AVAuthorizationStatusDenied){
       [delegate claimError:NSLocalizedString(@"PermissaoCamera",@"")];
    } else if(authStatus == AVAuthorizationStatusRestricted){
       [delegate claimError:NSLocalizedString(@"PermissaoCamera", @"")];
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                [delegate openImagePicker:[self getCameraPicker]];
            }
        }];
    } else {
        [delegate claimError:NSLocalizedString(@"PermissaoCamera",@"")];
    }
//    "PermissaoCamera" = "Para adicionar uma foto é preciso permitir o acesso a câmera e a galeria de fotos";
//    "PermissoMicrofone" = "Para gravar um audio é preciso permitir o acesso ao microfone";
}

-(void) openGalery{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized)
    {
        [delegate openImagePicker:[self getGalleryPicker]];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){
               [delegate openImagePicker:[self getGalleryPicker]];
            }else{
                [delegate claimError:NSLocalizedString(@"PermissaoCamera",@"")];
            }
        }];
    }
}

-(void) openDocuments:(NSString*) policy{
//    if(controller == nil){
        controller = [[DocumentsGalleryViewController alloc] initWithDocuments:policy];
        [controller setDelegate:self];
//    }
    
    [delegate openDocumentsPicker:controller];

}

-(void) confiPicker{
    if(imagePickerController == nil){
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
    }
}

-(UIImagePickerController *) getCameraPicker{
    [self confiPicker];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    return imagePickerController;
}

-(UIImagePickerController *) getGalleryPicker{
    [self confiPicker];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    return imagePickerController;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if(arrayPictures == nil){
        arrayPictures = [[NSMutableArray alloc] init];
    }
    [arrayPictures addObject:chosenImage];
    [delegate imagesArrayUpdated:arrayPictures];
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}
-(void) removePhotoAtIndex:(int) index{
    int indexDoc = [self indexImageDocument:[arrayPictures objectAtIndex:index]];
    if(indexDoc >= 0){
        [arrayDocuments removeObjectAtIndex:indexDoc];
    }
    [arrayPictures removeObjectAtIndex:index];
    [delegate imagesArrayUpdated:arrayPictures];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];    
}


-(void)didSelectedDocument:(DocumentBeans *)beans{
    if(arrayPictures == nil){
        arrayPictures = [[NSMutableArray alloc] init];
    }
    if(arrayDocuments == nil){
        arrayDocuments = [[NSMutableArray alloc] init];
    }
    
    [arrayPictures addObject:beans.image];
    [arrayDocuments addObject:beans];
    [delegate imagesArrayUpdated:arrayPictures];

    
}
@end
