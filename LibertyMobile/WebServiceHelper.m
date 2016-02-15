 // WebServiceHelper.m
// 
//  Created by Kris Bray with Imperium on 27/05/10.
// * This code is licensed under the GPLv3 license.

#import "WebServiceHelper.h"

@implementation WebServiceHelper

@synthesize MethodName;
@synthesize MethodParameters;
@synthesize XMLNameSpace;
@synthesize XMLURLAddress;
@synthesize SOAPActionURL;
@synthesize webResponseSynchronous;

@synthesize jsonRequest;

- (void)initiateConnectionWCF:(id)target
{

    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:XMLURLAddress] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    [req setHTTPMethod:@"POST"];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [jsonRequest length]];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [req setValue:@"*/*" forHTTPHeaderField:@"Accept"];
	
    [req addValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [req setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *dictCookie = [self getCookie];
    if (dictCookie != nil && [dictCookie count] != 0) {
        [req setAllHTTPHeaderFields:dictCookie];
    }
    
    NSLog(@" \n\n\n %@",jsonRequest);
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    //Chama o webservice e as mensagens do seu delegate fica para onde foi a chamada
    [[NSURLConnection alloc] initWithRequest:req delegate:target];

}

- (void)initiateConnection:(id)target
{
    //10 minutos
    [self initiateConnection:target timeout:180];
}

- (void)initiateConnection:(id)target timeout:(NSTimeInterval)timeout
{
	NSString *lastChar;
	NSString *slashUsed;
	lastChar = [self.XMLNameSpace substringFromIndex:self.XMLNameSpace.length -1];
	
	if([lastChar isEqualToString:@"/"])
    {
        slashUsed = @"";
    }
    else
    {
        slashUsed = @"/";
    }

	NSMutableString *sXmlRequest = [[NSMutableString alloc] init];
	self.SOAPActionURL = [NSString stringWithFormat:@"%@%@%@",self.XMLNameSpace, slashUsed, self.MethodName];

    //make soap request
	[sXmlRequest appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
	[sXmlRequest appendString:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"];
	[sXmlRequest appendString:@"<soap:Body>\n"];
    
    if ([MethodParameters count] != 0) {
        [sXmlRequest appendString:[NSString stringWithFormat:@"<%@ xmlns=\"%@\">\n", MethodName, XMLNameSpace]];

        NSEnumerator *tableIterator = [MethodParameters keyEnumerator];
        NSString *keyID;
        int iCont = 0;
        while(keyID = [tableIterator nextObject])
        {
            [sXmlRequest appendString:[NSString stringWithFormat:@"<%@>%@</%@>", keyID, [MethodParameters objectForKey:keyID], keyID]];
            iCont++;
        }
 
        //close envelope
        [sXmlRequest appendString:[NSString stringWithFormat:@"</%@>\n", MethodName]];
    }
    else {
        [sXmlRequest appendString:[NSString stringWithFormat:@"<%@ xmlns=\"%@\" />\n", MethodName, XMLNameSpace]];        
    }
    
	[sXmlRequest appendString:@"</soap:Body>\n"];
	[sXmlRequest appendString:@"</soap:Envelope>\n"];
    
	//The URL of the Webserver
   	NSURL *myWebserverURL = [NSURL URLWithString:XMLURLAddress];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [sXmlRequest length]];

    //Making request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myWebserverURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeout];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"text/xml; charset=uft-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:self.SOAPActionURL forHTTPHeaderField:@"SOAPAction"];
    [request setHTTPBody:[sXmlRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@", sXmlRequest);
    
    [sXmlRequest release];
    
    NSDictionary *dictCookie = [self getCookie];
    if (dictCookie != nil && [dictCookie count] != 0) {
        [request setAllHTTPHeaderFields:dictCookie];
    }

    [request setTimeoutInterval:timeout];

    //Chama o webservice e as mensagens do seu delegate fica para onde foi a chamada
    [[NSURLConnection alloc] initWithRequest:request delegate:target startImmediately:TRUE];
    
}

- (NSData *)initiateConnectionSynchronous:(id)target {
    return [self initiateConnectionSynchronous:target timeout:360];
}

- (NSData *)initiateConnectionSynchronous:(id)target timeout:(NSTimeInterval)timeout
{
	NSString *lastChar;
	NSString *slashUsed;
	lastChar = [self.XMLNameSpace substringFromIndex:self.XMLNameSpace.length -1];
	
	if([lastChar isEqualToString:@"/"]){
        slashUsed = @"";
    }
    else
    {
        slashUsed = @"/";
		
    }
    
	NSMutableString *sXmlRequest = [[NSMutableString alloc] init];
	self.SOAPActionURL = [NSString stringWithFormat:@"%@%@%@",self.XMLNameSpace, slashUsed, self.MethodName];
    
    //make soap request
	[sXmlRequest appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
	[sXmlRequest appendString:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"];
	[sXmlRequest appendString:@"<soap:Body>\n"];
    
    if ([MethodParameters count] != 0) {
        [sXmlRequest appendString:[NSString stringWithFormat:@"<%@ xmlns=\"%@\">\n", MethodName, XMLNameSpace]];
        
        NSEnumerator *tableIterator = [MethodParameters keyEnumerator];
        NSString *keyID;
        int iCont = 0;
        while(keyID = [tableIterator nextObject])
        {
            [sXmlRequest appendString:[NSString stringWithFormat:@"<%@>%@</%@>", keyID, [MethodParameters objectForKey:keyID], keyID]];
            iCont++;
        }
        
        //close envelope
        [sXmlRequest appendString:[NSString stringWithFormat:@"</%@>\n", MethodName]];
    }
    else {
        [sXmlRequest appendString:[NSString stringWithFormat:@"<%@ xmlns=\"%@\" />\n", MethodName, XMLNameSpace]];
    }
    
	[sXmlRequest appendString:@"</soap:Body>\n"];
	[sXmlRequest appendString:@"</soap:Envelope>\n"];
    
	//The URL of the Webserver
   	NSURL *myWebserverURL = [NSURL URLWithString:XMLURLAddress];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [sXmlRequest length]];
    
    //Making request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myWebserverURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"text/xml; charset=uft-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:self.SOAPActionURL forHTTPHeaderField:@"SOAPAction"];
    [request setHTTPBody:[sXmlRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    [sXmlRequest release];
    
    NSDictionary *dictCookie = [self getCookie];
    if (dictCookie != nil && [dictCookie count] != 0) {
        [request setAllHTTPHeaderFields:dictCookie];
    }
    
    [request setTimeoutInterval:timeout];   //3 minutos
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&webResponseSynchronous error:nil];
    
    return data;
}

- (NSDictionary *)getCookie
{
    NSArray *availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://temp"]];
    
    if (availableCookies == nil)
        return nil;
    
    return [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
}

-(void)dealloc
{
	[MethodName release];
	[MethodParameters release];
	[XMLNameSpace release];
	[XMLURLAddress release];
	[SOAPActionURL release];
	[super dealloc];
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURL* baseURL = [NSURL URLWithString:SOAPActionURL];
        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
            NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        } else
            NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (BOOL) connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    if([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        return YES;
    }
    return NO;
}

@end
