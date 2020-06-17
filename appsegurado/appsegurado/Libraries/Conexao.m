    //
//  Conexao.m
//  mobGuide
//
//  Created by Luiz Zenha on 03/04/14.
//  Copyright (c) 2014 Intuitive Appz. All rights reserved.
//

#import "Conexao.h"

#import "NSString+URLEncoding.h"


@interface Conexao(){

    NSMutableURLRequest *request;
    NSString *postString;
    NSMutableData *_responseData;
    NSURLResponse *urlResponse;
    NSURLConnection *conn;
    NSString *urlRequest;
    
    NSDictionary *dictUserInfo;

    NSMutableDictionary *contentDictionary;
}
@end
@implementation Conexao
@synthesize delegate,retornoErroConexao,retornoConexao;

-(id) initWithURL:(NSString*)url{
    urlRequest = url;
    request = nil;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequest]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];    
    postString = @"";
    contentDictionary = [[NSMutableDictionary alloc] init];
    return self;
}

-(id) initWithURL:(NSString*)url contentType:(NSString*)type{
    urlRequest = url;
    request = nil;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequest]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    
    NSDictionary *headers = @{ @"content-type": type,
                               @"cache-control": @"no-cache" };

    [request setAllHTTPHeaderFields:headers];
    postString = @"";
    contentDictionary = [[NSMutableDictionary alloc] init];
    return self;
}
-(void) setUserInfo:(NSDictionary *)userInfo{
    dictUserInfo = [userInfo copy];
}

-(NSDictionary *) getUserInfo{
    return  dictUserInfo;
}
-(void) addHeaderValue:(NSString*)value field:(NSString*)field{
   [request addValue:value forHTTPHeaderField:field];
}
-(void) addPostParameters:(NSString*)param key:(NSString*)key{
    [request setHTTPMethod:@"POST"];
    param = [param stringByAddingPercentEncodingForRFC3986];
    if([postString isEqualToString:@""]){
        postString = [NSString stringWithFormat:@"%@%@=%@",postString,key,param];
    }else{
        postString = [NSString stringWithFormat:@"%@&%@=%@",postString,key,param];
    }
}
-(void) addGetParameters:(NSString *)param key:(NSString *)key{
//    [request setHTTPMethod:@"GET"];
    param = [param stringByAddingPercentEncodingForRFC3986];
    if([postString isEqualToString:@""]){
        postString = [NSString stringWithFormat:@"?%@=%@",key,param];
    }else{
        postString = [NSString stringWithFormat:@"%@&%@=%@",postString,key,param];
    }
}

-(void) addBodyParameters:(id)param key:(NSString *)key{
//    param = [param stringByAddingPercentEncodingForRFC3986];
    [contentDictionary setValue:param forKey:key];
}


-(void) startRequest{
    [self addHeaderValue:@"X-Liberty-AtivarTrace" field:@"true"];
    
    if(![postString isEqualToString:@""]){
        if([[request HTTPMethod] isEqualToString:@"POST"]){
            NSData *postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:postBody];
        }else{
            request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",request.URL.absoluteString, postString]];
        }
    }else if([contentDictionary count] > 0){
        [request setHTTPMethod:@"POST"];
        NSData *data = [NSJSONSerialization dataWithJSONObject:contentDictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
//        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request addValue:[NSString stringWithFormat:@"%d",(int)[jsonStr length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:data];
    }
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    [conn start];
}

-(void) stopRequest{

    [conn cancel];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    urlResponse = response;
//    NSLog(@"Responde %@", [response description]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];

}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
//    NSString* responseString = [NSString stringWithUTF8String:[_responseData bytes]];
    //[delegate retornaConexao:urlResponse responseString:responseString];
    if (delegate && [delegate respondsToSelector:retornoConexao]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (dictUserInfo != nil) {
            [delegate performSelector:retornoConexao withObject:_responseData withObject:dictUserInfo];
        } else {
            [delegate performSelector:retornoConexao withObject:_responseData];
        }
#pragma clang diagnostic ppop
    }else{
        NSString* responseString = [NSString stringWithUTF8String:[_responseData bytes]];
        [delegate retornaConexao:urlResponse responseString:responseString];
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
//    [delegate retornaErroConexao:urlResponse error:error];
    if (delegate && [delegate respondsToSelector:retornoErroConexao]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [delegate performSelector:retornoErroConexao withObject:error];
#pragma clang diagnostic ppop
    }else{
        [delegate retornaErroConexao:dictUserInfo response:urlResponse error:error];
    }
}

-(void) downloadImage:(NSString *) urlPath object:(id)object{
    NSURL *url = [NSURL URLWithString:urlPath];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (delegate && [delegate respondsToSelector:@selector(retornaDownloadImage:object:)]) {
                [delegate retornaDownloadImage:image object:object];
            }
        }
    }];
    [task resume];
}



@end
