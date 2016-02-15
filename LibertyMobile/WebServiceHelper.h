// WebServiceHelper.h
// 
//  Created by Kris Bray with Imperium on 27/05/10.
// * This code is licensed under the GPLv3 license.
#import <UIKit/UIKit.h>


@interface WebServiceHelper : NSObject <NSURLConnectionDelegate>
{
	NSString *XMLNameSpace;
	NSString *XMLURLAddress;
	NSString *MethodName;
	NSString *SOAPActionURL;
	NSMutableDictionary *MethodParameters;
    NSURLResponse *webResponseSynchronous;
    
    NSString *jsonRequest;
}

@property(nonatomic, copy) NSString *XMLNameSpace;
@property(nonatomic, copy) NSString *XMLURLAddress;
@property(nonatomic, copy) NSString *MethodName;
@property(nonatomic, copy) NSString *SOAPActionURL;
@property(nonatomic, retain) NSMutableDictionary *MethodParameters;
@property(nonatomic, retain) NSURLResponse *webResponseSynchronous;

@property(nonatomic, copy) NSString *jsonRequest;

- (void)initiateConnectionWCF:(id)target;
- (void)initiateConnection:(id)target;
- (void)initiateConnection:(id)target timeout:(NSTimeInterval)timeout;
- (NSData *)initiateConnectionSynchronous:(id)target;
- (NSData *)initiateConnectionSynchronous:(id)target timeout:(NSTimeInterval)timeout;
-(NSDictionary *)getCookie;

@end