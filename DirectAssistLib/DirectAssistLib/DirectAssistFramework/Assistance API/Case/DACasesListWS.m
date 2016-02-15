//
//  DACasesListWS.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DACasesListWS.h"
#import "DAFileBase.h"

@implementation DACasesListWS

@synthesize delegate;

- (void)listCasesWithAssistanceType:(DAAssistanceType)assistanceType {
	
	internalAssistanceType = assistanceType;
	
	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	recordsFound = NO;
	errorsFound = NO;
	
	cases = [[NSMutableArray alloc] init];
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"CaseNumber",
				  [[NSMutableString alloc] initWithString:@""], @"CreationDate",
				  [[NSMutableString alloc] initWithString:@""], @"LicenseNumber",
				  [[NSMutableString alloc] initWithString:@""], @"ResultCode",
				  [[NSMutableString alloc] initWithString:@""], @"ErrorMessage",				
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<ListCases xmlns=\"http://tempuri.org/\">\n"
							 "<deviceUID>%@</deviceUID>\n"
							 "<manufacturerID>%d</manufacturerID>\n"
							 "<clientID>%d</clientID>\n"
							 "<token>%@</token>\n"
							 "</ListCases>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>\n", 
							 [DADevice currentDevice].UID,
							 [DADevice currentDevice].manufacturerID,
							 [DAConfiguration settings].applicationClient.clientID,
							 [DAConfiguration settings].webserviceToken];
	
	NSString *webserviceURL;
	switch (assistanceType) {
		case kDAAssistanceTypeAutomotive:
			webserviceURL = [DAConfiguration settings].automotiveWebServiceURL;
			break;
		case kDAAssistanceTypeAutomaker:
//			webserviceURL = [DAConfiguration settings].automotiveWebServiceURL;
			webserviceURL = [DAConfiguration settings].automakerWebServiceURL;
			break;
		case kDAAssistanceTypeProperty:
			webserviceURL = [DAConfiguration settings].propertyWebServiceURL;
			break;
		default:
			break;
	}
	
	
	NSURL *wsUrl = [NSURL URLWithString:webserviceURL];
	
	//NSLog(@"ListCases webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"ListCases soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/ListCases" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"ListCases error: wsConnection is NULL");
		
		if ([delegate respondsToSelector:@selector(casesList:didFailWithError:)])
			[delegate casesList:self didFailWithError:DALocalizedString(@"UnknownError", nil)];	
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
	//NSLog(@"ListCases error: %@", [error description]);
	
	if ([delegate respondsToSelector:@selector(casesList:didFailWithError:)])
		[delegate casesList:self didFailWithError:[error localizedDescription]];	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"ListCases Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"ListCases XML:\n%@", wsXML);
	
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
	if([elementName isEqualToString:@"CaseNumber"] || [elementName isEqualToString:@"CreationDate"] ||
	   [elementName isEqualToString:@"LicenseNumber"] || [elementName isEqualToString:@"ResultCode"] ||
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

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

	if ([delegate respondsToSelector:@selector(casesList:didFailWithError:)])
		[delegate casesList:self didFailWithError:[parseError localizedDescription]];	
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {

	if ([delegate respondsToSelector:@selector(casesList:didFailWithError:)])
		[delegate casesList:self didFailWithError:[validError localizedDescription]];	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if (!recordsFound && !errorsFound) {
		if ([delegate respondsToSelector:@selector(casesList:didListCases:)])
			[delegate casesList:self didListCases:nil];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSString *caseElementName;
	switch (internalAssistanceType) {
		case kDAAssistanceTypeAutomotive:
		case kDAAssistanceTypeAutomaker:
			caseElementName = @"AutomotiveCase";
			break;
		case kDAAssistanceTypeProperty:
			caseElementName = @"Case";
			break;
		default:
			caseElementName = @"AutomotiveCase";
			break;
	}
	
	if([elementName isEqualToString:@"CaseNumber"] || [elementName isEqualToString:@"CreationDate"] ||
	   [elementName isEqualToString:@"LicenseNumber"] || [elementName isEqualToString:@"ResultCode"] ||
	   [elementName isEqualToString:@"ErrorMessage"]) {
		recordsFound = YES;
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:caseElementName]) {
		recordEnabled = NO;
		
		//NSLog(@"GetSmartPhoneFiles CaseNumber: %@", [wsResults objectForKey:@"CaseNumber"]);
		//NSLog(@"GetSmartPhoneFiles CreationDate: %@", [wsResults objectForKey:@"CreationDate"]);
		//NSLog(@"GetSmartPhoneFiles LicenseNumber: %@", [wsResults objectForKey:@"LicenseNumber"]);
		//NSLog(@"GetSmartPhoneFiles ResultCode: %@", [wsResults objectForKey:@"ResultCode"]);
		//NSLog(@"GetSmartPhoneFiles ErrorMessage: %@", [wsResults objectForKey:@"ErrorMessage"]);
		
		DAFileBase *caseObj = [[DAFileBase alloc] init];
		caseObj.fileNumber = [wsResults objectForKey:@"CaseNumber"];
		
		NSString *date = [wsResults objectForKey:@"CreationDate"];
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
		
		caseObj.creationDate = [formatter dateFromString:date];
		caseObj.creationDateString = [wsResults objectForKey:@"CreationDate"];
		[cases addObject:caseObj];
		
	} else if ([elementName isEqualToString:@"ListCasesResult"]) {
		if ([delegate respondsToSelector:@selector(casesList:didListCases:)])
			[delegate casesList:self didListCases:cases];
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		
		errorsFound = YES;
		if ([delegate respondsToSelector:@selector(casesList:didFailWithError:)])
			[delegate casesList:self didFailWithError:DALocalizedString(@"UnknownError", nil)];	
	} 	
}


@end
