//
//  DAAutomakerPolicyListWS.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAutomakerPolicyListWS.h"
#import "DAAutomakerPolicy.h"
#import "DADevice.h"
#import "DAConfiguration.h"

@implementation DAAutomakerPolicyListWS

- (void)listPolicies {
	
	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	recordsFound = NO;
	errorsFound = NO;
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"PolicyID",
				  [[NSMutableString alloc] initWithString:@""], @"InsuredName",
				  [[NSMutableString alloc] initWithString:@""], @"ContractStartDate",
				  [[NSMutableString alloc] initWithString:@""], @"ContractEndDate",
				  [[NSMutableString alloc] initWithString:@""], @"ActiveStatus",
				  [[NSMutableString alloc] initWithString:@""], @"LicenseNumber",
				  [[NSMutableString alloc] initWithString:@""], @"Make",
				  [[NSMutableString alloc] initWithString:@""], @"Model",
				  [[NSMutableString alloc] initWithString:@""], @"Color",
				  [[NSMutableString alloc] initWithString:@""], @"ResultCode",
				  [[NSMutableString alloc] initWithString:@""], @"ErrorMessage",				  
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<ListPolicies xmlns=\"http://tempuri.org/\">\n"
							 "<deviceUID>%@</deviceUID>\n"
							 "<manufacturerID>%d</manufacturerID>\n"
							 "<clientID>%d</clientID>\n"
							 "<token>%@</token>\n"
							 "</ListPolicies>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>\n", 
							 [DADevice currentDevice].UID,
							 [DADevice currentDevice].manufacturerID,
							 [DAConfiguration settings].applicationClient.clientID,
							 [[DAConfiguration settings] webserviceToken]];
	
	NSURL *wsUrl = [NSURL URLWithString:[DAConfiguration settings].automakerWebServiceURL];
	
	NSLog(@"AutomotivePolicieList webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"AutomotivePolicieList soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/ListPolicies" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"AutomotivePolicieList error: wsConnection is NULL");
		
		[self didFailWithErrorMessage:DALocalizedString(@"UnknownError", nil)];	
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
	//NSLog(@"AutomotivePolicieList error: %@", [error description]);
	
	[self didFailWithErrorMessage:[error localizedDescription]];	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"AutomotivePolicieList Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"AutomotivePolicieList XML:\n%@", wsXML);
	
	if(xmlParser) {
		xmlParser = nil;
	}
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

	[self didFailWithErrorMessage:[parseError localizedDescription]];	
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {

	[self didFailWithErrorMessage:[validationError localizedDescription]];	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
	attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"PolicyID"] || [elementName isEqualToString:@"InsuredName"] ||
	   [elementName isEqualToString:@"ContractStartDate"] || [elementName isEqualToString:@"ContractEndDate"] ||
	   [elementName isEqualToString:@"ActiveStatus"] || [elementName isEqualToString:@"LicenseNumber"] ||
	   [elementName isEqualToString:@"Make"] || [elementName isEqualToString:@"Model"] ||
	   [elementName isEqualToString:@"Color"] || [elementName isEqualToString:@"ResultCode"] ||
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

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if (!recordsFound && !errorsFound) {
		[self didListPolicies:nil];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"PolicyID"] || [elementName isEqualToString:@"InsuredName"] ||
	   [elementName isEqualToString:@"ContractStartDate"] || [elementName isEqualToString:@"ContractEndDate"] ||
	   [elementName isEqualToString:@"ActiveStatus"] || [elementName isEqualToString:@"LicenseNumber"] ||
	   [elementName isEqualToString:@"Make"] || [elementName isEqualToString:@"Model"] ||
	   [elementName isEqualToString:@"Color"] || [elementName isEqualToString:@"ResultCode"] ||
	   [elementName isEqualToString:@"ErrorMessage"]) {
		recordsFound = YES;
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"AutomotivePolicy"]) {
		recordEnabled = NO;
		
		//NSLog(@"PolicyID: %@", [wsResults objectForKey:@"PolicyID"]);
		//NSLog(@"InsuredName: %@", [wsResults objectForKey:@"InsuredName"]);
		//NSLog(@"ContractStartDate: %@", [wsResults objectForKey:@"ContractStartDate"]);
		//NSLog(@"ContractEndDate: %@", [wsResults objectForKey:@"ContractEndDate"]);
		//NSLog(@"ActiveStatus: %@", [wsResults objectForKey:@"ActiveStatus"]);
		//NSLog(@"LicenseNumber: %@", [wsResults objectForKey:@"LicenseNumber"]);
		//NSLog(@"Make: %@", [wsResults objectForKey:@"Make"]);
		//NSLog(@"Model: %@", [wsResults objectForKey:@"Model"]);
		//NSLog(@"Color: %@", [wsResults objectForKey:@"Color"]);
		//NSLog(@"ResultCode: %@", [wsResults objectForKey:@"ResultCode"]);
		//NSLog(@"ErrorMessage: %@", [wsResults objectForKey:@"ErrorMessage"]);
		
		DAAutomakerPolicy *policy = [[DAAutomakerPolicy alloc] init];
		policy.policyID = [wsResults objectForKey:@"PolicyID"];
		policy.customerName = [wsResults objectForKey:@"InsuredName"];
		policy.vehicleModel = [wsResults objectForKey:@"Model"];
		policy.vehiclePlate = [wsResults objectForKey:@"LicenseNumber"];
		
		if (nil == policies)
			policies = [[NSMutableArray alloc] init];
		[policies addObject:policy];
		
	} else if ([elementName isEqualToString:@"ListPoliciesResult"]) {
		[self didListPolicies:policies];
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		
		errorsFound = YES;
		[self didFailWithErrorMessage:DALocalizedString(@"UnknownError", nil)];	
	} 	
}


@end
