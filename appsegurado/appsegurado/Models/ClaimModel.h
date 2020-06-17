//
//  ClaimModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
#import "OpenClaimBeans.h"
#import "DocumentsGalleryViewController.h"


@protocol ClaimModelDelegate <NSObject>
@optional
-(void) claimSent:(int) claimNumber;
-(void) claimStatusItens:(NSMutableArray*)arrayItens;
-(void) policyItens:(NSMutableArray*)arrayItens;
-(void) claimUploadSuccess:(NSString*)msg;
-(void) claimError:(NSString*)msg;
-(void) claimStatusError:(NSString*)msg;
-(void) imagesArrayUpdated:(NSMutableArray*)arrayImages;
-(void) openImagePicker:(UIImagePickerController*) controller;
-(void) openDocumentsPicker:(UIViewController*) controller;
@end
@interface ClaimModel : BaseModel <ConexaoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DocumentsGalleryDelegate>

@property (nonatomic,assign) id<ClaimModelDelegate> delegate;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
-(void) getPolicyItens:(NSDictionary*)dic;
-(void) getClainsStatus;
-(void) sendClaim:(OpenClaimBeans*)beans cpf:(NSString*) cpf;
-(void) sendAudioImages:(NSArray*) arrayImages audio:(NSString*)audioPath sinisterNumber:(NSString*)number;
-(UIAlertController*) showOptionsCamera:(NSString*) policyNumber;
-(void) removePhotoAtIndex:(int) index;
@end
