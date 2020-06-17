//
//  DocumentsModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "DocumentsModel.h"
#import "AppDelegate.h"
#import "IOHelper.h"
#import "UIImage+ResizeMagick.h"
#import "AFSQLManager.h"



const int maxMBRequestDocuments = 8;

@interface DocumentsModel(){
    AppDelegate *appDelegate;
    NSMutableArray *photos;
    NSMutableArray *arrayDocumentsUpload;
    BOOL databaseOpenned;
    IOHelper *io;
    
}
@end
@implementation DocumentsModel
@synthesize documentsDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        io = [[IOHelper alloc] init];
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

-(void) getPolicyDocuments:(NSString*) policy{
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Documento/GetDocumentsByPolicy",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    

    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];

    [conn addGetParameters:policy key:@"NumeroApolice"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnPolicyDocuments:)];
    [conn startRequest];
}
//
//-(void)setDocumentsDelegate:(id<DocumentsModelDelegate>)docDel{
//    [super setDelegate:docDel];
//    documentsDelegate = docDel;
//}
-(void)returnPolicyDocuments:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    NSError *error;
    @try {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        if(!error){
            if([result objectForKey:@"error"] != nil){
                if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                    [documentsDelegate documentsError:[result objectForKey:@"error_description"]  closeScreen:YES];
                }
                return;
            }
            
            if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(returnDocuments:)]){
                NSMutableArray *arrayDocuments = [[NSMutableArray alloc] init];
            
                for (NSDictionary *dic in [result objectForKey:@"documents"]){
                    DocumentBeans *beans = [[DocumentBeans alloc] initWithDictionary:dic];
                    
                    if(![self documentsExpired:beans]){
                        //[self removeExpiredDocument:beans]; //descomentar para testar o download de imagens
                        
                        
                        NSData *dataImgLocal = [io loadFile:[NSString stringWithFormat:@"%@.jpg",beans.idDocumento]];
                        if(dataImgLocal != nil){
                            [beans setImage:[UIImage imageWithData:dataImgLocal]];
                        }else{
                            [beans setImage:[UIImage imageNamed:@"downloading"]];
                            [self downloadDocument:beans];
                        }
                        
                        [self addDateLimitToImage:beans.dataExpurgo fileName:[NSString stringWithFormat:@"%@.%@",beans.idDocumento,beans.extensao]];
                        
                        [arrayDocuments addObject:beans];
                    }else{
                        [self removeExpiredDocument:beans];
                    }
                }
            
                [documentsDelegate returnDocuments:arrayDocuments];
                
                
            }
        }else{
            
            if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                [documentsDelegate documentsError:error.localizedDescription  closeScreen:YES];
            }
        }
    } @catch (NSException *exception) {
        if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
            [documentsDelegate documentsError:exception.description  closeScreen:YES];
        }
    }
    
}

-(BOOL) documentsExpired:(DocumentBeans *)beans{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *dateBeans = [dateFormatter dateFromString:beans.dataExpurgo];
    if([dateBeans timeIntervalSinceNow] < 0){
        return TRUE;
    }
    return FALSE;
}

-(void) removeExpiredDocument:(DocumentBeans *)beans{
    NSString *fullFile = [NSString stringWithFormat:@"%@.%@",beans.idDocumento,beans.extensao];
    [self removeItensExpired:[[NSMutableArray alloc] initWithObjects:fullFile, nil]];
    [io deleteFile:fullFile];
}


-(void) downloadDocument:(DocumentBeans *) beans{
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
        Conexao *connImage = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Documento/Download",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    
        
        [connImage addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
        
        [connImage addGetParameters:beans.idDocumento key:@"idDocumento"];
        [connImage setUserInfo:[[NSDictionary alloc] initWithObjectsAndKeys:beans, @"document", nil]];
        [connImage setDelegate:self];
        [connImage setRetornoConexao:@selector(returnDownloadDocument:userInfo:)];
        [connImage startRequest];
//    });
  


}

-(void)returnDownloadDocument:(NSData *)responseData userInfo:(NSDictionary*)userInfo{
//    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    @try {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        if(!error){
            if([result objectForKey:@"error"] != nil){
                if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                    [documentsDelegate documentsError:[result objectForKey:@"error_description"]  closeScreen:NO];
                }
                return;
            }
            if([[result objectForKey:@"sucesso"] boolValue] == false){
                if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                    [documentsDelegate documentsError:[result objectForKey:@"message"]  closeScreen:NO];
                }
                return;
            }


                DocumentBeans *beans = [[DocumentBeans alloc] initWithDictionary:result];
                NSData *fileData =  [[NSData alloc] initWithBase64EncodedString:[beans conteudo] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                if([fileData bytes] <= 0){
                    return;
                }
                DocumentBeans *beansFinal = [userInfo objectForKey:@"document"];
                [beansFinal setImage:[UIImage imageWithData:fileData]];
                [io saveFile:fileData fileName:[NSString stringWithFormat:@"%@.%@",beansFinal.idDocumento,beans.extensao]];
            if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(returnDownloadDocument:)]){
                [documentsDelegate returnDownloadDocument:beansFinal];
            }
        }else{
            
            if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                [documentsDelegate documentsError:error.localizedDescription  closeScreen:NO];
            }
        }
    } @catch (NSException *exception) {
        if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
            [documentsDelegate documentsError:exception.description  closeScreen:NO];
        }
    }
    
}

-(void) uploadDocument:(NSString*) policyNumber arrayDocuments:(NSArray*)arrayImages{
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Documento/Upload",[super getBaseUrl]] contentType:@"application/json"];
    long sizeRequest = 0;
    NSMutableArray *arrayFiles = [[NSMutableArray alloc] init];
    int indImage = 1;
    arrayDocumentsUpload = [[NSMutableArray alloc] init];
    for (UIImage *image  in arrayImages) {
        UIImage *resized = [image resizedImageByWidth:1024];
        NSData *data = UIImageJPEGRepresentation(resized, 0.7);
        if([data length] /1024.0f/ 1024.0f > maxMBRequestDocuments){
            data = UIImageJPEGRepresentation(resized, 0.5);
        }
        [arrayDocumentsUpload addObject:data];
        sizeRequest += [data length];
        NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: [NSString stringWithFormat:@"foto%d_%d",indImage,(int) ceil([[NSDate date] timeIntervalSince1970])], @"Nome", base64, @"Conteudo", @"jpg", @"Extensao" , nil];
        indImage++;
        [arrayFiles addObject:dic];
        
    }
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    [conn addBodyParameters:[[appDelegate getLoggeduser] cpfCnpj] key:@"CpfCnpj"];
    [conn addBodyParameters:arrayFiles key:@"Arquivos"];
    [conn addBodyParameters:policyNumber key:@"NumeroApolice"];

    
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnUploadDocuments:)];
    [conn startRequest];
    

}

-(void)returnUploadDocuments:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    @try {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        if(!error){
            if([result objectForKey:@"error"] != nil){
                if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                    [documentsDelegate documentsError:[result objectForKey:@"error_description"] closeScreen:NO];
                }
                return;
            }
            
            if([[result objectForKey:@"sucesso"] boolValue] == false){
                if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                    [documentsDelegate documentsError:[result objectForKey:@"message"] closeScreen:NO];
                }
                return;
            }
            
            
            if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(returnUploadDocuments:)]){
                for (NSDictionary *dic in [result objectForKey:@"arquivos"]) {
                    NSData *data = [arrayDocumentsUpload objectAtIndex:([[dic objectForKey:@"codArquivo"] intValue]-1)];
                    
                    [io saveFile:data fileName:[NSString stringWithFormat:@"%@.jpg",[dic objectForKey:@"idDocumento"]]];
                }
                
                [documentsDelegate returnUploadDocuments:YES];
            }
        }else{
            
            if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                [documentsDelegate documentsError:error.localizedDescription  closeScreen:NO];
            }
        }
    } @catch (NSException *exception) {
        if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
            [documentsDelegate documentsError:exception.description  closeScreen:NO];
        }
    }
    
}
     
-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
 
     NSLog(@"Retorno erro conexão %@, %@", response , error);
     if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
         [documentsDelegate documentsError:NSLocalizedString(@"ConnectionError",@"")  closeScreen:NO];
     }
}


-(void)retornaErroConexaoGetDocuments:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
        [documentsDelegate documentsError:NSLocalizedString(@"ConnectionError",@"")  closeScreen:YES];
    }
}

-(void) addDateLimitToImage:(NSString*)date fileName:(NSString*)fileName{
    [self loadDataBase];
    
    
    if(![self existsFileDB:fileName]){
        
        date = [date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        date = [date stringByReplacingOccurrencesOfString:@"Z" withString:@""];
        NSString *query = [NSString stringWithFormat:@"INSERT INTO cached_image (limitDate,fileName) VALUES ('%@','%@') ", date, fileName];
        
        [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
            if (!error) {
                if (!finished) {
                    
                }
            } else {
                NSLog(@"Error open database %@", error.localizedDescription);
            }
            
        }];
    }
}

-(BOOL) existsFileDB:(NSString*) fileName{
    [self loadDataBase];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM cached_image WHERE fileName = '%@'", fileName];
    
    __block BOOL found = false;
    [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (!error) {
            if (!finished) {
                if([row count] > 0){
                    found = true;
                }
            }
        } else {
            NSLog(@"Error open database %@", error.localizedDescription);
        }
        
    }];
    return found;
}

-(NSMutableArray*) returnItensExpired {
    NSMutableArray *arrayItens = [[NSMutableArray alloc] init];
    [self loadDataBase];
    
    
    NSString *query = @"SELECT fileName FROM cached_image WHERE limitDate < datetime()";
    
    [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (!error) {
            if (!finished) {
                [arrayItens addObject:[row objectAtIndex:0]];
            }
        } else {
            NSLog(@"Error open database %@", error.localizedDescription);
        }
        
    }];

    return arrayItens;
}

-(void) removeItensExpired:(NSMutableArray*) arrayItens{
    [self loadDataBase];
    
    for (NSString *fileName in arrayItens) {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM cached_image WHERE fileName = '%@' ", fileName];
        
        [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
            if (!error) {
                if (!finished) {
                   
                }
            } else {
                NSLog(@"Error open database %@", error.localizedDescription);
            }
            
        }];
    }
}


-(void) deleteDocuments:(NSArray*) itens forPolicy:(NSString*) policy{
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Documento/RemoveDocuments",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    
    
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    
    [conn addPostParameters:policy key:@"Policy"];
    
    int index = 0;
    for (NSString *doc in itens) {
        [conn addPostParameters:doc key:[NSString stringWithFormat:@"Documents[%d]",index]];
        index++;
    }
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnDeleteDocuments:)];
    [conn startRequest];
}

-(void)returnDeleteDocuments:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    NSError *error;
    @try {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        if(!error){
            if([result objectForKey:@"error"] != nil){
                if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                    [documentsDelegate documentsError:[result objectForKey:@"error_description"]  closeScreen:YES];
                }
                return;
            }
            
            if([result objectForKey:@"success"]){
                if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(deletedDocumentsSuccess)]){
                    [documentsDelegate deletedDocumentsSuccess];
                }
            }else{
                if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                    [documentsDelegate documentsError:[result objectForKey:@"message"]  closeScreen:YES];
                }
            }
        }else{
            
            if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
                [documentsDelegate documentsError:error.localizedDescription  closeScreen:YES];
            }
        }
    } @catch (NSException *exception) {
        if(documentsDelegate && [documentsDelegate respondsToSelector:@selector(documentsError:closeScreen:)]){
            [documentsDelegate documentsError:exception.description  closeScreen:YES];
        }
    }
    
}

#pragma mark - Database stuffs
-(void) loadDataBase{
    if(databaseOpenned){
        return;
    }
    
    [[AFSQLManager sharedManager] openDocumentsDatabaseWithName:@"libertymobile.db" andStatusBlock:^(BOOL success, NSError *error) {
        databaseOpenned = success;
        if(!error){
            NSString *query = @"CREATE TABLE IF NOT EXISTS cached_image (id INTEGER PRIMARY KEY AUTOINCREMENT, limitDate DATE (10), fileName STRING (255))";
            [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
                if (!error) {
                    
                }
            }];
        }else{
            NSLog(@"Error open database %@", error.localizedDescription);
        }
    }];
    
    
}
-(void) closeDataBase{
    databaseOpenned = false;
    [[AFSQLManager sharedManager] closeLocalDatabase];
}

@end
