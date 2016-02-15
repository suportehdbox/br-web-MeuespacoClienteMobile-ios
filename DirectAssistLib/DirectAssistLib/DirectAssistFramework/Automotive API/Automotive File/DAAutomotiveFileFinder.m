//
//  DAAutomotiveFileFinder.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 14/02/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAAutomotiveFileFinder.h"
#import "DAAutomotiveFile.h"
#import "DAConfiguration.h"

@implementation DAAutomotiveFileFinder

@synthesize delegate;

- (void)findFilesWithPolicyID:(NSString *)policyID {
	
	selectedPolicyID = policyID;
	
	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	recordsFound = NO;
	errorsFound = NO;
	
	files = [[NSMutableArray alloc] init];
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"FileNumber",
				  [[NSMutableString alloc] initWithString:@""], @"ContractNumber",
				  [[NSMutableString alloc] initWithString:@""], @"CreationDate",
				  [[NSMutableString alloc] initWithString:@""], @"CreationDateParse",
				  [[NSMutableString alloc] initWithString:@""], @"ServiceRequest",
				  [[NSMutableString alloc] initWithString:@""], @"SpecialityService",				  
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<GetSmartPhoneFiles xmlns=\"http://tempuri.org/\">\n"
							 "<contractNumber>%@</contractNumber>\n"
							 "<token>%@</token>\n"
							 "</GetSmartPhoneFiles>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>\n", 
							 policyID,
							 [[DAConfiguration settings] webserviceToken]];
	
	NSURL *wsUrl = [NSURL URLWithString:[[DAConfiguration settings] WS_MONDIAL_URL]];
	
	//NSLog(@"GetSmartPhoneFiles webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"GetSmartPhoneFiles soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/GetSmartPhoneFiles" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"GetSmartPhoneFiles error: wsConnection is NULL");
		
		if ([delegate respondsToSelector:@selector(automotiveFileFinder:didFailWithError:)])
			[delegate automotiveFileFinder:self didFailWithError:nil];	
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
	//NSLog(@"GetSmartPhoneFiles error: %@", [error description]);
	
	if ([error code] == -1009) {
		if ([delegate respondsToSelector:@selector(automotiveFileFinderDidFailWithNoInternetConnection:)])
			[delegate automotiveFileFinderDidFailWithNoInternetConnection:self];
	} 
	else {
		if ([delegate respondsToSelector:@selector(automotiveFileFinder:didFailWithError:)])
			[delegate automotiveFileFinder:self didFailWithError:nil];	
	}
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"GetSmartPhoneFiles Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"GetSmartPhoneFiles XML:\n%@", wsXML);
	
	if(xmlParser) {
		xmlParser = nil;
	}
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
	attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"FileNumber"] || [elementName isEqualToString:@"ContractNumber"] ||
	   [elementName isEqualToString:@"CreationDateParse"] || [elementName isEqualToString:@"ServiceRequest"] ||
	   [elementName isEqualToString:@"SpecialityService"] || [elementName isEqualToString:@"CreationDate"]) 
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

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	//NSLog(@"parseErrorOccurred");
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {
	//NSLog(@"validationErrorOccurred");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if (!recordsFound && !errorsFound) {
		if ([delegate respondsToSelector:@selector(automotiveFileFinderDidNotFindFiles:)])
			[delegate automotiveFileFinderDidNotFindFiles:self];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"FileNumber"] || [elementName isEqualToString:@"ContractNumber"] ||
	   [elementName isEqualToString:@"CreationDateParse"] || [elementName isEqualToString:@"ServiceRequest"] ||
	   [elementName isEqualToString:@"SpecialityService"] || [elementName isEqualToString:@"CreationDate"]) {
		recordsFound = YES;
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"SmartPhoneFile"]) {
		recordEnabled = NO;
		
		//NSLog(@"GetSmartPhoneFiles FileNumber: %@", [wsResults objectForKey:@"FileNumber"]);
		//NSLog(@"GetSmartPhoneFiles ContractNumber: %@", [wsResults objectForKey:@"ContractNumber"]);
		//NSLog(@"GetSmartPhoneFiles CreationDate: %@", [wsResults objectForKey:@"CreationDate"]);
		//NSLog(@"GetSmartPhoneFiles CreationDateParse: %@", [wsResults objectForKey:@"CreationDateParse"]);
		//NSLog(@"GetSmartPhoneFiles ServiceRequest: %@", [wsResults objectForKey:@"ServiceRequest"]);
		//NSLog(@"GetSmartPhoneFiles SpecialityService: %@", [wsResults objectForKey:@"SpecialityService"]);
		
		DAAutomotiveFile *file = [[DAAutomotiveFile alloc] init];
		file.fileNumber = [wsResults objectForKey:@"FileNumber"];
		file.contractNumber = selectedPolicyID;
		
		NSString *date = [wsResults objectForKey:@"CreationDate"];
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
		
		file.creationDate = [formatter dateFromString:date];
		file.creationDateString = [wsResults objectForKey:@"CreationDate"];
		
		file.serviceCode = [wsResults objectForKey:@"ServiceRequest"];
		[files addObject:file];
	} else if ([elementName isEqualToString:@"GetSmartPhoneFilesResult"]) {
		if ([delegate respondsToSelector:@selector(automotiveFileFinder:didFindFiles:)])
			[delegate automotiveFileFinder:self didFindFiles:files];
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		
		errorsFound = YES;
		if ([delegate respondsToSelector:@selector(automotiveFileFinder:didFailWithError:)])
			[delegate automotiveFileFinder:self didFailWithError:nil];	
	} 	
}


@end




