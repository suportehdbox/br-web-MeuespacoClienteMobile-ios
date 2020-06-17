//
//  Conexao.h
//  IntuitiveBeaconLib
//
//  Created by Luiz Zenha on 03/04/14.
//  Copyright (c) 2014 Intuitive Appz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConexaoDelegate <NSObject>
@optional
-(void) retornaConexao:(NSURLResponse *)response responseString:(NSString*)responseString;
-(void) retornaErroConexao:(NSDictionary*)dictUserInfo response:(NSURLResponse *)response error:(NSError*)error;
-(void) retornaDownloadImage:(UIImage*) image object:(id)object;
@end

@interface Conexao : NSObject <NSURLConnectionDelegate>{


}
@property (nonatomic) id <ConexaoDelegate> delegate;
@property (assign) SEL retornoConexao;
@property (assign) SEL retornoErroConexao;

-(id) initWithURL:(NSString*)url;
-(id) initWithURL:(NSString*)url contentType:(NSString*)type;
-(void) addPostParameters:(NSString*)param key:(NSString*)key;
-(void) addGetParameters:(NSString*)param key:(NSString*)key;
-(void) addBodyParameters:(id)param key:(NSString *)key;
-(void) addHeaderValue:(NSString*)value field:(NSString*)field;
-(void) startRequest;
-(void) stopRequest;
-(void) setUserInfo:(NSDictionary *)userInfo;
-(NSDictionary *) getUserInfo;

-(void) downloadImage:(NSString *) urlPath object:(id)object;

-(void) setRetornoConexao:(SEL)selector;
-(void) setRetornoErroConexao:(SEL)selector;
@end
