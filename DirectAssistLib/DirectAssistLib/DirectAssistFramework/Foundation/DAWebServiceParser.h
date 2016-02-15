//
//  DAActionResultParser.h
//  ws
//
//  Created by Thiago Ramalho on 16/08/11.
//  Copyright 2011 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAWebServiceParserDelegate;

@interface DAWebServiceParser : NSObject <NSXMLParserDelegate> {
	NSXMLParser *_parser;
	NSDictionary *_actionResult;
	NSString *_rootElementName;
	NSMutableDictionary *_rootNode;
	NSArray *_nodes;
	NSMutableString *_elementText;
	BOOL _canCollectCharacters;
	NSMutableArray *_currentArrayNode;
	NSMutableDictionary *_currentNode;
	id<DAWebServiceParserDelegate> __unsafe_unretained _delegate;
}

@property(nonatomic, unsafe_unretained) id<DAWebServiceParserDelegate> delegate;


- (void)parseWithXML:(NSString *)xml rootElementName:(NSString *)rootElementName nodes:(NSArray *)nodes;
+ (NSDictionary *)dictionaryNodeWithElementName: (NSString *)elementName;
+ (NSDictionary *)arrayNodeWithElementName:(NSString *)elementName;

@end

@protocol DAWebServiceParserDelegate <NSObject>

- (void)webServiceParser:(DAWebServiceParser *)webServiceParser didFinishWithResult:(NSDictionary *)result;
- (void)webServiceParser:(DAWebServiceParser *)webServiceParser didFailWithError:(NSError *)error;

@end
