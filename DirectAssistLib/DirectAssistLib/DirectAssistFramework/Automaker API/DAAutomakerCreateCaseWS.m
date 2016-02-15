//
//  DAAutomakerCreateCaseWS.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/5/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAutomakerCreateCaseWS.h"

@implementation DAAutomakerCreateCaseWS

@synthesize delegate;

- (void)createCase:(DAFileBase *)automakerCase {
	
	selectedCase = automakerCase;
	
	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"CaseNumber",
				  [[NSMutableString alloc] initWithString:@""], @"ResultCode",
				  [[NSMutableString alloc] initWithString:@""], @"ErrorMessage",
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<CreateCase xmlns=\"http://tempuri.org/\">\n"
							 "<contractNumber>%@</contractNumber>\n"
							 "<phoneAreaCode>%@</phoneAreaCode>\n"
							 "<phoneNumber>%@</phoneNumber>\n"
							 "<fileCause>%@</fileCause>\n"
							 "<serviceCode>%@</serviceCode>\n"
							 "<problemCode>%@</problemCode>\n"
							 "<fileCity>%@</fileCity>\n"
							 "<fileState>%@</fileState>\n"
							 "<address>%@</address>\n"
							 "<addressNumber>%@</addressNumber>\n"
							 "<latitude>%@</latitude>\n"
							 "<longitude>%@</longitude>\n"
							 "<token>%@</token>\n"
							 "</CreateCase>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>", 
							 automakerCase.contractNumber, 
							 automakerCase.phoneAreaCode,
							 automakerCase.phoneNumber,
							 automakerCase.fileCause,
							 automakerCase.serviceCode,
							 automakerCase.problemCode,
							 automakerCase.fileCity,
							 automakerCase.fileState,
							 automakerCase.streetName,
							 automakerCase.houseNumber,
							 automakerCase.latitude,
							 automakerCase.longitude,
							 [[DAConfiguration settings] webserviceToken]];
	
	NSURL *wsUrl = [NSURL URLWithString:[[DAConfiguration settings] automakerWebServiceURL]];
	
	//NSLog(@"File webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"File soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/CreateCase" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else {
		//NSLog(@"File error: wsConnection is NULL");
		if ([delegate respondsToSelector:@selector(automakerCreateCaseWS:didFailWithErrorMessage:)])
			[delegate automakerCreateCaseWS:self didFailWithErrorMessage:DALocalizedString(@"UnknownError", nil)];
	}	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[wsData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[wsData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//NSLog(@"File error: %@", [error description]);
	
	if ([delegate respondsToSelector:@selector(automakerCreateCaseWS:didFailWithErrorMessage:)])
		[delegate automakerCreateCaseWS:self didFailWithErrorMessage:[error localizedDescription]];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"File Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"File XML:\n%@", wsXML);
	
	
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
	attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"CaseNumber"] || [elementName isEqualToString:@"ResultCode"] ||
	   [elementName isEqualToString:@"ErrorMessage"]) 
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
	if([elementName isEqualToString:@"CaseNumber"] || [elementName isEqualToString:@"ResultCode"] ||
	   [elementName isEqualToString:@"ErrorMessage"]) {
		
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"CreateCaseResult"]) {
		recordEnabled = NO;
		
		//NSLog(@"CaseNumber:   %@", [wsResults objectForKey:@"CaseNumber"]);
		//NSLog(@"ResultCode:   %@", [wsResults objectForKey:@"ResultCode"]);
		//NSLog(@"ErrorMessage: %@", [wsResults objectForKey:@"ErrorMessage"]);
		
		selectedCase.fileNumber = [wsResults objectForKey:@"CaseNumber"];
		
		if ([delegate respondsToSelector:@selector(automakerCreateCaseWS:didCreateCase:)])
			[delegate automakerCreateCaseWS:self didCreateCase:selectedCase];	
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		
		if ([delegate respondsToSelector:@selector(automakerCreateCaseWS:didFailWithErrorMessage:)])
			[delegate automakerCreateCaseWS:self didFailWithErrorMessage:DALocalizedString(@"UnknownError", nil)];
	}
}

@end
