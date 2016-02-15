//
//  ServiceDispatchWS.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 23/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAServiceDispatchFinder.h"
#import "DAServiceDispatch.h"
#import "DAConfiguration.h"

@implementation DAServiceDispatchFinder

@synthesize delegate;

- (void)getServiceDispatchWithFileNumber:(NSInteger)fileNumber {
	selectedFileNumber = fileNumber;
	
	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	errorsFound = NO;
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					   [[NSMutableString alloc] initWithString:@""], @"Dispatched",
					   [[NSMutableString alloc] initWithString:@""], @"DispatchDate",
					   [[NSMutableString alloc] initWithString:@""], @"DispatchChannel",
					   [[NSMutableString alloc] initWithString:@""], @"DispatchStatus",
					   [[NSMutableString alloc] initWithString:@""], @"ArrivalTime",
					   [[NSMutableString alloc] initWithString:@""], @"Latitude",
					   [[NSMutableString alloc] initWithString:@""], @"Longitude",
					   [[NSMutableString alloc] initWithString:@""], @"ProviderCode",
					   [[NSMutableString alloc] initWithString:@""], @"LicenseNumber",
				       [[NSMutableString alloc] initWithString:@""], @"Clientlatitude",
					   [[NSMutableString alloc] initWithString:@""], @"ClientLongitude",
					[[NSMutableString alloc] initWithString:@""], @"Scheduled",
					[[NSMutableString alloc] initWithString:@""], @"ScheduleStartDate",
					[[NSMutableString alloc] initWithString:@""], @"ScheduleEndDate",
				  nil];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<GetDispatchStatus xmlns=\"http://tempuri.org/\">\n"
							 "<caseNumber>%d</caseNumber>\n"
							 "<requestID>1</requestID>\n"
							 "<token>%@</token>\n"
							 "</GetDispatchStatus>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>\n", 
							 fileNumber,
							 [[DAConfiguration settings] webserviceToken]];
	
	NSURL *wsUrl = [NSURL URLWithString:[DAConfiguration settings].directAssistWebServiceURL];

	//NSLog(@"ServiceDispatch webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"ServiceDispatch soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/GetDispatchStatus" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"ServiceDispatch error: wsConnection is NULL");

		if ([delegate respondsToSelector:@selector(serviceDispatchFinder:didFailWithError:)])
			[delegate serviceDispatchFinder:self didFailWithError:nil];
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
	//NSLog(@"ServiceDispatch error: %@", [error description]);
	
	if ([error code] == -1009) {
		if ([delegate respondsToSelector:@selector(serviceDispatchFinderDidFailWithNoInternetConnection:)])
			[delegate serviceDispatchFinderDidFailWithNoInternetConnection:self];
	}
	else {
		if ([delegate respondsToSelector:@selector(serviceDispatchFinder:didFailWithError:)])
			[delegate serviceDispatchFinder:self didFailWithError:nil];	
	}
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"ServiceDispatch Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"ServiceDispatch XML:\n%@", wsXML);
	
	
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if (!recordsFound && !errorsFound) {
		if ([delegate respondsToSelector:@selector(serviceDispatchFinderDidFailWithNoResults:)])
			[delegate serviceDispatchFinderDidFailWithNoResults:self];
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
	attributes: (NSDictionary *)attributeDict
{	
	if([elementName isEqualToString:@"Dispatched"] || [elementName isEqualToString:@"DispatchDate"] ||
	   [elementName isEqualToString:@"DispatchChannel"] || [elementName isEqualToString:@"ArrivalTime"] ||
	   [elementName isEqualToString:@"Latitude"] || [elementName isEqualToString:@"Longitude"] ||
	   [elementName isEqualToString:@"ProviderCode"] || [elementName isEqualToString:@"DispatchStatus"] ||
	   [elementName isEqualToString:@"LicenseNumber"] || [elementName isEqualToString:@"Clientlatitude"] ||
	   [elementName isEqualToString:@"ClientLongitude"] || [elementName isEqualToString:@"Scheduled"] ||
		[elementName isEqualToString:@"ScheduleStartDate"] || [elementName isEqualToString:@"ScheduleEndDate"]) 		
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
	if([elementName isEqualToString:@"Dispatched"] || [elementName isEqualToString:@"DispatchDate"] ||
	   [elementName isEqualToString:@"DispatchChannel"] || [elementName isEqualToString:@"ArrivalTime"] ||
	   [elementName isEqualToString:@"Latitude"] || [elementName isEqualToString:@"Longitude"] ||
	   [elementName isEqualToString:@"ProviderCode"] || [elementName isEqualToString:@"DispatchStatus"] ||
	   [elementName isEqualToString:@"LicenseNumber"] || [elementName isEqualToString:@"Clientlatitude"] ||
	   [elementName isEqualToString:@"ClientLongitude"] || [elementName isEqualToString:@"Scheduled"] ||
	   [elementName isEqualToString:@"ScheduleStartDate"] || [elementName isEqualToString:@"ScheduleEndDate"]) {
		
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 

	}
	else if ([elementName isEqualToString:@"GetDispatchStatusResult"]) {
		recordEnabled = NO;
		
		//NSLog(@"Dispatched:        %@", [wsResults objectForKey:@"Dispatched"]);
		//NSLog(@"DispatchDate:      %@", [wsResults objectForKey:@"DispatchDate"]);
		//NSLog(@"DispatchChannel:   %@", [wsResults objectForKey:@"DispatchChannel"]);
		//NSLog(@"DispatchStatus:    %@", [wsResults objectForKey:@"DispatchStatus"]);
		//NSLog(@"ArrivalTime:       %@", [wsResults objectForKey:@"ArrivalTime"]);
		//NSLog(@"ProviderLatitude:  %@", [wsResults objectForKey:@"Latitude"]);
		//NSLog(@"ProviderLongitude: %@", [wsResults objectForKey:@"Longitude"]);
		//NSLog(@"ProviderCode:      %@", [wsResults objectForKey:@"ProviderCode"]);
		//NSLog(@"LicenseNumber:     %@", [wsResults objectForKey:@"LicenseNumber"]);
		//NSLog(@"Clientlatitude:    %@", [wsResults objectForKey:@"Clientlatitude"]);
		//NSLog(@"ClientLongitude:   %@", [wsResults objectForKey:@"ClientLongitude"]);
		//NSLog(@"Scheduled:         %@", [wsResults objectForKey:@"Scheduled"]);
		//NSLog(@"ScheduleStartDate: %@", [wsResults objectForKey:@"ScheduleStartDate"]);
		//NSLog(@"ScheduleEndDate:   %@", [wsResults objectForKey:@"ScheduleEndDate"]);
		
		
		DAServiceDispatch *dispatch = [[DAServiceDispatch alloc] init];
		
		dispatch.fileNumber = selectedFileNumber;
		dispatch.requestNumber = @"1";
		dispatch.dispatchStatus = [wsResults objectForKey:@"DispatchStatus"];
		dispatch.dispatchChannel = [wsResults objectForKey:@"DispatchChannel"];
		dispatch.arrivalTime = [wsResults objectForKey:@"ArrivalTime"];
		dispatch.providerLatitude = [wsResults objectForKey:@"Latitude"];		
		dispatch.providerLongitude = [wsResults objectForKey:@"Longitude"];
		dispatch.vehiclePlate = [wsResults objectForKey:@"LicenseNumber"];
		dispatch.clientLatitude = [wsResults objectForKey:@"Clientlatitude"];
		dispatch.clientLongitude = [wsResults objectForKey:@"ClientLongitude"];
		
		CLLocationCoordinate2D providerCoordinate;
		providerCoordinate.latitude = [[wsResults objectForKey:@"Latitude"] doubleValue];
		providerCoordinate.longitude = [[wsResults objectForKey:@"Longitude"] doubleValue];
		dispatch.providerCoordinate = providerCoordinate;

		CLLocationCoordinate2D clientCoordinate;
		clientCoordinate.latitude = [[wsResults objectForKey:@"Clientlatitude"] doubleValue];
		clientCoordinate.longitude = [[wsResults objectForKey:@"ClientLongitude"] doubleValue];
		dispatch.clientCoordinate = clientCoordinate;
		
		dispatch.isSchedule = [[wsResults objectForKey:@"Scheduled"] isEqualToString:@"1"];

		if (dispatch.isSchedule) {
		
			[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
			
			dispatch.scheduleBeginDate = [formatter dateFromString:[wsResults objectForKey:@"ScheduleStartDate"]];
			
			if (![[wsResults objectForKey:@"ScheduleEndDate"] isEqualToString:@""]) {

				dispatch.scheduleEndDate = [formatter dateFromString:[wsResults objectForKey:@"ScheduleEndDate"]];
			}
		}
		
		recordsFound = YES;
		
		if ([delegate respondsToSelector:@selector(serviceDispatchFinder:didFindServiceDispatch:)])
			[delegate serviceDispatchFinder:self didFindServiceDispatch:dispatch];
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
	
		errorsFound = YES;
		if ([delegate respondsToSelector:@selector(serviceDispatchFinder:didFailWithError:)])
			[delegate serviceDispatchFinder:self didFailWithError:nil];
	}
}

@end
