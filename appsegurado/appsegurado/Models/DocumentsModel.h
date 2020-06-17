//
//  DocumentsModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
#import "DocumentBeans.h"

@protocol DocumentsModelDelegate <NSObject>

-(void) returnDownloadDocument:(DocumentBeans*)beans;
-(void) returnDocuments:(NSMutableArray*)array;
-(void) documentsError:(NSString*)description closeScreen:(BOOL)shouldClose;

@optional
-(void) returnUploadDocuments:(BOOL) success;
-(void) deletedDocumentsSuccess;
@end

@interface DocumentsModel : BaseModel <ConexaoDelegate>

@property (nonatomic, weak) id<DocumentsModelDelegate> documentsDelegate;

- (id)init;
-(void) getPolicyDocuments:(NSString*) policy;
-(void) uploadDocument:(NSString*) policyNumber arrayDocuments:(NSArray*)arrayImages;
-(void) deleteDocuments:(NSArray*) itens forPolicy:(NSString*) policy;
@end
