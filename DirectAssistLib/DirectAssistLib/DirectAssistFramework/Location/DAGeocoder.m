//
//  DAGeocoder.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 22/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAGeocoder.h"
#import "DAAddress.h"

@implementation DAGeocoder

@synthesize delegate;

- (void)searchWithStreet:(NSString *)streetName city:(NSString *)city {
	[self internalSearchWithStreet:streetName houseNumber:@"" city:city state:@"" zipcode:@""];
}

- (void)searchWithZipcode:(NSString *)zipcode {
	[self internalSearchWithStreet:@"" houseNumber:@"" city:@"" state:@"" zipcode:zipcode];
}

- (void)searchWithAddress:(DAAddress *)address {
	[self internalSearchWithStreet:address.streetName 
					   houseNumber:address.houseNumber 
							  city:address.city 
							 state:address.state 
						   zipcode:@""];
}

- (void)internalSearchWithStreet:(NSString *)streetName 
					 houseNumber:(NSString *)houseNumber
							city:(NSString *)city 
						   state:(NSString *)state
						 zipcode:(NSString *)zipcode {
	
	soapResults = [[NSMutableString alloc] init];
	addresses = [[NSMutableArray alloc] init];
	recordEnabled = NO;
	recordsFound = NO;
	errorsFound = NO;
	
	geocodeResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					   [[NSMutableString alloc] initWithString:@""], @"street",
					   [[NSMutableString alloc] initWithString:@""], @"houseNumber",
					   [[NSMutableString alloc] initWithString:@""], @"zip",
					   [[NSMutableString alloc] initWithString:@""], @"district",
					   [[NSMutableString alloc] initWithString:@""], @"name",
					   [[NSMutableString alloc] initWithString:@""], @"state",
					   [[NSMutableString alloc] initWithString:@""], @"x",
					   [[NSMutableString alloc] initWithString:@""], @"y",
					   [[NSMutableString alloc] initWithString:@""], @"recordCount",
					   nil];
	
	NSURL *wsUrl = [NSURL URLWithString:@"http://webservices.maplink3.com.br/webservices/v3/addressfinder/addressfinder.asmx"];
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<findAddress xmlns=\"http://webservices.maplink2.com.br\">\n"
							 "<address>\n"
							 "<street>%@</street>\n"
							 "<houseNumber>%@</houseNumber>\n"
							 "<zip>%@</zip>\n"
							 "<district></district>\n"
							 "<city>\n"
							 "<name>%@</name>\n"
							 "<state>%@</state>\n"
							 "</city>\n"
							 "</address>\n"
							 "<ao>\n"
							 "<matchType>1</matchType>\n"
							 "<usePhonetic>1</usePhonetic>\n"
							 "<searchType>2</searchType>\n"
							 "<resultRange>\n"
							 "<pageIndex>1</pageIndex>\n"
							 "<recordsPerPage>20</recordsPerPage>\n"
							 "</resultRange>\n"
							 "</ao>\n"
							 "<token>bw9hz0LHbWVH5nkgbCFKawZsf0BibMSpywjk</token>\n"
							 "</findAddress>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>", streetName, houseNumber, zipcode, city, state];
	
//	NSLog(@"Geocoder webServiceUrl:%@", [wsUrl absoluteString]);
//	NSLog(@"Geocoder soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://webservices.maplink2.com.br/findAddress" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"Geocoder error: wsConnection is NULL");
		if ([delegate respondsToSelector:@selector(geocoder:didFailWithError:)])
			[delegate geocoder:self didFailWithError:nil];
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
	//NSLog(@"Geocoder error: %@", [error description]);
	
	
	if ([error code] == -1009) {
		if ([delegate respondsToSelector:@selector(geocoderDidFailNoInternetConnection:)])
			[delegate geocoderDidFailNoInternetConnection:self];
	}
	else {
		if ([delegate respondsToSelector:@selector(geocoder:didFailWithError:)])
			[delegate geocoder:self didFailWithError:nil];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"Geocoder Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"Geocoder XML:\n%@", wsXML);
	
	
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	
	if ([delegate respondsToSelector:@selector(geocoder:didFailWithError:)])
		[delegate geocoder:self didFailWithError:parseError];
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {

	if ([delegate respondsToSelector:@selector(geocoder:didFailWithError:)])
		[delegate geocoder:self didFailWithError:validationError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"street"] || [elementName isEqualToString:@"houseNumber"] ||
	   [elementName isEqualToString:@"zip"] || [elementName isEqualToString:@"district"] ||
	   [elementName isEqualToString:@"name"] || [elementName isEqualToString:@"state"] ||
	   [elementName isEqualToString:@"x"] || [elementName isEqualToString:@"y"] || 
	   [elementName isEqualToString:@"recordCount"]) 
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
	if (!recordsFound && errorsFound) {
		if ([delegate respondsToSelector:@selector(geocoder:didFailWithError:)])
			[delegate geocoder:self didFailWithError:nil];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"street"] || [elementName isEqualToString:@"houseNumber"] ||
	   [elementName isEqualToString:@"zip"] || [elementName isEqualToString:@"district"] ||
	   [elementName isEqualToString:@"name"] || [elementName isEqualToString:@"state"] ||
	   [elementName isEqualToString:@"x"] || [elementName isEqualToString:@"y"] || 
	   [elementName isEqualToString:@"recordCount"]) {
		
		[geocodeResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
		recordsFound = YES;
	}
	else if ([elementName isEqualToString:@"AddressLocation"]) {
		recordEnabled = NO;
		
		//NSLog(@"Geocoder street: %@", [geocodeResults objectForKey:@"street"]);
		//NSLog(@"Geocoder houseNumber: %@", [geocodeResults objectForKey:@"houseNumber"]);
		//NSLog(@"Geocoder district: %@", [geocodeResults objectForKey:@"district"]);
		//NSLog(@"Geocoder zip: %@", [geocodeResults objectForKey:@"zip"]);
		//NSLog(@"Geocoder city: %@", [geocodeResults objectForKey:@"name"]);
		//NSLog(@"Geocoder state: %@", [geocodeResults objectForKey:@"state"]);
		//NSLog(@"Geocoder x: %@", [geocodeResults objectForKey:@"x"]);
		//NSLog(@"Geocoder y: %@", [geocodeResults objectForKey:@"y"]);
		
		
		DAAddress *address = [[DAAddress alloc] init];
		int recordCount = [[geocodeResults objectForKey:@"recordCount"] intValue];		
		if (recordCount > 0) {
		
		
			address.streetName = [geocodeResults objectForKey:@"street"];
			address.houseNumber = [geocodeResults objectForKey:@"houseNumber"];
			address.district = [geocodeResults objectForKey:@"district"];
			address.city = [geocodeResults objectForKey:@"name"];
			address.state = [geocodeResults objectForKey:@"state"];
			address.zipcode = [geocodeResults objectForKey:@"zip"];
			
			CLLocationCoordinate2D coordinate;
			coordinate.latitude = [[geocodeResults objectForKey:@"y"] doubleValue];
			coordinate.longitude = [[geocodeResults objectForKey:@"x"] doubleValue];
			address.coordinate = coordinate;
			
			[addresses addObject:address];
			
			recordsFound = YES;
		}
	}
	else if ([elementName isEqualToString:@"findAddressResult"]) {
		recordEnabled = NO;
		
		if ([delegate respondsToSelector:@selector(geocoder:didFindAddresses:)])
			[delegate geocoder:self didFindAddresses:addresses];


	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		
		errorsFound = YES;
		if ([delegate respondsToSelector:@selector(geocoder:didFailWithError:)])
			[delegate geocoder:self didFailWithError:nil];
	} 
}

@end
