//
//  BaseModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 22/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conexao.h"

#define PRODUCTION FALSE

@interface BaseModel : NSObject {
    NSString * brandMarketing;
    Conexao * conn;
}

- (id) init;
- (NSString *) getGlassAssistUrl;
- (NSString *) getBaseUrl;
- (NSString *) getClubUrl;
- (NSString *) getOnlinePaymentUrl;
- (NSString *) getFacilAssist;
- (NSString *) getBrandMarketing;
- (NSString *) getBaseUrl: (NSString *)version;

- (BOOL) validateCPFWithNSString: (NSString *)cpfParam;
- (BOOL) validarCNPJ: (NSString *)cnpj;
- (BOOL) isValidEmail: (NSString *)email;
- (BOOL) isValidPassword: (NSString *)password;

- (void) saveImage: (UIImage *)image name: (NSString *)name;
- (NSString *) savePDF: (NSData *)data name: (NSString *)name;
- (UIImage *) loadSavedImage: (NSString *)name;
- (NSString *) getExistsFile: (NSString *)name;
- (NSString *) getHomeAssistUrl;
- (NSString *) getAutoClaimUrl;
@end
