//
//  Communication.h
//  Communication
//
//  Created by Jefferson Nascimento on 4/14/11.
//  Revision by Evandro Pinheiro on 05/09/11.
//  Copyright 2009 Gimon. All rights reserved.
//

#define WSMC_ACTIVATION                 @"getActivationForIphone"
#define WSMC_VERIFY_VS_PRG              @"verifyVersionProgram"
#define WSMC_RECEIVE_APP                @"receiveApplication"
#define WSMC_RECEIVE_DATA               @"receiveData"
#define WSMC_VERIFY_VS_APP              @"verifyVersionApplication"
#define WSMC_GET_IMAGES                 @"getImages"
#define WSMC_SEND_DATA                  @"sendData"
#define WSMC_SEND_NOTIFICATION          @"sendNotification"
#define WSMC_SEND_NOTIFICATION          @"sendNotification"

#define WSMC_RT                         @"realTime"
#define WSMC_CELDISTR                   @"celdistr"
#define WSMC_VERSION                    @"version"

#define OUTPUT                          @"output"
#define RESPONSE                        @"response"
#define MSG                             @"message"
#define CODE_RETURN                     @"codeReturn"
#define ERRO                            @"exception"
#define RETURN_OK                       @"0"
#define RETURN_FAIL                     @"1"
#define RETURN_LOCKED                   @"2"
#define RETURN_ACTIVED                  @"3"
#define RETURN_NOTACTIVE                @"4"

#define CODE_RECEIVE_APP                @"1"
#define CODE_RECEIVE_DATA               @"2"
#define CODE_FIRST_RUN                  @"7"
#define CODE_LOCK_PIN                   @"8"
//#define CODE_ACTIVATED                  @"9"

@interface Communication : NSObject <NSXMLParserDelegate>
{
	id          _target;
	SEL         _selector;
    
    NSXMLParser     * xmlParser;
	NSURLConnection * conn;
	NSString        * endPoint;
	NSString        * _method;
	NSMutableData   * webData;
    NSMutableString * soapResults;
	NSString        * soapMsg;
    BOOL fail;
    BOOL jsonRequest;
    BOOL elementFound;
    int _timeOut;
}

@property (nonatomic, retain)       id  _target;
@property (nonatomic, readwrite)    SEL _selector;

@property (nonatomic, retain) NSString* soapResults;
@property (nonatomic, retain) NSString* endPoint;
@property (nonatomic, retain) NSString* soapMsg;
@property (nonatomic, retain) NSURLConnection* conn;

// método que devolve uma instância de Communication
+ (Communication *)instance;

// Método que retorna a resposta da comunicação no formato Dictionary com a key "output"
- (NSMutableDictionary*) result:(NSString*) result;

- (void) invoke:(NSString*)method  parameters:(NSString*)parameters target:(id)target sel:(SEL)selector;

@end
