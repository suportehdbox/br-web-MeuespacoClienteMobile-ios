//
//  RepairNetworkWS.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 06/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAAccreditedGaragesManager.h"
#import <CoreLocation/CoreLocation.h>
#import "DAConfiguration.h"
#import "DAContact.h"
#import "DAAddress.h"
#import "DAPhone.h"

@implementation DAAccreditedGaragesManager

@synthesize delegate;

- (void)findAccreditedGaragesWithClientID:(int)clientID withCoordinate:(CLLocationCoordinate2D)coordinate {
	selectedClientID = clientID;

	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	recordsFound = NO;
	errorsFound = NO;
	
	garages = [[NSMutableArray alloc] init];
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"ProviderCode",
				  [[NSMutableString alloc] initWithString:@""], @"GarageName",
				  [[NSMutableString alloc] initWithString:@""], @"StreetName",
				  [[NSMutableString alloc] initWithString:@""], @"HouseNumber",
				  [[NSMutableString alloc] initWithString:@""], @"District",
				  [[NSMutableString alloc] initWithString:@""], @"City",
				  [[NSMutableString alloc] initWithString:@""], @"State",
				  [[NSMutableString alloc] initWithString:@""], @"Latitude",
				  [[NSMutableString alloc] initWithString:@""], @"Longitude",
				  [[NSMutableString alloc] initWithString:@""], @"Distance",
				  [[NSMutableString alloc] initWithString:@""], @"AreaCode",
				  [[NSMutableString alloc] initWithString:@""], @"PhoneNumber",
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<ListAccreditedEstablishment xmlns=\"http://tempuri.org/\">\n"
							 "<latitude>%.6f</latitude>\n"
							 "<longitude>%.6f</longitude>\n"
							 "<clientID>%d</clientID>\n"
							 "<token>%@</token>\n"
							 "</ListAccreditedEstablishment>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>", 
							 coordinate.latitude, 
							 coordinate.longitude, 
							 clientID,
							 [[DAConfiguration settings] webserviceToken]];
	
	NSURL *wsUrl = [NSURL URLWithString:[[DAConfiguration settings] automotiveWebServiceURL]];
	
	NSLog(@"GetNearestAutoCenter webServiceUrl:%@", [wsUrl absoluteString]);
	NSLog(@"GetNearestAutoCenter soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/ListAccreditedEstablishment" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"GetNearestAutoCenter error: wsConnection is NULL");
		//TODO: send delegate message
		if ([delegate respondsToSelector:@selector(accreditedGaragesManager:didFailWithError:)])
			[delegate accreditedGaragesManager:self didFailWithError:nil];
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
	//NSLog(@"GetNearestAutoCenter error: %@", [error description]);
	
	if ([error code] == -1009) {
		if ([delegate respondsToSelector:@selector(accreditedGaragesManagerDidFailWithNoInternetConnection:)])
			[delegate accreditedGaragesManagerDidFailWithNoInternetConnection:self];
	}
	else {
		if ([delegate respondsToSelector:@selector(accreditedGaragesManager:didFailWithError:)])
			[delegate accreditedGaragesManager:self didFailWithError:nil];
	}
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"GetNearestAutoCenter Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	NSLog(@"GetNearestAutoCenter XML:\n%@", wsXML);
	
	
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

	if ([delegate respondsToSelector:@selector(accreditedGaragesManager:didFailWithError:)])
		[delegate accreditedGaragesManager:self didFailWithError:parseError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {

	if ([delegate respondsToSelector:@selector(accreditedGaragesManager:didFailWithError:)])
		[delegate accreditedGaragesManager:self didFailWithError:validationError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
	attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"ProviderCode"] || [elementName isEqualToString:@"GarageName"] ||
	   [elementName isEqualToString:@"AreaCode"] || [elementName isEqualToString:@"StreetName"] ||
	   [elementName isEqualToString:@"HouseNumber"] || [elementName isEqualToString:@"District"] ||
	   [elementName isEqualToString:@"City"] || [elementName isEqualToString:@"State"] ||
	   [elementName isEqualToString:@"Latitude"] || [elementName isEqualToString:@"Longitude"] ||
	   [elementName isEqualToString:@"Distance"] || [elementName isEqualToString:@"PhoneNumber"]) 
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
		if ([delegate respondsToSelector:@selector(accreditedGaragesManagerDidNotFindAccreditedGarages:)])
			[delegate accreditedGaragesManagerDidNotFindAccreditedGarages:self];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"ProviderCode"] || [elementName isEqualToString:@"GarageName"] ||
	   [elementName isEqualToString:@"AreaCode"] || [elementName isEqualToString:@"StreetName"] ||
	   [elementName isEqualToString:@"HouseNumber"] || [elementName isEqualToString:@"District"] ||
	   [elementName isEqualToString:@"City"] || [elementName isEqualToString:@"State"] ||
	   [elementName isEqualToString:@"Latitude"] || [elementName isEqualToString:@"Longitude"] ||
	   [elementName isEqualToString:@"Distance"] || [elementName isEqualToString:@"PhoneNumber"]) {
		
		recordsFound = YES;
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"AccreditedGarage"]) {
		recordEnabled = NO;
		
		//NSLog(@"ProviderCode: %@", [wsResults objectForKey:@"ProviderCode"]);
		//NSLog(@"GarageName:  %@", [wsResults objectForKey:@"GarageName"]);
		//NSLog(@"StreetName:  %@", [wsResults objectForKey:@"StreetName"]);
		//NSLog(@"HouseNumber: %@", [wsResults objectForKey:@"HouseNumber"]);
		//NSLog(@"District:    %@", [wsResults objectForKey:@"District"]);
		//NSLog(@"City:        %@", [wsResults objectForKey:@"City"]);
		//NSLog(@"State:       %@", [wsResults objectForKey:@"State"]);
		//NSLog(@"Latitude:    %@", [wsResults objectForKey:@"Latitude"]);
		//NSLog(@"Longitude:   %@", [wsResults objectForKey:@"Longitude"]);
		//NSLog(@"Distance:    %@", [wsResults objectForKey:@"Distance"]);
		//NSLog(@"AreaCode:    %@", [wsResults objectForKey:@"AreaCode"]);
		//NSLog(@"PhoneNumber: %@", [wsResults objectForKey:@"PhoneNumber"]);
		
		CLLocationCoordinate2D garageCoordinate;
		garageCoordinate.latitude = [[wsResults objectForKey:@"Latitude"] doubleValue];
		garageCoordinate.longitude = [[wsResults objectForKey:@"Longitude"] doubleValue];
		
		DAAddress *address = [[DAAddress alloc] initWithStreet:[wsResults objectForKey:@"StreetName"] 
														number:[wsResults objectForKey:@"HouseNumber"] 
													  district:nil 
														  city:[wsResults objectForKey:@"City"] 
														 state:[wsResults objectForKey:@"State"] 
													coordinate:garageCoordinate];
		
		DAContact *garage = [[DAContact alloc] init];
		garage.name = [wsResults objectForKey:@"GarageName"];
		garage.address = address;
		garage.businessPhone = [[DAPhone alloc] initWithAreCodeAndNumberString:[wsResults objectForKey:@"PhoneNumber"]];
		//garage.phoneNumber = [wsResults objectForKey:@"PhoneNumber"];
		//garage.distanceFromYou = [[wsResults objectForKey:@"Distance"] doubleValue];
		
		[garages addObject:garage];

	}
	else if ([elementName isEqualToString:@"ListAccreditedEstablishmentResponse"]) {
		recordEnabled = NO;

		if ([garages count] > 0) 
			if ([delegate respondsToSelector:@selector(accreditedGaragesManager:didFindAccreditedGarages:)])
				[delegate accreditedGaragesManager:self didFindAccreditedGarages:garages];
		else
			if ([delegate respondsToSelector:@selector(accreditedGaragesManagerDidNotFindAccreditedGarages:)])
				[delegate accreditedGaragesManagerDidNotFindAccreditedGarages:self];	

			
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		errorsFound = YES;
		if ([delegate respondsToSelector:@selector(accreditedGaragesManager:didFailWithError:)])
			[delegate accreditedGaragesManager:self didFailWithError:nil];
	} 
}

@end
