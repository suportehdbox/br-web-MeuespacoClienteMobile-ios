//
//  CallWebServices.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/xmlmemory.h>
#import <libxml/parser.h>
#import "Constants.h"
#import "DadosLoginSegurado.h"
#import <DirectAssistLib/DADevice.h>

@protocol CallWebServicesDelegate;

@interface CallWebServices : NSObject <NSXMLParserDelegate>
{
    NSMutableString *conteudo;
    NSString *findElementName;
    BOOL devoler;

    NSMutableData *webData;
    NSDictionary *dictCookie;
    
    id<CallWebServicesDelegate> delegate;
    LMCallWs typeCall;
    
    NSString        *addressServerSegurado;
    
    NSMutableString *UserErrorMessagesMsg;
    
    NSString        *trace;
    
}

@property (nonatomic, assign) id<CallWebServicesDelegate> delegate;
@property (nonatomic, assign) LMCallWs typeCall;

@property(nonatomic, retain) NSString        *addressServerSegurado;
@property(nonatomic, retain) NSMutableString *UserErrorMessagesMsg;

//------------------------------------------------------------------------------------------------
//Segurado

-(void)callLogonSegurado:(id)target user:(NSString *)user password:(NSString *)password manterLogado:(NSString *)manterLogado;
-(DadosLoginSegurado *)retLogonSegurado;

-(void)callLogonSeguradoToken:(id)target usuarioId:(NSString *)usuarioId tokenAutenticacao:(NSString *)tokenAutenticacao;
-(DadosLoginSegurado *)retLogonSeguradoToken;

-(void)callEnviarToken:(id)target cpfCnpj:(NSString *)cpfCnpj tokenNotificacao:(NSString *)tokenNotificacao;
-(BOOL)retEnviarToken;

-(void)callEsqueciMinhaSenhaSegurado:(id)target email:(NSString *)email cpf:(NSString *)cpf;
-(BOOL)retEsqueciMinhaSenhaSegurado;

-(void)callCadastrarUsuario:(id)target nome:(NSString *)nome senha:(NSString *)senha email:(NSString *)email cpf:(NSString *)cpf apolice:(NSString *)apolice fraseLembrete:(NSString *)fraseLembrete codigoImagemAcesso:(NSString *)codigoImagemAcesso;
-(BOOL)retCadastrarUsuario;

-(void)callGetMeusSegurosLiberty:(id)target cpfCnpj:(NSString *)cpfCnpj tipoFiltro:(NSString *)tipoFiltro;
-(NSMutableArray *)retGetMeusSegurosLiberty;

-(void)callGetCoberturasApolice:(id)target usuarioId:(NSString *)usuarioId numeroContrato:(NSString *)numeroContrato codigoEmissao:(NSString *)codigoEmissao codigoItem:(NSString *)codigoItem codigoCIA:(NSString *)codigoCIA;
-(NSMutableArray *)retGetCoberturasApolice;

//------------------------
//Comum
-(void)callGetClubeLiberty:(id)target email:(NSString *)email;
-(NSMutableArray *)retGetClubeLiberty;

-(void)callGetOficinasReferenciadas:(id)target email:(NSString *)email cep:(NSString *)cep raio:(NSString *)raio;
-(NSMutableArray *)retGetOficinasReferenciadas;


//------------------------
-(void)saveCookie;

//------------------------

@end

@protocol CallWebServicesDelegate <NSObject>

@optional

- (void)callWebServicesDidFinish:(CallWebServices *)call;
- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error;

@end
