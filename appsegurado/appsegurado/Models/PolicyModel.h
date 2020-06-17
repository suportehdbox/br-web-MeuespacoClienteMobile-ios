//
//  PolicyModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
@protocol PolicyModelDelegate <NSObject>
-(void) policyResult:(NSArray*)arrayBeans;
-(void) policyResultDetail:(NSArray*)arrayBeans;
-(void) policyPaymentResult:(NSArray*)arrayBeans;
-(void) policyError:(NSString*)message;
-(void) pdfError:(NSString*)message;
-(void) pdfDownloaded:(NSString*) path;
@end
@interface PolicyModel : BaseModel <ConexaoDelegate>

@property (nonatomic,assign) id<PolicyModelDelegate> delegate;
@property (nonatomic) BOOL onlyReturnAutoPolices;

-(void) getUserPolices:(BOOL)active;
-(void) getDetailPolice:(NSString*)police;
-(void) getParcels:(long)contract issuance:(int)issuance ciaCode:(int) ciaCode;
-(void) getSecondPolicyPDF:(NSString*)policyNumber type:(int)type;
@end
