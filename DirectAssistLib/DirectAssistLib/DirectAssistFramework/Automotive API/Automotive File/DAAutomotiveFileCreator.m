//
//  DAAutomotiveFileCreator.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 24/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAAutomotiveFileCreator.h"
#import "DAAutomotiveFile.h"
#import "DAConfiguration.h"

@implementation DAAutomotiveFileCreator

@synthesize delegate;

- (void)createFile:(DAFileBase *)newFile {
	selectedFile = newFile;
	
	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"FileNumber",
				  [[NSMutableString alloc] initWithString:@""], @"RequestNumber",
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<CreateFile xmlns=\"http://tempuri.org/\">\n"
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
							 "</CreateFile>\n"
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
							 [[DAConfiguration settings] webserviceToken]];
	
	NSURL *wsUrl = [NSURL URLWithString:[[DAConfiguration settings] WS_MONDIAL_URL]];
	
	//NSLog(@"File webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"File soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/CreateFile" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else {
		//NSLog(@"File error: wsConnection is NULL");
		if ([delegate respondsToSelector:@selector(automotiveFileCreator:didFailWithError:)])
			[delegate automotiveFileCreator:self didFailWithError:nil];
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
	
	if ([error code] == -1009) {
		if ([delegate respondsToSelector:@selector(automotiveFileCreatorDidFailWithNoInternetConnection:)])
			[delegate automotiveFileCreatorDidFailWithNoInternetConnection:self];
	}
	else {
		if ([delegate respondsToSelector:@selector(automotiveFileCreator:didFailWithError:)])
			[delegate automotiveFileCreator:self didFailWithError:nil];
	}
	
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
	if([elementName isEqualToString:@"FileNumber"] || [elementName isEqualToString:@"RequestNumber"]) 
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
	if([elementName isEqualToString:@"FileNumber"] || [elementName isEqualToString:@"RequestNumber"]) {
		
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"CreateFileResult"]) {
		recordEnabled = NO;
		
		//NSLog(@"File FileNumber: %@", [wsResults objectForKey:@"FileNumber"]);
		//NSLog(@"File RequestNumber: %@", [wsResults objectForKey:@"RequestNumber"]);
		
		selectedFile.fileNumber = [wsResults objectForKey:@"FileNumber"];
		selectedFile.requestNumber = [wsResults objectForKey:@"RequestNumber"];
		
		if ([delegate respondsToSelector:@selector(automotiveFileCreator:didCreateFile:request:newFile:)])
			[delegate automotiveFileCreator:self 
							  didCreateFile:[wsResults objectForKey:@"FileNumber"] 
									  request:[wsResults objectForKey:@"RequestNumber"] 
									  newFile:selectedFile];	

	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		
		if ([delegate respondsToSelector:@selector(automotiveFileCreator:didFailWithError:)])
			[delegate automotiveFileCreator:self didFailWithError:nil];
	}
}

@end
