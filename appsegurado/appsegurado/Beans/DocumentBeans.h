//
//  DocumentBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentBeans : NSObject

@property (nonatomic, strong) NSString* dataExpurgo;
@property (nonatomic, strong) NSString* idDocumento;
@property (nonatomic, strong) NSString* nome;
@property (nonatomic, strong) NSString* conteudo;
@property (nonatomic, strong) NSString* extensao;
@property (nonatomic, strong) UIImage* image;


-(id)initWithDictionary:(NSDictionary*)dic;



@end
