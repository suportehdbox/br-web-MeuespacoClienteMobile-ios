 //
//  Communication.m
//  imobile
//
//  Created by Jefferson Nascimento.
//  Revision by Evandro Pinheiro on 05/09/11.
//  Copyright 2011 Gimon. All rights reserved.
//

#import "Communication.h"

#define FAIL_CONNECTION     0
#define FAIL_PARSER         1
#define FAIL_RETURN         2


@implementation Communication

@synthesize _target, 
_selector,
soapResults, 
soapMsg,
endPoint,
conn;

// referência para uma unica instância
static Communication* instance = nil;

+ (Communication *)instance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return (instance);
}

- (id) init 
{
	self = [super init];
	if (self) 
    {
        [self setEndPoint: @"http://10.56.50.145/Liberty.Portal.Parceiro.ControllerUI/DSV/Controllers"];
        _timeOut = 3;
	}
	return self;
}

- (void) dealloc
{
	[_method release];
	[soapMsg release];
	[webData release];
	[conn release];
    //    [soapResults release];
    [endPoint release];
    [xmlParser release];
    
	[super dealloc];
}

- (void) invoke 
{
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endPoint] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_timeOut];
	[req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[req addValue:_method forHTTPHeaderField:@"SOAPAction"];
    [req addValue:[NSString stringWithFormat:@"%d", [soapMsg length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    NSLog(@" /n/n/n %@",soapMsg);
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
	conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [[NSMutableData data] retain];
    }
	[UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}

- (NSString*) getSoapMsg:(NSString*) parameters 
{    
	return [NSString stringWithFormat:
            @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><%@ xmlns=\"%@\"><request xsi:type=\"xsd:string\">%@</request></%@></soap:Body></soap:Envelope>", _method, endPoint, parameters, _method ];
}

#pragma mark - Connection
-(void) connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse*)response 
{
	[webData setLength: 0];
}

-(void) connection:(NSURLConnection*) connection didReceiveData:(NSData*)idata 
{
	[webData appendData:idata];
}

-(void) connection:(NSURLConnection*) connection didFailWithError:(NSError*)error 
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
    fail = TRUE;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERRO", nil)
                                                    message:NSLocalizedString(@"FALHA_CONEXAO", nil)
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert setTag:FAIL_CONNECTION];
	[alert show];
    [alert release];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection 
{   
	[UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

#pragma mark Parse

-(void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI  qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict 
{
	soapResults = nil;
	if( [elementName isEqualToString:[NSString stringWithFormat:@"%@Return", _method]])
    {
		soapResults = [[[NSMutableString alloc] init] autorelease];
        elementFound = TRUE;
    } 
    else if([elementName isEqualToString:@"faultcode"]) 
    {
        fail = TRUE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERRO", nil)  message:NSLocalizedString(@"SERVIDOR_FALHA", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert setTag:FAIL_PARSER];
        [alert show];
        [alert release];        
	}
}

-(void)parser:(NSXMLParser*) parser foundCharacters:(NSString*)string 
{
    if (elementFound) 
        [soapResults appendString: string];
}

-(void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName 
{
	elementFound = ![elementName isEqualToString:[NSString stringWithFormat:@"%@Return", _method]]; 
}

- (void)parserDidEndDocument:(NSXMLParser*)parser
{
    if(!fail) 
    {    
        if (jsonRequest)
        {
            [_target performSelector:_selector withObject:[self result:[NSString stringWithString:soapResults]]];
        } 
        else 
        {
            NSString *result = [NSString stringWithString:soapResults];
            [_target performSelector:_selector withObject:result];
        }
    }
}

#pragma mark retorno

- (NSMutableDictionary*) result:(NSString*) result
{
    NSMutableDictionary *jsonOutput = nil;
    
    // verifica se teve resposta
    if(![result isEqualToString:@""] ) 
    {
        // Decode de base64
//        NSData *decode = [BaseMeia4 decode:result];
//        NSString *output = [[NSString alloc] initWithData:decode encoding:NSASCIIStringEncoding];
//        NSLog(@"%@", output);
        
        // Transforma a resposta em objeto JSON
//        SBJSON *json = [[SBJSON new] autorelease];
//        NSMutableDictionary *jsonResponseDict = [json objectWithString:output error:nil];
//        [output release];
//        jsonOutput = [jsonResponseDict objectForKey:OUTPUT];
        
        NSString *codeReturn = nil;
        
        NSObject *compObj = [jsonOutput objectForKey:CODE_RETURN];
        if (compObj)
        {
            if ([compObj isKindOfClass:[NSString class]])
                codeReturn = [jsonOutput objectForKey:CODE_RETURN];
            else 
                codeReturn = [NSString stringWithFormat:@"%@", [jsonOutput objectForKey:CODE_RETURN]];
        }
        
        /* Exibe mensagens de acordo com o código vindo do servidor */
        
        NSString *msgError = nil;
        
        // verifica o sucesso no metodo
        
//        Definição pede msg de sucesso. Não implementada. Por causa da repetição.
//        if ([codeReturn isEqualToString:RETURN_OK])
//        {
//            msgError = NSLocalizedString(@"RETURN_OK", nil);
//        } 
//        else 
        if ([codeReturn isEqualToString:RETURN_FAIL])
        {
            NSString *helperCod = nil;
//            if ([helperCod isKindOfClass:[NSString class]])
//                helperCod = [jsonOutput objectForKey:ID];
//            else
//                helperCod = [NSString stringWithFormat:@"%@", [jsonOutput objectForKey:ID]];
            
            msgError = [NSString stringWithFormat:NSLocalizedString(@"RETURN_FAIL", nil), helperCod];
        } 
        else if ([codeReturn isEqualToString:RETURN_LOCKED])
        {
            msgError = NSLocalizedString(@"RETURN_LOCKED", nil);
        }
        else if ([codeReturn isEqualToString:RETURN_ACTIVED]) 
        {
            msgError = NSLocalizedString(@"RETURN_ACTIVED", nil);
        }
        else if ([codeReturn isEqualToString:RETURN_NOTACTIVE])
        {
            msgError = NSLocalizedString(@"RETURN_NOTACTIVED", nil);
        }
        
        // Caso o erro não seja nenhum código conhecido:
        if (msgError == nil) 
        {
            msgError = [jsonOutput objectForKey:ERRO];
           //*se o servidor não retornou erro o msgError permanece nil
        }

        // Caso aconteca erro, exibe mensagem
        if (msgError != nil) 
        {
            // caso seja a notificação de sucesso da ativação, mensagem de erro específica:
//            if ([_method isEqualToString:WSMC_SEND_NOTIFICATION] && ![UtilsiGt isTrue: [[IGT instance] getProperty:EXECUTED]])
//            {
//                msgError = NSLocalizedString(@"ERRO_FIRST_RUN",  nil);
//            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERRO", nil)  message:msgError delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            [alert setTag:FAIL_RETURN];
            [alert show];
            [alert release];
        }
    }
    //[req release];
    //[result release];
    //[decode release];
	return jsonOutput;
}

#pragma mark métodos

- (void) invoke:(NSString*)method  parameters:(NSString*)parameters target:(id)target sel:(SEL)selector

//- (void) invoke:(NSString*)method  parameters:(NSMutableArray*)parameters target:(id)target sel:(SEL)selector
{
    jsonRequest = YES;
    _method      = method;
    _target      = target;
    _selector    = selector;
    
//    // Transforma em json
//    NSString *parametersJson = [self createJsonRequestWithParameters: parameters];
//    // Codifica em base 64
//    NSString *parameters64 = [BaseMeia4 encode:[parametersJson dataUsingEncoding:NSASCIIStringEncoding]];
//    // seta o objeto de requisição Json no soapMsg
//    [self setSoapMsg:[self getSoapMsg: parameters64]];
    
    [self setSoapMsg:parameters];
    
    [self invoke];
}

- (void) invoke:(NSString*)method  string:(NSString*)string target:(id)target sel:(SEL)selector decode:(BOOL)decode
{
    jsonRequest  = decode;
    _method      = method;
    _target      = target;
    _selector    = selector;
    
    // seta o objeto de requisição Json no soapMsg 
    [self setSoapMsg:[self getSoapMsg:string]];
    
    [self invoke];
}

#pragma mark

#pragma mark - UIAlertViewDelegate Methods

// Called when an alert button is tapped.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (![UtilsiGt isTrue: [[IGT instance] getProperty:EXECUTED]])
//    {
//        // sempre que ocorrer falhas na primeira execução o programa será fechado. Não salva estado.
//        exit(0);
//    }
//    else
//    {
        [_target performSelector:@selector(hideWaitView)];
        switch ([alertView tag]) 
        {
            case FAIL_CONNECTION:
                // se falhar a conexão na notificação que os dados foram perdidos: fecha aplicação 
//                if ([UtilsiGt isTrue:[[IGT instance] getProperty:DATALOST]]) {
//                    exit(0);
//                }
                break;

            case FAIL_PARSER:
                break;
                
            case FAIL_RETURN:
                break;
        }
//    }
}

@end
