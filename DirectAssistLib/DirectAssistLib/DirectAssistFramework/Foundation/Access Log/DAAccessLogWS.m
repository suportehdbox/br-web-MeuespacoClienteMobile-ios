//
//  DAAccessLogWS.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/23/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAccessLogWS.h"
#import "DADevice.h"
#import "DAConfiguration.h"
#import "DAWebServiceActionResult.h"
#import "DAUserLocation.h"

@implementation DAAccessLogWS

- (void)saveAccessLog:(DAWebServiceActionResult *)actionResult {
	
	NSString *soapMessage = [NSString stringWithFormat:							 
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<soap:Body>\n"
							 "<SaveAccessLog xmlns=\"http://tempuri.org/\">\n"
							 "<manufacturerID>%d</manufacturerID>\n"
							 "<deviceUID>%@</deviceUID>\n"
							 "<applicationID>%d</applicationID>\n"
							 "<applicationVersion>%0.2f</applicationVersion>\n"
							 "<actionCode>%d</actionCode>\n"
							 "<actionParameter>%@</actionParameter>\n"
							 "<actionResult>%d</actionResult>\n"
							 "<clientID>%d</clientID>\n"
							 "<latitude>%0.6f</latitude>\n"
							 "<longitude>%0.6f</longitude>\n"
							 "<token>%@</token>\n"
							 "</SaveAccessLog>\n"
							 "</soap:Body>\n"
							 "</soap:Envelope>",
							 [DADevice currentDevice].manufacturerID,
							 [DADevice currentDevice].UID,
							 [DAConfiguration settings].applicationID,
							 [DAConfiguration settings].applicationVersion,
							 actionResult.actionType,
							 actionResult.actionParameters,
							 actionResult.resultType,
							 [DAConfiguration settings].applicationClient.clientID,
							 [DAUserLocation currentLocation].coordinate.latitude,
							 [DAUserLocation currentLocation].coordinate.longitude,
							 [DAConfiguration settings].webserviceToken];
	
	NSURL *wsUrl = [NSURL URLWithString:[DAConfiguration settings].directAssistWebServiceURL];
	
	NSMutableURLRequest *wsRequest = [NSMutableURLRequest requestWithURL:wsUrl];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[wsRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[wsRequest addValue: @"http://tempuri.org/SaveAccessLog" forHTTPHeaderField:@"SOAPAction"];
	[wsRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[wsRequest setHTTPMethod:@"POST"];
	[wsRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *wsConnection = [[NSURLConnection alloc] initWithRequest:wsRequest delegate:self];

	//NSLog(@"SaveAccessLog webServiceUrl:%@", [wsUrl absoluteString]);
	//NSLog(@"SaveAccessLog soapMessage:\n%@", soapMessage);
	
	if(wsConnection)
		wsData = [NSMutableData data];
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
	//NSLog(@"SaveAccessLog error: %@", [error description]);
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"SaveAccessLog Received Bytes: %d", [wsData length]);
	
	NSString *wsXML = [[NSString alloc] initWithBytes: [wsData mutableBytes] length:[wsData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"SaveAccessLog XML:\n%@", wsXML);
	
}


@end
