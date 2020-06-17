//
//  ClaimViewController.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClaimViewController.h"
#import "ClaimStep1View.h"
#import "ClaimStep2View.h"
#import "ClaimStep3View.h"

#import <AudioToolbox/AudioServices.h>
#import "AppDelegate.h"
#import "AccidentViewController.h"

@interface ClaimViewController () {
    ClaimStep1View *view1;
    ClaimStep2View *view2;
    ClaimStep3View *view3;
    ClaimStep4View *view4;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *backgroundMusicPlayer;
    int indexScreen;
    NSMutableArray *arrayImages;
    ClaimModel *model;
    OpenClaimBeans *beans;
    InsuranceBeans *insurance;
    CitiesViewController *cityController;
    int sentClaimNumber;
    NSString* currentCpf;
    NSTimer *timerAudio;
    AppDelegate* appDelegate;
    int sumTimer;
}

@end

@implementation ClaimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if (beans == nil) {
        beans = [[OpenClaimBeans alloc] init];
        beans.policy = insurance.policy;
        beans.licensePlate = insurance.licensePlate;
        beans.ciaCode = insurance.ciaCode;
        beans.contractCode = insurance.contract;
        beans.itemCode = [(ItemInsurance *)[insurance.itens objectAtIndex:0] code];
        beans.issuingAgency = insurance.issuingAgency;
        beans.issueCode = [(NSNumber*) [insurance.issuances  objectAtIndex:0] intValue];
        
    }
    model = [[ClaimModel alloc] init];
    [model setDelegate:self];
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [self setAnalyticsTitle:@"Lista de Apólices - Sinistro"];
    
    [self controllScreen];
     


}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"Sinistro",@"");
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    switch (indexScreen) {
        case 1:
            [view2 registerForKeyboardNotifications];
            break;
        case 2:
            [view3 registerForKeyboardNotifications];
            break;
        default:
            break;
    }

}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self checkRecording];
    self.title = @"";
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    switch (indexScreen) {
        case 0:
            [view1 unloadView];
            break;
        case 1:
            [view2 unloadView];
            break;
        case 2:
            [view3 unloadView];
            break;
        case 3:
            [view4 unloadView];
            break;
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    if(model != nil){
        [model setDelegate:nil];
        model = nil;
    }
}
-(void) setIndexScreen:(int) index beans:(OpenClaimBeans*) claimBeans{
    indexScreen = index;
    beans = claimBeans;
}

-(void) setInsurance: (InsuranceBeans*) insBeans cpf:(NSString*)cpf{
    insurance = insBeans;
    currentCpf = cpf;
}
-(void) controllScreen{
    
    switch (indexScreen) {
        case 0:
            if(view1 == nil){
                view1 = (ClaimStep1View *) self.view;
            }
            [view1 loadView];
            break;
        case 1:
            if(view2 == nil){
                view2 = (ClaimStep2View *) self.view;
            }
            if([appDelegate isUserLogged]){
                [view2 loadView:[appDelegate getLoggeduser]];
            }else{
                [view2 loadView:nil];
            }
            
            break;
        case 2:
            if(view3 == nil){
                view3 = (ClaimStep3View *) self.view;
            }
            [view3 loadView];
            break;
        case 3:
            if(view4 == nil){
                view4 = (ClaimStep4View *) self.view;
                arrayImages = [[NSMutableArray alloc] init];
            }
            
            [view4 loadView];
            break;
        default:
            break;
    }
    
}
-(BOOL) updateBeans{
    
    switch (indexScreen) {
        case 0:
            if([view1 getSelectedClaim] == -1){
                [view1 showMessage:NSLocalizedString(@"AvisoUpload", @"") message:NSLocalizedString(@"ErroTipoSinistro",@"")];
                return false;
            }
            [beans setClaimType:[view1 getSelectedClaim]];
            break;
        case 1:{
            BOOL returnOk = true;
            
            if([[view2 getName] isEqualToString:@""]){
                [view2 showNameError:NSLocalizedString(@"NomeVazio",@"")];
                returnOk = false;
            }
            if([[view2 getEmail] isEqualToString:@""]){
                [view2 showEmailError:NSLocalizedString(@"EmailVazioEsqueceuSenha",@"")];
                returnOk = false;
            }
            if(![model isValidEmail:[view2 getEmail]]){
                [view2 showEmailError:NSLocalizedString(@"EmailInvalido",@"")];
                returnOk = false;
            }
            if([[view2 getPhone] isEqualToString:@""]){
                [view2 showPhoneError:NSLocalizedString(@"FoneVazio",@"")];
                returnOk = false;
            }
            if([[view2 getPhone] isEqualToString:@""]){
                [view2 showPhoneError:NSLocalizedString(@"FoneVazio",@"")];
                returnOk = false;
            }
            if([[view2 getPhone] length] < 10){
                [view2 showPhoneError:NSLocalizedString(@"FoneInvalido",@"")];
                returnOk = false;
            }
            if([view2 getDriver] == -1){
               [view2 showMessage:NSLocalizedString(@"AvisoUpload", @"") message:NSLocalizedString(@"SeguradoEraCondutor",@"")];
                returnOk = false;
            }
            if([view2 getDriver] == 0){
                if([[view2 getDriverName] isEqualToString:@""]){
                    [view2 showDriverNameError:NSLocalizedString(@"NomeMotoristaVazio",@"")];
                    returnOk = false;
                }
                if([[view2 getDriverBirthDate] isEqualToString:@""]){
                    [view2 showDriverBirthdateError:NSLocalizedString(@"DataMotoristaVazio",@"")];
                    returnOk = false;
                }
                if([[view2 getDriverBirthDate] isEqualToString:@""]){
                    [view2 showDriverBirthdateError:NSLocalizedString(@"DataMotoristaVazio",@"")];
                    returnOk = false;
                }
                
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
//                NSDate * dateFromString = [dateFormatter dateFromString:[view2 getDriverBirthDate]];
//                if(dateFromString == nil){
//                    [view2 showDriverBirthdateError:NSLocalizedString(@"DataInvalida",@"")];
//                    returnOk = false;
//                }
                
                if([[view2 getDriverPhone] isEqualToString:@""]){
                    [view2 showDriverPhoneError:NSLocalizedString(@"FoneMotoristaVazio",@"")];
                    returnOk = false;
                }
            }
            if(!returnOk){
                return false;
            }
            [beans setUserName:[view2 getName]];
            [beans setUserEmail:[view2 getEmail]];
            [beans setUserPhone:[view2 getPhone]];
            [beans setUserIsDriver:[view2 getDriver]];
            [beans setDriverName:[view2 getDriverName]];
            [beans setDriverPhone:[view2 getDriverPhone]];
            [beans setDriverBirthDate:[view2 getDriverBirthDate]];
            break;
        }
        case 2:{
            //yyyy-MM-dd hh:mm
            BOOL returnOk = true;
            
            if([[view3 getDate] isEqualToString:@""]){
                [view3 showDateError:NSLocalizedString(@"DataVazia",@"")];
                returnOk =  false;
            }
            if([[view3 getTime] isEqualToString:@""]){
                [view3 showTimeError:NSLocalizedString(@"HoraVazio",@"")];
                returnOk =  false;
            }
            if([[view3 getAddress] isEqualToString:@""]){
                [view3 showAddressError:NSLocalizedString(@"EnderecoVazio",@"")];
                returnOk =  false;
            }
            if([[view3 getNumber] isEqualToString:@""]){
                [view3 showNumberError:NSLocalizedString(@"NumeroVazio",@"")];
                returnOk =  false;
            }

//            if([[view3 getReference] isEqualToString:@""]){
//                [view3 showReferenceError:NSLocalizedString(@"ReferenciaVazio",@"")];
//                returnOk =  false;
//            }
            if([[view3 getCity] isEqualToString:@""]){
                [view3 showCityError:NSLocalizedString(@"CidadeVazio",@"")];
                returnOk =  false;
            }
            if([[view3 getNeighborhood] isEqualToString:@""]){
                [view3 showNeighborhoodError:NSLocalizedString(@"BairroVazio",@"")];
                returnOk =  false;
            }
            if([[view3 getState] isEqualToString:@""]){
                [view3 showStateError:NSLocalizedString(@"EstadoVazio",@"")];
                returnOk =  false;
            }
            if(!returnOk){
                return false;
            }
            
            [beans setClaimDateTime:[view3 getDateTime]];
            [beans setAddressLine1:[view3 getAddress]];
            [beans setAddressSupport:[view3 getReference]];
            [beans setCity:[view3 getCity]];
            [beans setNumber:[view3 getNumber]];
            [beans setDistrict:[view3 getNeighborhood]];
            [beans setState:[view3 getState]];
            
            break;
        }
        case 3:
            if([[view4 getDesc] isEqualToString:@""] &&  backgroundMusicPlayer == nil){
                [view4 showMessage:NSLocalizedString(@"AvisoUpload", @"") message:NSLocalizedString(@"AvisoSemDescrição",@"")];
                return false;
            }
            [beans setDesc:[view4 getDesc]];
            break;
        case 4:
            
            break;
        default:
            break;
    }
    return true;
}



//-(IBAction)longPressRecording:(id)sender{
//    NSString *mediaType = AVMediaTypeAudio;
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//    if(authStatus == AVAuthorizationStatusAuthorized) {
//        [self startCaptureAudio];
//    } else if(authStatus == AVAuthorizationStatusDenied){
//        [self claimError:NSLocalizedString(@"PermissaoAudio",@"")];
//    } else if(authStatus == AVAuthorizationStatusRestricted){
//        [self claimError:NSLocalizedString(@"PermissaoAudio", @"")];
//    } else if(authStatus == AVAuthorizationStatusNotDetermined){
//        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
//            if(granted){
//                [self startCaptureAudio];
//            }
//        }];
//    } else {
//        [self claimError:NSLocalizedString(@"PermissaoAudio",@"")];
//    }
//
//    
//}
-(void) startCaptureAudio{
    if(backgroundMusicPlayer == nil){
        [view4 changeButtonRecording];
        
        NSError *sessionError = nil;
        //    [[AVAudioSession sharedInstance] setDelegate:self];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        // Set the audioSession override
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        //    UInt32 doChangeDefaultRoute = 1;
        //    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
        
        NSError *error = nil;
        
        NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                        [NSNumber numberWithInt:AVAudioQualityMedium],AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:AVAudioQualityMedium], AVSampleRateConverterAudioQualityKey,
                                        [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:22050.0],AVSampleRateKey,
                                        nil];
        
        audioRecorder = [[AVAudioRecorder alloc]
                         initWithURL:[self getAudioFilePath]
                         settings:recordSettings
                         error:&error];
        sumTimer = 1;
        timerAudio = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopRecording) userInfo:nil repeats:YES];
        
        
        if (!error && [audioRecorder prepareToRecord])
        {
//            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [audioRecorder record];
        }
    }
}
-(NSURL*) getAudioFilePath{
    NSString * FILENAME = @"audioSinistro";
    
    NSString *filename = [NSString stringWithFormat:@"%@.mp4",FILENAME];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:filename];
    return [NSURL fileURLWithPath:path];

}

-(void) stopRecording{
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if(sumTimer < 180){
        [view4 updateLblTimer:sumTimer];
    }else{
        [view4 showMessage:NSLocalizedString(@"AvisoUpload",@"") message:NSLocalizedString(@"LimiteGravacao",@"")];
        [self touchUpRecording:nil];
    }
    sumTimer++;
}
-(IBAction)touchUpRecording:(id)sender{
    
    if(backgroundMusicPlayer != nil){
        if(![backgroundMusicPlayer isPlaying]){
            [backgroundMusicPlayer prepareToPlay];
            [backgroundMusicPlayer play];
            [view4 changeButtonPause];
        }else{
            [backgroundMusicPlayer stop];
            [view4 changeButtonPlay];
        }
    }else if(audioRecorder == nil || ![audioRecorder isRecording]){
        NSString *mediaType = AVMediaTypeAudio;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            [self startCaptureAudio];
        } else if(authStatus == AVAuthorizationStatusDenied){
            [self claimError:NSLocalizedString(@"PermissaoAudio",@"")];
        } else if(authStatus == AVAuthorizationStatusRestricted){
            [self claimError:NSLocalizedString(@"PermissaoAudio", @"")];
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){
                    [self startCaptureAudio];
                }
            }];
        } else {
            [self claimError:NSLocalizedString(@"PermissaoAudio",@"")];
        }

    }else if(backgroundMusicPlayer == nil){
            [timerAudio invalidate];
            
            timerAudio = nil;
            
            [view4 changeButtonPlay];
            [audioRecorder stop];
        
            NSError *error;
            backgroundMusicPlayer = [[AVAudioPlayer alloc]
                                     initWithContentsOfURL:[self getAudioFilePath] error:&error];
            [backgroundMusicPlayer setVolume:1.0];
            [backgroundMusicPlayer setDelegate:self];
        

    }
    
}
-(void) checkRecording{
    if(audioRecorder != nil && [audioRecorder isRecording] && backgroundMusicPlayer == nil){
        [self touchUpRecording:nil];
    }else if(backgroundMusicPlayer != nil){
        [backgroundMusicPlayer stop];
        [view4 changeButtonPlay];
    }
}

-(IBAction) showCities{
    if([[view3 getState] isEqualToString:@""]){
        [view3 showStateError:NSLocalizedString(@"EstadoVazio",@"")];
        return;
    }
    [view3 tapView:nil];
    
    [self performSegueWithIdentifier:@"OpenCities" sender:self];
}

- (IBAction)gotoNextScreen:(id)sender {
    if(![self updateBeans]){
        return;
    }
    if(indexScreen < 3){
        [self performSegueWithIdentifier:@"GotoNextStep" sender:nil];
    }else{
        [self checkRecording];
        [self hideButtons:YES];
        [view4 startLoading:NSLocalizedString(@"EnviandoSinistro", @"")];
        [model sendClaim:beans cpf:currentCpf];
    }
    
}

- (IBAction)deleteAudio:(id)sender {
    
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TituloDeletarAudio",@"") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sim", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:[self getAudioFilePath] error:&error];
        backgroundMusicPlayer = nil;
        audioRecorder = nil;
        [view4 changeButtonRecord];
    }];
    
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"Nao", "") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //do nothing
    }];
    
    [controller addAction:action];
    [controller addAction:actionNo];
    
    
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
}


-(IBAction) openOptionsPhoto{
    [self checkRecording];
    if([arrayImages count]< 8){
        [self.navigationController presentViewController:[model showOptionsCamera:insurance.policy] animated:YES completion:^{
            
        } ];
    }else{
        [view4 showMessage:NSLocalizedString(@"AvisoUpload",@"") message:NSLocalizedString(@"LimiteFotos",@"")];
    }
}
- (IBAction)toolTip:(id)sender {
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"TituloAjudaSinistro",@"") message:NSLocalizedString(@"TextoAjudaSinistro",@"") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"BtPopUpSucesso", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

-(IBAction) openContacts{
    [super showContactViewController];
}

-(IBAction) finishedClaim{
    UIViewController *popView;
    for (UIViewController *controller in  self.navigationController.viewControllers) {
        if([controller isKindOfClass:[AccidentViewController class]]){
            popView = controller;
            break;
        }
    }
    [self.navigationController popToViewController:popView animated:YES];
}

-(void) showPopUpSuccess{
    [self hideButtons:NO];
    [view4 showSuccessPopUp:[NSString stringWithFormat:@"%d",sentClaimNumber]];
}

#pragma mark - Audio Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [view4 changeButtonPlay];
}

-(void) openImagePicker:(UIImagePickerController*) controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    });

}
-(void)openDocumentsPicker:(UIViewController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:controller animated:YES];
    });
}
-(void) imagesArrayUpdated:(NSMutableArray *)array{
    arrayImages = array;
    [view4 updateArrayImages:arrayImages];

}
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     self.title = @"";
     if([segue.identifier isEqualToString:@"GotoNextStep"]){
         ClaimViewController *dest = (ClaimViewController*) segue.destinationViewController;
         [dest setIndexScreen:(indexScreen+1) beans:beans];
         [dest setInsurance:insurance cpf:currentCpf];
         
         
         
     }else if([segue.identifier isEqualToString:@"OpenCities"]){
         cityController = (CitiesViewController*) segue.destinationViewController;
         [cityController setState:[view3 getState]];
         [cityController setDelegate:self];
    
     }
 
 }

#pragma mark - UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrayImages count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [view4 collectionView:collectionView cellForItemAtIndexPath:indexPath delegate:self];
    
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


#pragma mark - CityDelegate

-(void)citySelected:(CityBeans *)city{
    [beans setCityBeans:city];
    [view3 updateCity:city.city];
}

#pragma mark - Model Delegate


-(void)claimSent:(int)claimNumber{
    if(claimNumber > 0){
        sentClaimNumber = claimNumber;
        [view4 startLoading:NSLocalizedString(@"EnviandoSinistroArquivos", @"")];
        if(backgroundMusicPlayer != nil || [arrayImages count] > 0){
            [model sendAudioImages:arrayImages audio:[[self getAudioFilePath] absoluteString] sinisterNumber:[NSString stringWithFormat:@"%d",claimNumber]];
            
        }else{
            [self showPopUpSuccess];
        }
    }
}
-(void)claimUploadSuccess:(NSString *)msg{
    [self showPopUpSuccess];
    if(msg != nil && ![msg isEqualToString:@""]){
        [view4 showMessage:NSLocalizedString(@"AvisoUpload", @"") message:msg];
    }
    
}

-(void)claimError:(NSString *)msg{
    [view4 stopLoading];
    [view4 showMessage:NSLocalizedString(@"ErrorTitle", @"") message:msg];
    [self hideButtons:NO];
}

-(void) hideButtons:(BOOL) hide{
    [self.navigationItem setHidesBackButton:hide];
    if(hide){
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        [super addContactButton];
    }

}

@end
