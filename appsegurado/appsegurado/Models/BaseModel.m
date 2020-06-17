//
//  BaseModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 22/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)init
{
    self = [super init];
    if (self) {

        brandMarketing = @"1";
        if([Config isAliroProject]){
            brandMarketing = @"2";
        }
    }
    return self;
}

-(NSString*) getBaseUrl{

    if(PRODUCTION){
        return @"https://mobile.libertyseguros.com.br/api/v1/";
    }else{
        return @"https://act-dmz.libertyseguros.com.br/MobileApi/api/v1/";
//        return @"https://aws-act-dmz.libertyseguros.com.br/MobileApi/api/v1/";
    }

}

-(NSString*) getBaseUrl:(NSString*) version{
    
    return [[self getBaseUrl] stringByReplacingOccurrencesOfString:@"v1" withString:version];
}

-(NSString*) getOnlinePaymentUrl{
    
    if(PRODUCTION){
        return @"https://portalintegracao.libertyseguros.com.br/PagamentoUI/UI/PagamentoOnline/PagamentoOnlineAPPController.aspx";
    }else{
        return @"https://act-dmz.libertyseguros.com.br/PagamentoUI/UI/PagamentoOnline/PagamentoOnlineAPPController.aspx";
    }

}

-(NSString*) getClubUrl{
    
    if(PRODUCTION){
        return @"https://libertyseguros.clubeben.com.br/auth/general/?token=";
    }else{
        return @"https://libertyseguros.homolog.clubeben.proxy.media/auth/general/?token=";
    }
    
}

-(NSString *) getHomeAssistUrl{
    if(PRODUCTION){
        return @"https://mobile.libertyseguros.com.br/AssistenciaResidencia/";
    }else{
        return @"https://act-dmz.libertyseguros.com.br/AssistenciaResidencia/";
    }
}

-(NSString*) getGlassAssistUrl{
    if([Config isAliroProject]){
        return @"https://www.abraseuatendimento.com.br/#/aliro";
    }else{
        
        return @"https://www.abraseuatendimento.com.br/#/liberty";
    }
    
}


-(NSString*) getFacilAssist{
    if([Config isAliroProject]){
        if(PRODUCTION){
            return @"https://mobile.libertyseguros.com.br/Assistencia24/";
        }else{
            return @"https://act-meuespaco.aliroseguro.com.br/SitePages/AssistenciaAuto/";
        }
    }else{
        //  return @"https://dqkr3yt2sbyrt.cloudfront.net";
        if(PRODUCTION){
            return @"https://mobile.libertyseguros.com.br/Assistencia24/";
        }else{
            return @"https://act-meuespaco.libertyseguros.com.br/SitePages/AssistenciaAuto/";
        }
        
    }
}


- (BOOL)validateCPFWithNSString:(NSString *)cpfParam {
    
    NSString *cpf = [cpfParam stringByReplacingOccurrencesOfString:@"." withString:@""];
    cpf = [cpf stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSUInteger i, firstSum, secondSum, firstDigit, secondDigit, firstDigitCheck, secondDigitCheck;
    if(cpf == nil) return NO;

    if([cpf length] == 14){
        return [self validarCNPJ:cpf ];
    }
    if ([cpf length] != 11) return NO;
    if (([cpf isEqual:@"00000000000"]) || ([cpf isEqual:@"11111111111"]) || ([cpf isEqual:@"22222222222"])|| ([cpf isEqual:@"33333333333"])|| ([cpf isEqual:@"44444444444"])|| ([cpf isEqual:@"55555555555"])|| ([cpf isEqual:@"66666666666"])|| ([cpf isEqual:@"77777777777"])|| ([cpf isEqual:@"88888888888"])|| ([cpf isEqual:@"99999999999"])) return NO;
    
    firstSum = 0;
    for (i = 0; i <= 8; i++) {
        firstSum += [[cpf substringWithRange:NSMakeRange(i, 1)] intValue] * (10 - i);
    }
    
    if (firstSum % 11 < 2)
        firstDigit = 0;
    else
        firstDigit = 11 - (firstSum % 11);
    
    secondSum = 0;
    for (i = 0; i <= 9; i++) {
        secondSum = secondSum + [[cpf substringWithRange:NSMakeRange(i, 1)] intValue] * (11 - i);
    }
    
    if (secondSum % 11 < 2)
        secondDigit = 0;
    else
        secondDigit = 11 - (secondSum % 11);
    
    firstDigitCheck = [[cpf substringWithRange:NSMakeRange(9, 1)] intValue];
    secondDigitCheck = [[cpf substringWithRange:NSMakeRange(10, 1)] intValue];
    
    if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck))
        return YES;
    return NO;
}
- (BOOL)isValidEmail:(NSString *)email
{
    
    NSString *regex1 = @"\\A[a-z0-9]+([-._][a-z0-9]+)*@([a-z0-9]+(-[a-z0-9]+)*\\.)+[a-z]{2,4}\\z";
    NSString *regex2 = @"^(?=.{1,64}@.{4,64}$)(?=.{6,100}$).*";
    NSPredicate *test1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *test2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [test1 evaluateWithObject:[email lowercaseString]] && [test2 evaluateWithObject:[email lowercaseString]];
}

-(BOOL) isValidPassword:(NSString*)password{
    NSString *regex1 = @"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d$@$!%*#?\\-\\.+\\/\\\\\\(\\)\\_]{6,}$";
    NSPredicate *test1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    return [test1 evaluateWithObject:password];
}

- (BOOL)validarCNPJ:(NSString *)cnpj
{
    // Mantem somente numeros
    cnpj = [[cnpj componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    if ([cnpj length] != 14) return NO;
    
    int calcularUm = 0;
    int calcularDois = 0;
    for (int i = 0, x = 5; i <= 11; i++, x--) {
        x = (x < 2) ? 9 : x;
        int number = [[cnpj substringWithRange:NSMakeRange(i, 1)] intValue];
        calcularUm += number * x;
    }
    for (int i = 0, x = 6; i <= 12; i++, x--) {
        x = (x < 2) ? 9 : x;
        int numberDois = [[cnpj substringWithRange:NSMakeRange(i, 1)] intValue];
        calcularDois += numberDois * x;
    }
    
    int digitoUm = ((calcularUm % 11) < 2) ? 0 : 11 - (calcularUm % 11);
    int digitoDois = ((calcularDois % 11) < 2) ? 0 : 11 - (calcularDois % 11);
    
    if (digitoUm != [[cnpj substringWithRange:NSMakeRange(12, 1)] intValue] || digitoDois != [[cnpj substringWithRange:NSMakeRange(13, 1)] intValue]) {
        return NO;
    }
    return YES;
}


-(void) saveImage:(UIImage*) image name:(NSString*)name{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[cachesDirectory stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if([fileManager fileExistsAtPath:imagePath]){
        if (![fileManager removeItemAtPath:imagePath error:&error]) {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
    
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    
}

-(NSString*) savePDF:(NSData*) data name:(NSString*)name{
  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if([fileManager fileExistsAtPath:imagePath]){
        if (![fileManager removeItemAtPath:imagePath error:&error]) {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
    
    if (![data writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
        return nil;
    }
    
    return imagePath;
}

-(UIImage*) loadSavedImage:(NSString*)name{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[cachesDirectory stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:imagePath]){
        return [UIImage imageWithContentsOfFile:imagePath];
    }
    return nil;
    
}

-(NSString*) getExistsFile:(NSString*)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if([fileManager fileExistsAtPath:imagePath]){
        return imagePath;
    }
    return nil;
}
@end
