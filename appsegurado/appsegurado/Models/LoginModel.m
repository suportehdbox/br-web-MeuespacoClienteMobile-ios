//
//  LoginModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 27/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "LoginModel.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "DeviceUtil.h"

@interface LoginModel (){
    BOOL stayLogged;
    int typeLogin; // 0 = TOKEN | 1 = Login/Senha | 2 = Facebook
    FBUserBeans *currentFBUser;
    FBSDKLoginManager *fbLogin;
    NSString *email;
    NSString *idDevice;
    BOOL linkingGoogle;
    NSString *hardwareDescription;
    
}
@end

@implementation LoginModel

@synthesize delegate;
- (id)init
{
    self = [super init];
    if (self) {
        DeviceUtil *deviceUtil = [[DeviceUtil alloc] init];
        hardwareDescription = [deviceUtil hardwareDescription];
        idDevice = @"";
        if([[UIDevice currentDevice] identifierForVendor] != nil){
            idDevice = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
         fbLogin = [[FBSDKLoginManager alloc] init];
        
        
        [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
        [[GIDSignIn sharedInstance] signOut];
        [GIDSignIn sharedInstance].delegate = self;
        NSLog(@"Client id %@", [GIDSignIn sharedInstance].clientID);
    }
    return self;
}

-(void) doLogin:(NSString*) emailCpf password:(NSString*)password stayLogged:(BOOL)logged{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate setLoggedWithFacebook:NO];
    NSLog(@"Device String %@", hardwareDescription);
    typeLogin = 1;
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Token",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    stayLogged = YES;//logged;
    email = emailCpf;
    [conn addPostParameters:@"ControleAcesso" key:@"grant_type"];
    [conn addPostParameters:@"UserAndPwd" key:@"type"];
    [conn addPostParameters:emailCpf key:@"userId"];
//    NSString *idDevice = //[DADevice currentDevice].UID;
    [conn addPostParameters:idDevice key:@"deviceId"];
    [conn addPostParameters:hardwareDescription key:@"deviceModel"];
    [conn addPostParameters:@"1" key:@"deviceOS"];
    if(stayLogged){
        [conn addPostParameters:@"true" key:@"useToken"];
    }else{
        [conn addPostParameters:@"false" key:@"useToken"];
    }
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [conn addPostParameters:version key:@"AppVersion"];
    [conn addPostParameters:brandMarketing key:@"brandMarketing"];
    [conn addPostParameters:password key:@"pwd"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnLogin:)];
    [conn startRequest];
}

-(void) doLogin:(NSString*) token cpf:(NSString*)Cpf{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate setLoggedWithFacebook:NO];
    NSLog(@"Device String %@", hardwareDescription);
    typeLogin = 0;
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Token",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    stayLogged = true;
    
    [conn addPostParameters:@"ControleAcesso" key:@"grant_type"];
    [conn addPostParameters:@"byAuthToken" key:@"type"];
//    NSString *idDevice = [DADevice currentDevice].UID;
    [conn addPostParameters:idDevice key:@"deviceId"];
    [conn addPostParameters:@"1" key:@"deviceOS"];
    [conn addPostParameters:token key:@"authToken"];
    if(Cpf != nil && ![Cpf isEqualToString:@""]){
        [conn addPostParameters:Cpf key:@"userId"];
    }
    //test
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [conn addPostParameters:version key:@"AppVersion"];
    [conn addPostParameters:hardwareDescription key:@"deviceModel"];
    [conn addPostParameters:brandMarketing key:@"brandMarketing"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnLogin:)];
    [conn startRequest];
}

-(void) doLoginFacebook:(FBUserBeans*) fbUser{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate setLoggedWithFacebook:YES];
    NSLog(@"Device String %@", hardwareDescription);
    typeLogin = 2;
    currentFBUser = fbUser;
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Token",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    stayLogged = true;
    [conn addPostParameters:@"ControleAcesso" key:@"grant_type"];
    
    if(fbUser.type == Facebook){
        [conn addPostParameters:@"byFacebook" key:@"type"];
    }else{
        [conn addPostParameters:@"byGooglePlus" key:@"type"];
    }

//    NSString *idDevice = [DADevice currentDevice].UID;
    [conn addPostParameters:idDevice key:@"deviceId"];
    [conn addPostParameters:hardwareDescription key:@"deviceModel"];
    [conn addPostParameters:@"1" key:@"deviceOS"];
    [conn addPostParameters:[NSString stringWithFormat:@"%@",fbUser.idUser] key:@"idMidiaSocial"];
    [conn addPostParameters:fbUser.email key:@"userId"];
    [conn addPostParameters:@"true" key:@"useToken"];
    [conn addPostParameters:brandMarketing key:@"brandMarketing"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [conn addPostParameters:version key:@"AppVersion"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnLogin:)];
    [conn startRequest];
}


-(void)returnLogin:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                      options:NSJSONReadingMutableContainers error:&error];

    if(!error){
        if([result objectForKey:@"error"] != nil){
            if(typeLogin < 2){
                if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
                    [delegate loginError:[result objectForKey:@"error_description"]];
                }
            }else{
                if(delegate && [delegate respondsToSelector:@selector(loginFBNotRegistered:)]){
                    [delegate loginFBNotRegistered:currentFBUser];
                }
            }
            return;
        }
    

        if(delegate && [delegate respondsToSelector:@selector(loginSuccess:)]){
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            UserBeans *beans = [[UserBeans alloc] initWithDictionary:result];
            if(beans.hasFacebook){
                [appDelegate setLoggedWithFacebook:true];
            }
            
    //        beans.photo = @"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p200x200/10891458_931724706838678_4846592273261824400_n.jpg?oh=c7e176224bffcaf45a4bbcf6116372e4&oe=58A488EC&__gda__=1487441799_92ef1e576d49acf3c5da29cbf3dc7eba";
            if(![beans.photo isEqualToString:@""]){
    //            NSString *photoName = [[beans.photo componentsSeparatedByString:@"/"] lastObject];
    //            if([photoName containsString:@"?"]){
    //                photoName = [[photoName componentsSeparatedByString:@"?"] firstObject];
    //            }
    //            UIImage *cachedImage = [super loadSavedImage:photoName];
    //            if(cachedImage == nil){
                    NSError *error2;
                    beans.photo = [beans.photo stringByReplacingOccurrencesOfString:@"=//" withString:@"://"];
                    NSData *picture = [NSData dataWithContentsOfURL:[NSURL URLWithString:beans.photo] options:NSDataReadingUncached error:&error2];
                    if(!error2){
                        UIImage *image = [UIImage imageWithData:picture];
    //                    [super saveImage:image name:photoName];
                        [beans setPhotoImg:image];
                    }
    //            }else{
    //                [beans setPhotoImg:cachedImage];
    //            }
            }
            [appDelegate setLoggedUser:beans stayLogged:stayLogged];
            [appDelegate setEmailUser:email];
            [self sendNotificationToken:beans];
            [delegate loginSuccess:beans];
        }
    }else{
        
        if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
            [delegate loginError:error.localizedDescription];
        }
    }
}

-(BOOL) shouldAutoLogin{
    
   
    
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *authToken = [appDelegate getAuthToken];
        NSString *cpf = [appDelegate getCPF];
        if(![authToken isEqualToString:@""]){
            if([appDelegate usesTouchIDLogin]){
                [self usesTouchID:authToken cpf:cpf];
            }else{
                [self doLogin:authToken cpf:cpf];
            }
            return true;
        }
    
    
    return false;
}

-(void) usesTouchID:(NSString*) authToken cpf:(NSString*)cpf{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = NSLocalizedString(@"LoginTouchID", @"");
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    NSLog(@"User is authenticated successfully");
                                    if(delegate && [delegate respondsToSelector:@selector(touchIdLoginClicked)]){
                                        [delegate touchIdLoginClicked];
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self doLogin:authToken cpf:cpf];
                                    });
                                    
                                } else {
                                    switch (error.code) {
                                        case LAErrorAuthenticationFailed:
                                            NSLog(@"Authentication Failed");
                                            break;
                                            
                                        case LAErrorUserCancel:
                                            NSLog(@"User pressed Cancel button");
                                            if(delegate && [delegate respondsToSelector:@selector(cancelTouchIdLogin)]){
                                                [delegate cancelTouchIdLogin];
                                            }
                                            break;
                                            
                                        case LAErrorUserFallback:
                                            NSLog(@"User pressed \"Enter Password\"");
                                            [self requestPassword];
                                            
                                            break;
                                        default:
                                            NSLog(@"Touch ID is not configured");
                                            if(delegate && [delegate respondsToSelector:@selector(cancelTouchIdLogin)]){
                                                [delegate cancelTouchIdLogin];
                                            }
                                            break;
                                    }
                                    NSLog(@"Authentication Fails");
                                }
                            }];
            });
    }else{
        //NSLog(@"Can not evaluate Touch ID");
        [self doLogin:authToken cpf:cpf];

    }
}

-(void) doGoogleLogin:(id<GIDSignInUIDelegate>)currentViewController{
    [GIDSignIn sharedInstance].uiDelegate = currentViewController;
    [[GIDSignIn sharedInstance] signIn];
}

-(void) doGoogleLink:(id<GIDSignInUIDelegate>)currentViewController{
    linkingGoogle = true;
    [self doGoogleLogin:currentViewController];
}

-(void) doFacebookLogin:(UIViewController*)currentViewController{
    
    
    [fbLogin logOut];
    dispatch_async(dispatch_get_main_queue(), ^{
        [fbLogin logInWithPermissions:@[@"public_profile", @"email"] 
         fromViewController:currentViewController
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
                     [delegate loginError:[error localizedDescription]];
                 }
             } else if (result.isCancelled) {
                 if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
                     [delegate loginError:@"-1"];
                 }
             } else {
                 if ([FBSDKAccessToken currentAccessToken]) {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, picture, email"}]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                          if (!error) {
                              FBUserBeans *fbUser = [[FBUserBeans alloc] initWithDicitonary:result];
                              [self doLoginFacebook:fbUser];
                          }else{
                              if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
                                  [delegate loginError:error.localizedDescription];
                              }
                          }
                      }];
                 }
             }
         }];
    });
}

    
-(void) doFacebookLink:(UIViewController*)currentViewController{
    
    
    [fbLogin logOut];
    dispatch_async(dispatch_get_main_queue(), ^{
        [fbLogin logInWithPermissions: @[@"public_profile", @"email"]
         fromViewController:currentViewController
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
                     [delegate loginError:[error localizedDescription]];
                 }
             } else if (result.isCancelled) {
                 if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
                     [delegate loginError:@"-1"];
                 }
             } else {
                 if ([FBSDKAccessToken currentAccessToken]) {
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, picture, email"}]
                      startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                          if (!error) {
                              FBUserBeans *fbUser = [[FBUserBeans alloc] initWithDicitonary:result];
                              AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                              [appDelegate setLoggedWithFacebook:YES];
                              if(delegate && [delegate respondsToSelector:@selector(linkFacebookUser:)]){
                                  [delegate linkFacebookUser:fbUser];
                              }
                          }else{
                              if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
                                  [delegate loginError:error.localizedDescription];
                              }
                          }
                      }];
                 }
             }
         }];
    });
}

-(void) requestPassword{
    UIAlertController *passwordController = [UIAlertController alertControllerWithTitle:@"Password" message:@"Enter password." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        UITextField *passWordTextField = passwordController.textFields.firstObject;
        [self doLogin:[appDelegate getEmailUser] password:[passWordTextField text] stayLogged:YES];
    }];
    

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        if(delegate && [delegate respondsToSelector:@selector(cancelTouchIdLogin)]){
            [delegate cancelTouchIdLogin];
        }
    }];
    
    [passwordController addAction:defaultAction];
    [passwordController addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [passwordController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.secureTextEntry = TRUE;
            textField.placeholder = @"Password";
        }];
    
        if(delegate && [delegate respondsToSelector:@selector(showRequestPassword:)]){
            [delegate showRequestPassword:passwordController];
        }
    });
}



-(void) sendNotificationToken:(UserBeans*)beans{
    AppDelegate *appDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString*gcm = [appDelegate getGCM];
    if(gcm == nil || [gcm isEqualToString:@""]){
        return;
    }
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Notificacao/Token",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    
//    NSString *idDevice = [DADevice currentDevice].UID;
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",beans.access_token] field:@"Authorization"];
//    [conn addPostParameters:beans.cpfCnpj key:@"CpfCnpj"];
    [conn addPostParameters:gcm key:@"Token"];
    [conn addPostParameters:idDevice key:@"DeviceId"];
    [conn addPostParameters:@"1" key:@"System"];
    
    
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnToken:)];
    [conn startRequest];
}

-(void)returnToken:(NSData *)responseData{
    
    if([responseData length] == 0 ){
        return;
    }
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result objectForKey:@"message"] != nil){
//            if(delegate && [delegate respondsToSelector:@selector(homeError:)]){
//                [delegate homeError:[result objectForKey:@"message"]];
//            }
            return;
        }
    }
    

}

-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
        [delegate loginError:NSLocalizedString(@"ConnectionError",@"") ];
    }
}

#pragma mark Google Signin
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // ...
    if (error == nil) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        [result setValue:user.userID forKey:@"id"];
        [result setValue:user.profile.name forKey:@"name"];
        [result setValue:user.profile.email forKey:@"email"];
        if(user.profile.hasImage){
            [result setValue:[[user.profile imageURLWithDimension:120] absoluteString] forKey:@"picture"];
        }else{
            [result setValue:@"" forKey:@"picture"];
        }
        
        
        FBUserBeans *fbUser = [[FBUserBeans alloc] initWithDicitonary:result];
        [fbUser setType:Google];
        if(linkingGoogle){
            linkingGoogle = false;
            if(delegate && [delegate respondsToSelector:@selector(linkFacebookUser:)]){
                [delegate linkFacebookUser:fbUser];
            }
        }else{
            [self doLoginFacebook:fbUser];
        }
    } else {
        if(delegate && [delegate respondsToSelector:@selector(loginError:)]){
            [delegate loginError:error.localizedDescription];
        }
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    if (error == nil) {
        NSLog(@"Disconnected %@", user.userID);
    }
}




#pragma mark - Activate account

-(void) sendActivation:(NSDictionary*)dict{
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/AtivarCadastroSegurado",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    
    [conn addPostParameters:[dict valueForKey:@"token"] key:@"TokenAutenticacao"];
    [conn addPostParameters:[dict valueForKey:@"marcaComercializacao"] key:@"MarcaComercializacao"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnActivation:)];
    [conn startRequest];
}

-(void)returnActivation:(NSData *)responseData{
    
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result objectForKey:@"message"] != nil){
            if(delegate && [delegate respondsToSelector:@selector(activationReturn:)]){
                [delegate activationReturn:[result objectForKey:@"message"]];
            }
            return;
        }
    }
    
    
}


@end
