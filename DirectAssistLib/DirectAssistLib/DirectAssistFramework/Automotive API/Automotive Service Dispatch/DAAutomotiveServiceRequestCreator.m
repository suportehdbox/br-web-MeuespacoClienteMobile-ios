//
//  DAAutomotiveServiceRequestCreator.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 29/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAAutomotiveServiceRequestCreator.h"
#import "DAFileBase.h"
#import "DAConfiguration.h"

@implementation DAAutomotiveServiceRequestCreator

@synthesize delegate;

- (void)createServiceRequest:(DAFileBase *)file {
	selectedFile = file;
	
	soapResults = [[NSMutableString alloc] init];
	recordEnabled = NO;
	
	wsResults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				  [[NSMutableString alloc] initWithString:@""], @"ResultCode",
				  [[NSMutableString alloc] initWithString:@""], @"ErrorMessage",				
				  nil];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<CreateServiceDispatch xmlns=\"http://tempuri.org/\">\n"
							 "<fileNumber>%@</fileNumber>\n"
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
							 "<reference>%@</reference>\n"
							 "<district>%@</district>\n"
							 "<scheduleStartDate>%@</scheduleStartDate>\n"
							 "<scheduleEndDate>%@</scheduleEndDate>\n"
							 "<token>%@</token>\n"
							 "</CreateServiceDispatch>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>", 
							 file.fileNumber,
							 file.contractNumber, 
							 file.phoneAreaCode,
							 file.phoneNumber,
							 file.fileCause,
							 file.serviceCode,
							 file.problemCode,
							 file.fileCity,
							 file.fileState,
							 file.streetName,
							 file.houseNumber,
							 file.latitude,
							 file.longitude,
							 (nil != file.addressDetail) ? file.addressDetail : @"",
							 file.district,
							 (file.scheduleBeginDate ? [dateFormatter stringFromDate:file.scheduleBeginDate] : @""),
							 (file.scheduleEndDate ? [dateFormatter stringFromDate:file.scheduleEndDate] : @""),
							 [[DAConfiguration settings] webserviceToken]];
	
	NSURL *wsUrl = [NSURL URLWithString:[DAConfiguration settings].directAssistWebServiceURL];
	
	//NSLog(@"CreateServiceRequest webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"CreateServiceRequest soapMessage:\n%@", soapMessage);
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/CreateServiceDispatch" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];
	
	if(wsConnection)
		wsData = [NSMutableData data];
	else
	{
		//NSLog(@"CreateServiceRequest error: wsConnection is NULL");
		if ([delegate respondsToSelector:@selector(automotiveServiceRequestCreator:didFailWithError:)])
			[delegate automotiveServiceRequestCreator:self didFailWithError:nil];
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
	//NSLog(@"CreateServiceRequest error: %@", [error description]);
	
	if ([error code] == -1009) {
		if ([delegate respondsToSelector:@selector(automotiveServiceRequestCreatorDidFailWithNoInternet:)])
			[delegate automotiveServiceRequestCreatorDidFailWithNoInternet:self];
	}
	else {
		if ([delegate respondsToSelector:@selector(automotiveServiceRequestCreator:didFailWithError:)])
			[delegate automotiveServiceRequestCreator:self didFailWithError:nil];	
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"CreateServiceRequest Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"CreateServiceRequest XML:\n%@", wsXML);
	
	
	xmlParser = [[NSXMLParser alloc] initWithData: wsData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
	attributes: (NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"ResultCode"] || [elementName isEqualToString:@"ErrorMessage"]) 
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
	if([elementName isEqualToString:@"ResultCode"] || [elementName isEqualToString:@"ErrorMessage"]) {
		
		[wsResults setObject:soapResults forKey:elementName];
		soapResults = [[NSMutableString alloc] init]; 
	}
	else if ([elementName isEqualToString:@"CreateServiceDispatchResult"]) {
		recordEnabled = NO;
		
		//NSLog(@"ResultCode:   %@", [wsResults objectForKey:@"ResultCode"]);
		//NSLog(@"ErrorMessage: %@", [wsResults objectForKey:@"ErrorMessage"]);
		
		NSString *resultCode = [wsResults objectForKey:@"ResultCode"];
		if ([resultCode isEqualToString:@"0"]) {
		
			if ([delegate respondsToSelector:@selector(automotiveServiceRequestCreator:didCreateServiceRequest:request:newFile:)])
				[delegate automotiveServiceRequestCreator:self
								  didCreateServiceRequest:selectedFile.fileNumber 
												  request:selectedFile.requestNumber 
												  newFile:selectedFile];	
		}
		else {
		
			//NSString *errorMessage = [wsResults objectForKey:@"ErrorMessage"];
			if ([delegate respondsToSelector:@selector(automotiveServiceRequestCreator:didFailWithError:)])
				[delegate automotiveServiceRequestCreator:self didFailWithError:nil];	
			
		}
		
	} else if ([elementName isEqualToString:@"soap:Fault"]) {
		
		if ([delegate respondsToSelector:@selector(automotiveServiceRequestCreator:didFailWithError:)])
			[delegate automotiveServiceRequestCreator:self didFailWithError:nil];	
	}
}

@end
