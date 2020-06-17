//
//  DocumentBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "DocumentBeans.h"

@implementation DocumentBeans
@synthesize nome,dataExpurgo,idDocumento,extensao, conteudo, image;

-(id)initWithDictionary:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        if([dic objectForKey:@"nome"] != [NSNull null] && [dic objectForKey:@"nome"] != nil){
            nome = [dic objectForKey:@"nome"];
        }else{
            nome = @"";
        }
        if([dic objectForKey:@"dataExpurgo"] != [NSNull null] && [dic objectForKey:@"dataExpurgo"] != nil){
            dataExpurgo = [dic objectForKey:@"dataExpurgo"];
        }else{
            dataExpurgo = @"";
        }
        if([dic objectForKey:@"idDocumento"] != [NSNull null] && [dic objectForKey:@"idDocumento"] != nil){
            idDocumento = [dic objectForKey:@"idDocumento"];
        }else{
            idDocumento = @"";
        }
        if([dic objectForKey:@"extensao"] != [NSNull null] && [dic objectForKey:@"extensao"] != nil){
            extensao = [[dic objectForKey:@"extensao"] stringByReplacingOccurrencesOfString:@"jpeg" withString:@"jpg"];
        }else{
            extensao = @"jpg";
        }
        if([dic objectForKey:@"conteudo"] != [NSNull null] && [dic objectForKey:@"conteudo"] != nil){
            conteudo = [dic objectForKey:@"conteudo"];
        }else{
            conteudo = @"";
        }
    }
    return self;
}

    
@end
