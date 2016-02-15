//
//  CoverageControlWS.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 05/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DACoverageControlChecker.h"
#import "DAAutomotiveFile.h"
#import "DAConfiguration.h"
#import "DAFileBase.h"

@implementation DACoverageControlChecker

@synthesize delegate;

- (void)checkCoverages:(DAFileBase *)newFile {
	selectedFile = newFile;
	
	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	errorsFound = NO;
	recordsFound = NO;
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"ResultCode",
				  [[NSMutableString alloc] initWithString:@""], @"ErrorMessage",
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<CheckCoverages xmlns=\"http://tempuri.org/\">\n"
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
							 "<reference>%@</reference>\n"
							 "<token>%@</token>\n"
							 "</CheckCoverages>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>", 
							 newFile.contractNumber, 
							 newFile.phoneAreaCode,
							 newFile.phoneNumber,
							 newFile.fileCause,
							 newFile.serviceCode,
							 newFile.problemCode,
							 newFile.fileCity,
							 newFile.fileState,
							 newFile.streetName,
							 newFile.houseNumber,
							 newFile.latitude,
							 newFile.longitude,
							 newFile.addressDetail,
							 [[DAConfiguration settings] webserviceToken]];
	
	NSURL *wsUrl = [NSURL URLWithString:[DAConfiguration settings].directAssistWebServiceURL];
	
	//NSLog(@"CheckCoverageControl webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"CheckCoverageControl soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/CheckCoverages" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"CheckCoverageControl error: wsConnection is NULL");
		if ([delegate respondsToSelector:@selector(coverageControlDidFailWithError:)])
			[delegate coverageControlDidFailWithError:nil];
	}	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[wsData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[wsData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//NSLog(@"CheckCoverageControl error: %@", [error description]);
	
	if ([error code] == -1009) {
		if ([delegate respondsToSelector:@selector(coverageControlDidFailWithNoInternet)])
			[delegate coverageControlDidFailWithNoInternet];
	}
	else {
		if ([delegate respondsToSelector:@selector(coverageControlDidFailWithError:)])
			[delegate coverageControlDidFailWithError:nil];	
	}
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"CheckCoverageControl Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"CheckCoverageControl XML:\n%@", wsXML);
	
	
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

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if (!recordsFound && !errorsFound) {
		if ([delegate respondsToSelector:@selector(coverageControlDidFailWithError:)])
			[delegate coverageControlDidFailWithError:nil];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"ResultCode"] || [elementName isEqualToString:@"ErrorMessage"]) {
		
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"CheckCoveragesResult"]) {
		recordEnabled = NO;
		recordsFound = YES;
		
		//NSLog(@"ResultCode:   %@", [wsResults objectForKey:@"ResultCode"]);
		//NSLog(@"ErrorMessage: %@", [wsResults objectForKey:@"ErrorMessage"]);
		
		NSString *result = [wsResults objectForKey:@"ResultCode"];
		NSString *message = [wsResults objectForKey:@"ErrorMessage"];
		
		if ([result isEqualToString:@"0"])
			if ([delegate respondsToSelector:@selector(coverageControlDidGetOK:)])
				[delegate coverageControlDidGetOK:selectedFile];
		else
			if ([delegate respondsToSelector:@selector(coverageControlDidGetRefusal:)])
				[delegate coverageControlDidGetRefusal:message];
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		errorsFound = YES;
		if ([delegate respondsToSelector:@selector(coverageControlDidFailWithError:)])
			[delegate coverageControlDidFailWithError:nil];
	}
}

@end
