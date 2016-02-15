//
//  DAPropertyPolicyFindWS.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPropertyPolicyFindWS.h"
#import "DAAddress.h"
#import "DAPropertyPolicy.h"

@implementation DAPropertyPolicyFindWS

- (void)findPolicyWithPolicyKey:(NSString *)policyKey userDocument:(NSString *)userDocument {
	[super findPolicyWithPolicyKey:policyKey userDocument:userDocument];
	
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
				  [[NSMutableString alloc] initWithString:@""], @"StreetName",
				  [[NSMutableString alloc] initWithString:@""], @"HouseNumber",
				  [[NSMutableString alloc] initWithString:@""], @"District",
				  [[NSMutableString alloc] initWithString:@""], @"Complement",
				  [[NSMutableString alloc] initWithString:@""], @"City",
				  [[NSMutableString alloc] initWithString:@""], @"State",
				  [[NSMutableString alloc] initWithString:@""], @"Zipcode",
				  [[NSMutableString alloc] initWithString:@""], @"ResultCode",
				  [[NSMutableString alloc] initWithString:@""], @"ErrorMessage",				  
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<GetPolicy xmlns=\"http://tempuri.org/\">\n"
							 "<zipcode>%@</zipcode>\n"
							 "<document>%@</document>\n"
							 "<clientID>%d</clientID>\n"
							 "<token>%@</token>\n"
							 "</GetPolicy>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>", 
							 policyKey, 
							 userDocument, 
							 [DAConfiguration settings].applicationClient.clientID,
							 [DAConfiguration settings].webserviceToken];
	
	NSURL *wsUrl = [NSURL URLWithString:[DAConfiguration settings].propertyWebServiceURL];
	
	//NSLog(@"Contract webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"Contract soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40.0];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/GetPolicy" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
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
	
	[self didFailWithErrorMessage:[error localizedDescription]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"Contract Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"Contract XML:\n%@", wsXML);
	
	
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
	attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"PolicyID"] || [elementName isEqualToString:@"InsuredName"] ||
	   [elementName isEqualToString:@"ContractStartDate"] || [elementName isEqualToString:@"ContractEndDate"] ||
	   [elementName isEqualToString:@"ActiveStatus"] || [elementName isEqualToString:@"StreetName"] ||
	   [elementName isEqualToString:@"HouseNumber"] || [elementName isEqualToString:@"District"] ||
	   [elementName isEqualToString:@"Complement"] || [elementName isEqualToString:@"City"] ||
	   [elementName isEqualToString:@"State"] || [elementName isEqualToString:@"Latitude"] ||
	   [elementName isEqualToString:@"Longitude"] || 
	   [elementName isEqualToString:@"ResultCode"] || [elementName isEqualToString:@"ErrorMessage"]) 
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
		[self didFindPolicy:nil];
	}
}



-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"PolicyID"] || [elementName isEqualToString:@"InsuredName"] ||
	   [elementName isEqualToString:@"ContractStartDate"] || [elementName isEqualToString:@"ContractEndDate"] ||
	   [elementName isEqualToString:@"ActiveStatus"] || [elementName isEqualToString:@"StreetName"] ||
	   [elementName isEqualToString:@"HouseNumber"] || [elementName isEqualToString:@"District"] ||
	   [elementName isEqualToString:@"Complement"] || [elementName isEqualToString:@"City"] ||
	   [elementName isEqualToString:@"State"] || [elementName isEqualToString:@"Latitude"] ||
	   [elementName isEqualToString:@"Longitude"] || 
	   [elementName isEqualToString:@"ResultCode"] || [elementName isEqualToString:@"ErrorMessage"]) {
		
		recordsFound = YES;
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"GetPolicyResult"]) {
		recordEnabled = NO;
		
		//NSLog(@"PolicyID: %@", [wsResults objectForKey:@"PolicyID"]);
		//NSLog(@"InsuredName: %@", [wsResults objectForKey:@"InsuredName"]);
		//NSLog(@"ContractStartDate: %@", [wsResults objectForKey:@"ContractStartDate"]);
		//NSLog(@"ContractEndDate: %@", [wsResults objectForKey:@"ContractEndDate"]);
		//NSLog(@"ActiveStatus: %@", [wsResults objectForKey:@"ActiveStatus"]);
		//NSLog(@"StreetName: %@", [wsResults objectForKey:@"StreetName"]);
		//NSLog(@"HouseNumber: %@", [wsResults objectForKey:@"HouseNumber"]);
		//NSLog(@"District: %@", [wsResults objectForKey:@"District"]);
		//NSLog(@"Complement: %@", [wsResults objectForKey:@"Complement"]);
		//NSLog(@"City: %@", [wsResults objectForKey:@"City"]);
		//NSLog(@"State: %@", [wsResults objectForKey:@"State"]);
		//NSLog(@"Latitude: %@", [wsResults objectForKey:@"Latitude"]);
		//NSLog(@"Longitude: %@", [wsResults objectForKey:@"Longitude"]);
		//NSLog(@"ResultCode: %@", [wsResults objectForKey:@"ResultCode"]);
		//NSLog(@"ErrorMessage: %@", [wsResults objectForKey:@"ErrorMessage"]);		

		DAPropertyPolicy *policy = nil;
		
		NSString *resultCode = [wsResults objectForKey:@"ResultCode"];
		if ([resultCode isEqualToString:@"0"]) {
			
			policy = [[DAPropertyPolicy alloc] init];
			policy.policyID = [wsResults objectForKey:@"PolicyID"];
			policy.customerName = [wsResults objectForKey:@"InsuredName"];
			
			CLLocationCoordinate2D coordinate;
			
			DAAddress *address = [[DAAddress alloc] initWithStreet:[wsResults objectForKey:@"StreetName"] 
															number:[wsResults objectForKey:@"HouseNumber"] 
														  district:[wsResults objectForKey:@"District"] 
															  city:[wsResults objectForKey:@"City"] 
															 state:[wsResults objectForKey:@"State"] 
														coordinate:coordinate];
			
			policy.address = address;
		}
		
		[self didFindPolicy:policy];
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		errorsFound = YES;
		[self didFailWithErrorMessage:DALocalizedString(@"UnknownError", nil)];
		
	}
}


@end
