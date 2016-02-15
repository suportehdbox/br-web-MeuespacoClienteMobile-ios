//
//  DASavePolicyWS.m
//  DirectAssistFramework
//
//  Created by Ricardo Ramos on 7/20/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DASavePolicyWS.h"
#import "DAPolicyBase.h"
#import "DAPolicyManager.h"
#import "DAConfiguration.h"
#import "DAClientBase.h"
#import "DADevice.h"
#import "DAWebServiceActionResult.h"

@implementation DASavePolicyWS

@synthesize delegate;

- (void)savePolicy:(DAPolicyBase *)policy {

	policyToSave = policy;
	
	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	recordsFound = NO;
	errorsFound = NO;
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"ResultCode",
				  [[NSMutableString alloc] initWithString:@""], @"ErrorMessage",
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<SavePolicy xmlns=\"http://tempuri.org/\">\n"
							 "<deviceUID>%@</deviceUID>\n"
							 "<manufacturerID>%d</manufacturerID>\n"
							 "<policyID>%@</policyID>\n"
							 "<clientID>%d</clientID>\n"
							 "<token>%@</token>\n"
							 "</SavePolicy>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>",
							 [DADevice currentDevice].UID,
							 [DADevice currentDevice].manufacturerID,
							 policy.policyID, 
							 [DAConfiguration settings].applicationClient.clientID,
							 [DAConfiguration settings].webserviceToken];
	
	NSURL *wsUrl = [NSURL URLWithString:[DAConfiguration settings].directAssistWebServiceURL];
	
	//NSLog(@"SavePolicy webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"SavePolicy soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/SavePolicy" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"SavePolicy error: wsConnection is NULL");
		if ([delegate respondsToSelector:@selector(policyManager:savePolicyDidFailWithErrorMessage:)])
			[delegate policyManager:nil savePolicyDidFailWithErrorMessage:DALocalizedString(@"UnknownError", nil)];
	}	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[wsData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[wsData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//NSLog(@"SavePolicy error: %@", [error description]);
	
	if ([delegate respondsToSelector:@selector(policyManager:savePolicyDidFailWithErrorMessage:)])
		[delegate policyManager:nil savePolicyDidFailWithErrorMessage:[error localizedDescription]];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"SavePolicy Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"SavePolicy XML:\n%@", wsXML);
	
	
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
	attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"ResultCode"] || [elementName isEqualToString:@"ErrorMessage"]) 
		recordEnabled = YES;
	else
		recordEnabled = NO;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{	
	if (recordEnabled) {
		[soapResults appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"ResultCode"] || [elementName isEqualToString:@"ErrorMessage"]) {
		
		recordsFound = YES;
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"SavePolicyResult"]) {
		recordEnabled = NO;
	
		//NSLog(@"SavePolicy ResultCode: %@", [wsResults objectForKey:@"ResultCode"]);
		//NSLog(@"SavePolicy ErrorMessage: %@", [wsResults objectForKey:@"ErrorMessage"]);
		
		DAWebServiceActionResult *actionResult = [[DAWebServiceActionResult alloc] 
											initWithResultType:[[wsResults objectForKey:@"ResultCode"] intValue] 
												  errorMessage:[wsResults objectForKey:@"ErrorMessage"]];
		
		if (actionResult.resultType == kDAResultSuccess) {
			if ([delegate respondsToSelector:@selector(policyManager:didSavePolicy:)])
				[delegate policyManager:nil didSavePolicy:policyToSave];
		}
		else {
			if ([delegate respondsToSelector:@selector(policyManager:savePolicyDidFailWithErrorMessage:)])
				[delegate policyManager:nil savePolicyDidFailWithErrorMessage:[actionResult errorMessage]];
		}		
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		errorsFound = YES;
		if ([delegate respondsToSelector:@selector(policyManager:savePolicyDidFailWithErrorMessage:)])
			[delegate policyManager:nil savePolicyDidFailWithErrorMessage:DALocalizedString(@"UnknownError", nil)];
	} 
}


@end
