//
//  DAReverseGeocoder.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 22/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAReverseGeocoder.h"
#import "DAAddress.h"

@implementation DAReverseGeocoder

@synthesize delegate;

- (id)initWithLocation:(CLLocation *)location {
	if (self = [super init]) {
		locationToGeocode = location;
	}
	return self;
}

- (void)start {
	soapResults = [[NSMutableString alloc] init];
	resultValues = [[NSMutableArray alloc] initWithCapacity:4];
	recordEnabled = NO;
	recordsFound = NO;
	errorsFound = NO;
	
	geocodeResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
						  [[NSMutableString alloc] initWithString:@""], @"street",
						  [[NSMutableString alloc] initWithString:@""], @"houseNumber",
						  [[NSMutableString alloc] initWithString:@""], @"name",
						  [[NSMutableString alloc] initWithString:@""], @"district",
						  [[NSMutableString alloc] initWithString:@""], @"state",
							[[NSMutableString alloc] initWithString:@""], @"x",
							[[NSMutableString alloc] initWithString:@""], @"y",
						  nil];
	
	NSURL *wsUrl = [NSURL URLWithString:@"http://webservices.maplink3.com.br/webservices/v3/addressfinder/addressfinder.asmx"];
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<getAddress xmlns=\"http://webservices.maplink2.com.br\">\n"
							 "<point>\n"
							 "<x>%f</x>\n"
							 "<y>%f</y>\n"
							 "</point>\n"
							 "<token>bw9hz0LHbWVH5nkgbCFKawZsf0BibMSpywjk</token>\n"
							 "<tolerance>1</tolerance>\n"
							 "</getAddress>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>", locationToGeocode.coordinate.longitude, locationToGeocode.coordinate.latitude];
	
	//NSLog(@"LocateMeGeoCode webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"LocateMeGeoCode soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://webservices.maplink2.com.br/getAddress" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"LocateMeGeoCode error: wsConnection is NULL");
		if ([delegate respondsToSelector:@selector(reverseGeocoder:didFailWithError:)])
			[delegate reverseGeocoder:self didFailWithError:nil];
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
	//NSLog(@"LocateMeGeoCode error: %@", [error description]);
	
	
	if ([error code] == -1009) {
		if ([delegate respondsToSelector:@selector(reverseGeocoderDidFailNoInternetConnection:)])
			[delegate reverseGeocoderDidFailNoInternetConnection:self];
	}
	else {
		if ([delegate respondsToSelector:@selector(reverseGeocoder:didFailWithError:)])
			[delegate reverseGeocoder:self didFailWithError:nil];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"LocateMeGeoCode Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"LocateMeGeoCode XML:\n%@", wsXML);
	
	
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"street"] || [elementName isEqualToString:@"name"] ||
	   [elementName isEqualToString:@"state"] || [elementName isEqualToString:@"houseNumber"] ||
	   [elementName isEqualToString:@"x"] || [elementName isEqualToString:@"y"] ||
	   [elementName isEqualToString:@"district"]) 
		
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
		if ([delegate respondsToSelector:@selector(reverseGeocoder:didFailWithError:)])
			[delegate reverseGeocoder:self didFailWithError:nil];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"street"] || [elementName isEqualToString:@"name"] ||
	   [elementName isEqualToString:@"state"] || [elementName isEqualToString:@"houseNumber"] ||
	   [elementName isEqualToString:@"x"] || [elementName isEqualToString:@"y"] ||
	   [elementName isEqualToString:@"district"]) {
		[geocodeResults setObject:soapResults forKey:elementName];
		[resultValues addObject:soapResults];
		soapResults = [[NSMutableString alloc] init]; 
		recordsFound = YES;
	}
	else if ([elementName isEqualToString:@"getAddressResult"]) {
		recordEnabled = NO;
		
		//NSLog(@"LocateMeGeoCode street: %@", [geocodeResults objectForKey:@"street"]);
		//NSLog(@"LocateMeGeoCode houseNumber: %@", [geocodeResults objectForKey:@"houseNumber"]);
		//NSLog(@"LocateMeGeoCode district: %@", [geocodeResults objectForKey:@"district"]);
		//NSLog(@"LocateMeGeoCode city: %@", [geocodeResults objectForKey:@"name"]);
		//NSLog(@"LocateMeGeoCode state: %@", [geocodeResults objectForKey:@"state"]);
		//NSLog(@"LocateMeGeoCode latitude: %@", [geocodeResults objectForKey:@"y"]);
		//NSLog(@"LocateMeGeoCode longitude: %@", [geocodeResults objectForKey:@"x"]);

		DAAddress *address = nil;
		
		if (![[geocodeResults objectForKey:@"street"] isEqualToString:@""]) {
				  
				  address = [[DAAddress alloc] init];
				  address.streetName = [geocodeResults objectForKey:@"street"];
				  address.houseNumber = [geocodeResults objectForKey:@"houseNumber"];
				  address.district = [geocodeResults objectForKey:@"district"];
				  
			
			if ([[geocodeResults objectForKey:@"name"] isEqualToString:@""] &&
				[[geocodeResults objectForKey:@"state"] isEqualToString:@"DF"]) {
				
				address.city = @"Brasília";
			}
			else {
				
				address.city = [geocodeResults objectForKey:@"name"];
			}
			
			address.state = [geocodeResults objectForKey:@"state"];
			
			CLLocationCoordinate2D coordinate;
			coordinate.latitude = [[geocodeResults objectForKey:@"y"] doubleValue];
			coordinate.longitude = [[geocodeResults objectForKey:@"x"] doubleValue];		
			address.coordinate = coordinate;			
		}
			  
		if ([delegate respondsToSelector:@selector(reverseGeocoder:didFindAddress:)])
			[delegate reverseGeocoder:self didFindAddress:address];
		
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		
		errorsFound = YES;
		if ([delegate respondsToSelector:@selector(reverseGeocoder:didFailWithError:)])
			[delegate reverseGeocoder:self didFailWithError:nil];
	} 
}

@end
