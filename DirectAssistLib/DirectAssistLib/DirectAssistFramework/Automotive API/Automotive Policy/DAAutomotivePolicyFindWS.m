//
//  DAAutomotivePolicyFindWS.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/12/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAutomotivePolicyFindWS.h"
#import "DAAutomotivePolicy.h"

@implementation DAAutomotivePolicyFindWS

- (void)findPolicyWithPolicyKey:(NSString *)policyKey userDocument:(NSString *)userDocument {
	[super findPolicyWithPolicyKey:policyKey userDocument:userDocument];
	
	soapResults = [[NSMutableString alloc] init];
	
	recordEnabled = NO;
	recordsFound = NO;
	errorsFound = NO;
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"PolicyID",
				  [[NSMutableString alloc] initWithString:@""], @"ContractStartDate",
				  [[NSMutableString alloc] initWithString:@""], @"ContractEndDate",
				  [[NSMutableString alloc] initWithString:@""], @"InsuredName",
				  [[NSMutableString alloc] initWithString:@""], @"Model",
				  [[NSMutableString alloc] initWithString:@""], @"LicenseNumber",
				  [[NSMutableString alloc] initWithString:@""], @"VehicleYear",
				  [[NSMutableString alloc] initWithString:@""], @"Color",
				  [[NSMutableString alloc] initWithString:@""], @"GroupID",
				  [[NSMutableString alloc] initWithString:@""], @"ResultCode",
				  [[NSMutableString alloc] initWithString:@""], @"ErrorMessage",
				  nil];
	
    NSString *soapMessage;
    
    if ([DAConfiguration settings].applicationClient.clientID == 173) {
    
        soapMessage = [NSString stringWithFormat:
                       @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<GetPolicyByPolicy xmlns=\"http://tempuri.org/\">\n"
                       "<policyID>%@</policyID>\n"
                       "<clientID>%d</clientID>\n"
                       "<token>%@</token>\n"
                       "</GetPolicyByPolicy>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",
                       policyKey,  
                       [DAConfiguration settings].applicationClient.clientID,
                       [DAConfiguration settings].webserviceToken];
	} else {
        
        soapMessage = [NSString stringWithFormat:
                       @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<GetPolicy xmlns=\"http://tempuri.org/\">\n"
                       "<plate>%@</plate>\n"
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
        
    }
	NSURL *wsUrl = [NSURL URLWithString:[DAConfiguration settings].automotiveWebServiceURL];
	
	NSLog(@"Contract webServiceUrl:%@", [wsUrl absoluteString]);
	NSLog(@"Contract soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    if ([DAConfiguration settings].applicationClient.clientID == 173) {
        [wsRequest addValue: @"http://tempuri.org/GetPolicyByPolicy" forHTTPHeaderField:@"SOAPAction"];
    } else {
        [wsRequest addValue: @"http://tempuri.org/GetPolicy" forHTTPHeaderField:@"SOAPAction"];    
    }
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
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	NSLog(@"Contract XML:\n%@", wsXML);
	
	
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
	attributes: (NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"PolicyID"] || [elementName isEqualToString:@"ContractStartDate"] ||
	   [elementName isEqualToString:@"ContractEndDate"] || [elementName isEqualToString:@"InsuredName"] ||
	   [elementName isEqualToString:@"Model"] || [elementName isEqualToString:@"LicenseNumber"] ||
	   [elementName isEqualToString:@"VehicleYear"] || [elementName isEqualToString:@"Color"] ||
	   [elementName isEqualToString:@"GroupID"] ||
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
	if([elementName isEqualToString:@"PolicyID"] || [elementName isEqualToString:@"ContractStartDate"] ||
	   [elementName isEqualToString:@"ContractEndDate"] || [elementName isEqualToString:@"InsuredName"] ||
	   [elementName isEqualToString:@"Model"] || [elementName isEqualToString:@"LicenseNumber"] ||
	   [elementName isEqualToString:@"VehicleYear"] || [elementName isEqualToString:@"Color"] ||
	   [elementName isEqualToString:@"GroupID"] ||
	   [elementName isEqualToString:@"ResultCode"] || [elementName isEqualToString:@"ErrorMessage"]) {
		
		recordsFound = YES;
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"GetPolicyResult"]) {
		recordEnabled = NO;
		
		//NSLog(@"PolicyID          : %@", [wsResults objectForKey:@"PolicyID"]);
		//NSLog(@"ContractStartDate : %@", [wsResults objectForKey:@"ContractStartDate"]);
		//NSLog(@"ContractEndDate   : %@", [wsResults objectForKey:@"ContractEndDate"]);
		//NSLog(@"InsuredName       : %@", [wsResults objectForKey:@"InsuredName"]);
		//NSLog(@"Contract Model    : %@", [wsResults objectForKey:@"Model"]);
		//NSLog(@"Plate             : %@", [wsResults objectForKey:@"LicenseNumber"]);
		//NSLog(@"Year              : %@", [wsResults objectForKey:@"VehicleYear"]);
		//NSLog(@"Color             : %@", [wsResults objectForKey:@"Color"]);
		//NSLog(@"GroupID           : %@", [wsResults objectForKey:@"GroupID"]);
		//NSLog(@"ResultCode        : %@", [wsResults objectForKey:@"ResultCode"]);
		//NSLog(@"ErrorMessage      : %@", [wsResults objectForKey:@"ErrorMessage"]);		
		
		DAAutomotivePolicy *policy = nil;
		
		NSString *resultCode = [wsResults objectForKey:@"ResultCode"];
		if ([resultCode isEqualToString:@"0"]) {
			
			policy = [[DAAutomotivePolicy alloc] init];
			policy.policyID = [wsResults objectForKey:@"PolicyID"];
			policy.customerName =  [wsResults objectForKey:@"InsuredName"];
			policy.vehicleModel = [wsResults objectForKey:@"Model"];
			policy.vehiclePlate = [wsResults objectForKey:@"LicenseNumber"];
			policy.vehicleYear = [wsResults objectForKey:@"VehicleYear"];
			
			if (![[wsResults objectForKey:@"GroupID"] isEqualToString:@""]) {
				policy.groupID = [[wsResults objectForKey:@"GroupID"] intValue];
			}
		}	
		
		[self didFindPolicy:policy];
        
	} else if ([elementName isEqualToString:@"GetPolicyByPolicyResponse"]) {
		recordEnabled = NO;
		
		//NSLog(@"PolicyID          : %@", [wsResults objectForKey:@"PolicyID"]);
		//NSLog(@"ContractStartDate : %@", [wsResults objectForKey:@"ContractStartDate"]);
		//NSLog(@"ContractEndDate   : %@", [wsResults objectForKey:@"ContractEndDate"]);
		//NSLog(@"InsuredName       : %@", [wsResults objectForKey:@"InsuredName"]);
		//NSLog(@"Contract Model    : %@", [wsResults objectForKey:@"Model"]);
		//NSLog(@"Plate             : %@", [wsResults objectForKey:@"LicenseNumber"]);
		//NSLog(@"Year              : %@", [wsResults objectForKey:@"VehicleYear"]);
		//NSLog(@"Color             : %@", [wsResults objectForKey:@"Color"]);
		//NSLog(@"GroupID           : %@", [wsResults objectForKey:@"GroupID"]);
		//NSLog(@"ResultCode        : %@", [wsResults objectForKey:@"ResultCode"]);
		//NSLog(@"ErrorMessage      : %@", [wsResults objectForKey:@"ErrorMessage"]);
		
		DAAutomotivePolicy *policy = nil;
		
		NSString *resultCode = [wsResults objectForKey:@"ResultCode"];
		if ([resultCode isEqualToString:@"0"]) {
			
			policy = [[DAAutomotivePolicy alloc] init];
			policy.policyID = [wsResults objectForKey:@"PolicyID"];
			policy.customerName =  [wsResults objectForKey:@"InsuredName"];
			policy.vehicleModel = [wsResults objectForKey:@"Model"];
			policy.vehiclePlate = [wsResults objectForKey:@"LicenseNumber"];
			policy.vehicleYear = [wsResults objectForKey:@"VehicleYear"];
			
			if (![[wsResults objectForKey:@"GroupID"] isEqualToString:@""]) {
				policy.groupID = [[wsResults objectForKey:@"GroupID"] intValue];
			}
		}
		
		[self didFindPolicy:policy];
		
	
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		errorsFound = YES;
		[self didFailWithErrorMessage:DALocalizedString(@"UnknownError", nil)];
		
	}
}


@end
