//
//  DAActionResultParser.m
//  ws
//
//  Created by Thiago Ramalho on 16/08/11.
//  Copyright 2011 Mondial Assistance. All rights reserved.
//

#import "DAWebServiceParser.h"

#define kDAParserDictionaryNodeKey @"DAParserDictionaryNodeKey"
#define kDAParserArrayNodeKey @"DAParserArrayNodeKey"
#define kDAParserNodeNameKey @"DAParserNodeNameKey"
#define kDAParserNodeTypeKey @"DAParserNodeTypeKey"


@implementation DAWebServiceParser

@synthesize delegate = _delegate;

- (id)init {
	self = [super init];
	if (self) {
		
	}
	
	return self;
	
}


#pragma mark -
#pragma mark Parser

- (void)parseWithXML:(NSString *)xml rootElementName:(NSString *)rootElementName nodes:(NSArray *)nodes {
	_rootElementName = rootElementName;
	_nodes = nodes;
	NSData	*data = [xml dataUsingEncoding:NSUTF8StringEncoding];
	
	_parser = [[NSXMLParser alloc] initWithData:data];
	_parser.delegate = self;
	[_parser parse];
}

+ (NSDictionary *)dictionaryNodeWithElementName: (NSString *)elementName {
	return [NSDictionary dictionaryWithObjectsAndKeys:elementName, kDAParserNodeNameKey, kDAParserDictionaryNodeKey, kDAParserNodeTypeKey, nil];
	
}


+ (NSDictionary *)arrayNodeWithElementName:(NSString *)elementName {
	return [NSDictionary dictionaryWithObjectsAndKeys:elementName, kDAParserNodeNameKey, kDAParserArrayNodeKey, kDAParserNodeTypeKey, nil];
}





#pragma mark -
#pragma mark NSXMLParserDelegate

// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"parserDidStartDocument");
}
// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"parserDidEndDocument");		
//	NSLog(@"%@", _rootNode);
	if ([_delegate respondsToSelector:@selector(webServiceParser:didFinishWithResult:)]) {
		[_delegate webServiceParser:self didFinishWithResult:_rootNode];
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	NSLog(@"didStartElement: elementName:%@ ", elementName);
	if ([elementName isEqualToString:_rootElementName]) {
		_elementText = [[NSMutableString alloc] init];
		_rootNode = [[NSMutableDictionary alloc] init];
		
	}
	else {
		BOOL isInNode = NO;
		
		for (NSDictionary *node in _nodes) {
			NSString *nodeElementName = [node objectForKey:kDAParserNodeNameKey];
			NSString *nodeTypeName = [node objectForKey:kDAParserNodeTypeKey];
			
			if ([elementName isEqualToString:nodeElementName]) {
				isInNode = YES;
				
				if ([nodeTypeName isEqualToString:kDAParserDictionaryNodeKey]) { //DICTIONARIO TRATAMENTO
					_canCollectCharacters = YES;
					_currentNode = [[NSMutableDictionary alloc] init];
					
				}
				else if ([nodeTypeName isEqualToString:kDAParserArrayNodeKey]) {
					_currentArrayNode = [[NSMutableArray alloc] init];
				}
				


				break;
			}
		}
		
		if (!isInNode) {
			_canCollectCharacters = YES;
		}
		
		
	}
	
	

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	NSLog(@"didEndElement: elementName:%@ ", elementName);
	if ([elementName isEqualToString:_rootElementName]) {

		
	}
	else {
		BOOL isInNode = NO;
		
		for (NSDictionary *node in _nodes) {
			NSString *nodeElementName = [node objectForKey:kDAParserNodeNameKey];
			NSString *nodeTypeName = [node objectForKey:kDAParserNodeTypeKey];
		
			if ([elementName isEqualToString:nodeElementName]) {
				isInNode = YES;
				if ([nodeTypeName isEqualToString:kDAParserDictionaryNodeKey]) { //DICTIONARIO TRATAMENTO
					if (_currentArrayNode)
					{
						[_currentArrayNode addObject:_currentNode];	
					}
					else {
						[_rootNode setObject:_currentNode forKey:nodeElementName];
					}

				}
				else if ([nodeTypeName isEqualToString:kDAParserArrayNodeKey]) {
					[_rootNode setObject:_currentArrayNode forKey:nodeElementName];
					
				}
				

				_canCollectCharacters = NO;
				
				_elementText = [[NSMutableString alloc] init];
				
				_currentNode = [[NSMutableDictionary alloc] init];
				
				break;
			}
		}
		
		if (!isInNode) {
			if(_currentNode) {
				
				[_currentNode setObject:_elementText forKey:elementName];
			}
			else {
				[_rootNode setObject:_elementText forKey:elementName];
			}
			_elementText = [[NSMutableString alloc] init];
			
			
		}
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (_canCollectCharacters) {
		[_elementText appendString:string];
	}
	
	NSLog(@"foundCharacters: %@" , string);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"parseErrorOcurred: %@", [parseError description]);
	if ([_delegate respondsToSelector:@selector(webServiceParser:didFailWithError:)]) {
		[_delegate webServiceParser:self didFailWithError:parseError];
	}
}

@end
