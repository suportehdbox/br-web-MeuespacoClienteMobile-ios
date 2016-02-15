 //
//  CallWebServices.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CallWebServices.h"
#import "WebServiceHelper.h"
#import "Util.h"
#import "Communication.h"

@implementation CallWebServices

@synthesize addressServerSegurado;

@synthesize delegate;
@synthesize typeCall;
@synthesize UserErrorMessagesMsg;

- (id)init
{
    self = [super init];
    
    if (self){

        LMTipoExecucao execucao = LMTipoExecucaoProducao;
        trace = @"true";

        switch (execucao)
        {
            case LMTipoExecucaoDesenv:
                {
                    /* DESENVOLVIMENTO  */
                    
                     // Portal Segurado
                     //addressServerSegurado = [[NSString alloc] initWithString:@"http://10.55.5.171:9442/WSPortalSegurado"];
                     self.addressServerSegurado = [[NSString alloc] initWithString:@"http://10.136.187.30/Liberty.Portal.Segurado.ControllerUI"];
                    //addressServerSegurado = [[NSString alloc] initWithString:@"http://10.56.50.181/LibertyPortalSeguradoControllerUI"];
                    
                     //addressServerSegurado = [[NSString alloc] initWithString:@"http://10.56.50.145/LibertyPortalSeguradoControllerUI"];
                     // Acesso Interno do servidor DMZ: addressServerSegurado = [[NSString alloc] initWithString:@"http://br-lihi-act-dmz/LibertyPortalSegurado"];
                    
                    //self.addressServerSegurado = [[NSString alloc] initWithString:@"http://10.136.187.49/LibertyPortalSeguradoControllerUI"];
                }
                break;
            case LMTipoExecucaoAceite:
                {
                    /* ACEITE / HOMOLOGACAO (DMZ) */
                    
                    // Portal Segurado
                    self.addressServerSegurado   = [[NSString alloc] initWithString:@"http://VWKIUBR-SPAAP01:9441/WSPortalSegurado"];       // Kansas
                    //para teste no navegador: https://VWKIUBR-SPAAP01/LibertyPortalSegurado/ControllerUI.asmx
                   
                    // aceite Interno via VPN (Hering)
                    //addressServerSegurado = [[NSString alloc] initWithString:@"http://br-lihi-act-spa:9441/WSPortalSegurado"];  
                }
                break;
            case LMTipoExecucaoAceiteExterno:
                {
                    /* ACEITE / HOMOLOGACAO (DMZ) COM visiblidade Externa */
                    
                    self.addressServerSegurado = [[NSString alloc] initWithString:@"https://act-dmz.libertyseguros.com.br/LibertyPortalSegurado"];
                    
                }
                break;
            case LMTipoExecucaoProducao:
                {
                    /* PRODUCAO */
                     
                    // Portal Segurado
                    [self setAddressServerSegurado:@"https://meuespaco.libertyseguros.com.br/WSPortalSegurado"]; // Brasil
                    //para teste no navegador: https://meuespaco.libertyseguros.com.br/WSPortalSegurado/LoginController.asmx (fazer testes)
                    
                    //addressServerSegurado = [[NSString alloc] initWithString:@"http://vwkdpbr-spfap01:10443/WSPortalSegurado"]; // Kansas
                    //para teste no navegador: http://vwkdpbr-spfap01:10443/WSPortalSegurado/LoginController.asmx
                }
                break;
        }
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [addressServerSegurado release];
}

#pragma mark - Portal Segurado

//-------------------------------------------------------------------------------------------------------------------------------------
// Chamadas do Portal Segurado

-(void)callLogonSegurado:(id)target user:(NSString *)user password:(NSString *)password manterLogado:(NSString *)manterLogado
{
    typeCall = LMCallWsLogonSegurado;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];

    // Create an object to the class above which is the connection to the WCF Service 
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"AutenticarMobileApp";    
    
    NSString *idDevice = [DADevice currentDevice].UID;

    // * sistema = PortalSegurado : Sistema utilizado no ControlleDeAcesso; TipoSO = 1 : plataforma IOS.
    NSString *xmlRequest = [NSString stringWithFormat:@"<AutenticarRequest><Sistema>PortalSegurado</Sistema><Usuario>%@</Usuario><Senha>%@</Senha><ManterLogado>%@</ManterLogado><IdDevice>%@</IdDevice><TipoSO>1</TipoSO></AutenticarRequest>", user, password, manterLogado, idDevice];
    
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:user forKey:@"usuarioId"];
    [methodParameters setObject:trace forKey:@"ativarTrace"];
    
    [methodParameters setObject:xmlRequest forKey:@"xmlRequest"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];
    
    [dataCon initiateConnection:self];
}

-(DadosLoginSegurado *)retLogonSegurado
{
    DadosLoginSegurado * returnDados = nil;
    
    if (webData != nil && [webData length] != 0) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
        NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"AutenticarMobileAppResult"];
        [nsparser setDelegate:self];
        [nsparser parse];
        
        
        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
            } else {
                BOOL bError = FALSE;
                
                NSDictionary *TransactionMessages = [resultados objectForKey:@"TransactionMessages"];
                NSMutableArray *UserErrorMessages = [TransactionMessages objectForKey:@"UserErrorMessages"];
                
                if (UserErrorMessages != nil && [UserErrorMessages count] > 0) {
                    UserErrorMessagesMsg = [UserErrorMessages objectAtIndex:0];
                    if (![UserErrorMessagesMsg isEqualToString:@""]) bError = TRUE;
                }
                
                if (!bError) {
                    [self saveCookie];
                    returnDados = [[[DadosLoginSegurado alloc] init] autorelease];
                    returnDados.cpf = [resultados objectForKey:@"CPF"];
                    returnDados.tokenAutenticacao = [resultados objectForKey:@"TokenAutenticacao"];
                }
            }
        }
    }
    
    return returnDados;
}

-(void)callEnviarToken:(id)target cpfCnpj:(NSString *)cpfCnpj tokenNotificacao:(NSString *)tokenNotificacao
{
    typeCall = LMCallWsEnviarToken;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];
    
    // Create an object to the class above which is the connection to the WCF Service
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"GravarTokenNotificacaoMobileApp";
    
    
    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:cpfCnpj forKey:@"usuarioId"];
    [methodParameters setObject:trace forKey:@"ativarTrace"];
    [methodParameters setObject:[NSNumber numberWithInt:1] forKey:@"tipoSO"];
    [methodParameters setObject:tokenNotificacao forKey:@"TokenNotificacao"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];
    
    [dataCon initiateConnection:self];
}

-(BOOL)retEnviarToken
{
    bool returnToken = false;
    
    if (webData != nil && [webData length] != 0) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
        NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"GravarTokenNotificacaoMobileAppResult"];
        [nsparser setDelegate:self];
        [nsparser parse];
        
        
        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
            } else {
                BOOL bError = FALSE;
                
                NSDictionary *TransactionMessages = [resultados objectForKey:@"TransactionMessages"];
                NSMutableArray *UserErrorMessages = [TransactionMessages objectForKey:@"UserErrorMessages"];
                
                if (UserErrorMessages != nil && UserErrorMessages != (id)[NSNull null]) {
                    if([UserErrorMessages count] > 0) {
                        UserErrorMessagesMsg = [UserErrorMessages objectAtIndex:0];
                        if (![UserErrorMessagesMsg isEqualToString:@""])
                            bError = TRUE;
                    }
                }
                
                if (!bError) {
                    returnToken = [resultados objectForKey:@"Sucesso"];
                }
            }
        }
    }
    
    return returnToken;
}

-(void)callLogonSeguradoToken:(id)target usuarioId:(NSString *)usuarioId tokenAutenticacao:(NSString *)tokenAutenticacao
{
    typeCall = LMCallWsLogonSeguradoToken;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];
    
    // Create an object to the class above which is the connection to the WCF Service
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"AutenticarTokenMobileApp";
    
    NSString *idDevice = [DADevice currentDevice].UID;
    
    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:usuarioId forKey:@"usuarioId"];
    [methodParameters setObject:trace forKey:@"ativarTrace"];
    [methodParameters setObject:idDevice forKey:@"IdDevice"];
    [methodParameters setObject:tokenAutenticacao forKey:@"tokenAutenticacao"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];
    
    [dataCon initiateConnection:self];
}

-(DadosLoginSegurado *)retLogonSeguradoToken
{
    DadosLoginSegurado * returnDados = nil;
    
    if (webData != nil && [webData length] != 0) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
		NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"AutenticarTokenMobileAppResult"];
		[nsparser setDelegate:self];
		[nsparser parse];
        
        
        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
            } else {
                BOOL bError = FALSE;
                
                NSDictionary *TransactionMessages = [resultados objectForKey:@"TransactionMessages"];
                NSMutableArray *UserErrorMessages = [TransactionMessages objectForKey:@"UserErrorMessages"];
                
                if (UserErrorMessages != nil && [UserErrorMessages count] > 0) {
                    UserErrorMessagesMsg = [UserErrorMessages objectAtIndex:0];
                    if (![UserErrorMessagesMsg isEqualToString:@""]) bError = TRUE;
                }
                
                if (!bError) {
                    [self saveCookie];
                    returnDados = [[[DadosLoginSegurado alloc] init] autorelease];
                    
                    returnDados.cpf = [resultados objectForKey:@"CPF"];
                    
                    if ([returnDados.cpf isEqualToString:@""]) {
                        returnDados.cpf = [resultados objectForKey:@"Email"];
                    }
                    
                    returnDados.tokenAutenticacao = [resultados objectForKey:@"TokenAutenticacao"];
                    returnDados.minhasApolices = nil;
                    returnDados.minhasApolicesAnteriores = nil;
                }
            }
        }
    }
    
    return returnDados;
}

-(void)callEsqueciMinhaSenhaSegurado:(id)target email:(NSString *)email cpf:(NSString *)cpf
{
    typeCall = LMCallWsEsqueciMinhaSenhaSegurado;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];
    
    // Create an object to the class above which is the connection to the WCF Service
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"SolicitarNovaSenhaDeAcessoMobileApp";

    NSString *xmlRequest = [NSString stringWithFormat:@"<SolicitarNovaSenhaDeAcessoRequest><Email>%@</Email><CPF>%@</CPF></SolicitarNovaSenhaDeAcessoRequest>", email, cpf];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:email forKey:@"usuarioId"];
    [methodParameters setObject:trace forKey:@"ativarTrace"];
    
    [methodParameters setObject:xmlRequest forKey:@"xmlRequest"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];
    
    [dataCon initiateConnection:self];
}

-(BOOL)retEsqueciMinhaSenhaSegurado
{
    BOOL bRetorno = FALSE;
    [UserErrorMessagesMsg setString:@""];
    
    if (webData != nil) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
		NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"SolicitarNovaSenhaDeAcessoMobileAppResult"];
		[nsparser setDelegate:self];
		[nsparser parse];
        
        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
            } else {
                BOOL Valid = [[resultados objectForKey:@"Valid"] boolValue];
                if (Valid) {
                    [self saveCookie];
                    bRetorno = TRUE;
                }
                else {
                    if ((NSNull *)[resultados objectForKey:@"TransactionMessages"] != [NSNull null]) {
                        NSDictionary *TransactionMessages = [resultados objectForKey:@"TransactionMessages"];
                        
                        //Verificando se o campo é nulo
                        if ((NSNull *)[TransactionMessages objectForKey:@"UserErrorMessages"] != [NSNull null]) {
                            NSMutableArray *UserErrorMessages = [TransactionMessages objectForKey:@"UserErrorMessages"];
                            
                            //Verificando se o campo é nulo
                            if (UserErrorMessages != nil && [UserErrorMessages count] > 0) {
                                UserErrorMessagesMsg = [UserErrorMessages objectAtIndex:0];
                            }
                        }
                        else {  //Caso seja nulo, significa que o retorno não tem nenhum problema e a chamada foi Ok
                            bRetorno = TRUE;
                        }
                    } else {     //Caso seja nulo, houve erro de comunicação
                        bRetorno = FALSE;
                    }
                }
            }
        }
    }
    
    return bRetorno;
}

/* << SN 11886
-(void)callObterDadosSegurado:(id)target email:(NSString *)email
{
    typeCall = LMCallWsObterDadosSegurado;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];
    
    // Create an object to the class above which is the connection to the WCF Service 
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"ObterDadosUsuarioMobileApp";
    
    NSString *xmlRequest = [NSString stringWithFormat:@"<ObterDadosUsuarioRequest><emailLogin>%@</emailLogin></ObterDadosUsuarioRequest>", email];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:email forKey:@"usuarioId"];
    [methodParameters setObject:@"false" forKey:@"ativarTrace"];
    
    [methodParameters setObject:xmlRequest forKey:@"xmlRequest"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];
    
    [dataCon initiateConnection:self];
}
-(DadosLoginSegurado *)retObterDadosSegurado:(id)target
{
    DadosLoginSegurado *returnDados = nil;
    
    if (webData != nil && [webData length] != 0) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
		NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"ObterDadosUsuarioMobileAppResult"];
		[nsparser setDelegate:self];
		[nsparser parse];
        
        
        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
            } else {
                BOOL bError = FALSE;
                
                NSDictionary *TransactionMessages = [resultados objectForKey:@"TransactionMessages"];
                NSMutableArray *UserErrorMessages = [TransactionMessages objectForKey:@"UserErrorMessages"];
            
                if (UserErrorMessages != nil && [UserErrorMessages count] > 0) {
                    UserErrorMessagesMsg = [UserErrorMessages objectAtIndex:0];   
                    if (![UserErrorMessagesMsg isEqual:@""]) bError = TRUE;
                }

                if (!bError) {
                    
                    [self saveCookie];
                    
                    returnDados = [[[DadosLoginSegurado alloc] init] autorelease];
                    //returnDados.nome = [resultados objectForKey:@"Nome"];
                    returnDados.email = [resultados objectForKey:@"Email"];
                    returnDados.cpf = [resultados objectForKey:@"CPF"];
                    //returnDados.numeroApolice = [resultados objectForKey:@"NumeroApolice"];
                    //returnDados.fraseLembrete = [resultados objectForKey:@"FraseLembrete"];
                    returnDados.minhasApolices = nil;
                }
            }
        }
    }

    return returnDados;
}
>> */

-(void)callCadastrarUsuario:(id)target nome:(NSString *)nome senha:(NSString *)senha email:(NSString *)email cpf:(NSString *)cpf apolice:(NSString *)apolice fraseLembrete:(NSString *)fraseLembrete codigoImagemAcesso:(NSString *)codigoImagemAcesso
{
    typeCall = LMCallWsCadastrarUsuario;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];
    
    // Create an object to the class above which is the connection to the WCF Service
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"CadastrarUsuarioMobileApp";

    NSString *xmlRequest = [NSString stringWithFormat:@"<CadastrarUsuarioRequest><Nome>%@</Nome><Senha>%@</Senha><Email>%@</Email><CPF>%@</CPF><NumeroApolice>%@</NumeroApolice><FraseLembrete>%@</FraseLembrete><CodigoImagemAcesso>%@</CodigoImagemAcesso></CadastrarUsuarioRequest>",
                                                                                            nome, senha, email, cpf, apolice, fraseLembrete, codigoImagemAcesso];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:email forKey:@"usuarioId"];
    [methodParameters setObject:trace forKey:@"ativarTrace"];
    
    [methodParameters setObject:xmlRequest forKey:@"xmlRequest"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];
    
    [dataCon initiateConnection:self];
}

-(BOOL)retCadastrarUsuario
{
    BOOL bRetorno = FALSE;
    
    if (webData != nil) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
		NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"CadastrarUsuarioMobileAppResult"];
		[nsparser setDelegate:self];
		[nsparser parse];
        
        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
            }
            else {
                BOOL bError = FALSE;
                
                if ((NSNull *)[resultados objectForKey:@"TransactionMessages"] != [NSNull null]) {
                    NSDictionary *TransactionMessages = [resultados objectForKey:@"TransactionMessages"];
                    
                    if ((NSNull *)[[resultados objectForKey:@"TransactionMessages"] objectForKey:@"UserErrorMessages"] != [NSNull null]) {
                        NSMutableArray *UserErrorMessages = [TransactionMessages objectForKey:@"UserErrorMessages"];
                        
                        if (UserErrorMessages != nil && [UserErrorMessages count] > 0) {
                            UserErrorMessagesMsg = [UserErrorMessages objectAtIndex:0];
                            if (![UserErrorMessagesMsg isEqual:@""]) {
                                bError = TRUE;
                            }
                        }
                    }
                }
                
                if (!bError) {
                    bRetorno = TRUE;
                }
            }
        }
    }
    
    return bRetorno;
}


-(void)callGetMeusSegurosLiberty:(id)target cpfCnpj:(NSString *)cpfCnpj tipoFiltro:(NSString *)tipoFiltro
{
    typeCall = LMCallWsMeusSeguros;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];
    
    // Create an object to the class above which is the connection to the WCF Service 
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"MeusSegurosLibertyMobileApp";
    
    NSString *xmlRequest = [NSString stringWithFormat:@"<LoadRequest><emailLogin></emailLogin><CPFCNPJ>%@</CPFCNPJ><TipoPesquisaVigencia>%@</TipoPesquisaVigencia></LoadRequest>", cpfCnpj, tipoFiltro];
    
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:cpfCnpj forKey:@"usuarioId"];
    [methodParameters setObject:trace forKey:@"ativarTrace"];
    
    [methodParameters setObject:xmlRequest forKey:@"xmlRequest"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];
    
    [dataCon initiateConnection:self];
}

-(NSMutableArray *)retGetMeusSegurosLiberty
{
    NSMutableArray * dctMeusSeguros = [[[NSMutableArray alloc] init] autorelease];
    
    if (webData != nil) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
		NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"MeusSegurosLibertyMobileAppResult"];
		[nsparser setDelegate:self];
		[nsparser parse];
        
        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
                /*dctMeusSeguros = nil;
                [dctMeusSeguros release];*/
            }
            else {
                BOOL bError = FALSE;
                
                NSDictionary *TransactionMessages = [resultados objectForKey:@"TransactionMessages"];
                NSMutableArray *UserErrorMessages = [TransactionMessages objectForKey:@"UserErrorMessages"];
                                
                if (UserErrorMessages != nil && [UserErrorMessages count] > 0) {
                    UserErrorMessagesMsg = [UserErrorMessages objectAtIndex:0];   
                    if (![UserErrorMessagesMsg isEqual:@""]){
                        bError = TRUE;
                        
                        // Retorna erro, de acordo com o caso fara chamada de autenticacao e depois chamara o servico novamente
                        if([UserErrorMessagesMsg isEqualToString:@"SESSAO_INVALIDA"]){
                            [NSException raise:UserErrorMessagesMsg format:@"Servidor enviou %@ ", UserErrorMessagesMsg];
                        }
                    }
                }
                
                if (!bError) {
                    NSMutableArray * dctAuto = [[resultados objectForKey:@"Seguros"] objectForKey:@"SeguroDeAuto"];
                    NSMutableArray * dctResidencial = [[resultados objectForKey:@"Seguros"] objectForKey:@"SeguroResidencial"];
                    NSMutableArray * dctPessoais = [[resultados objectForKey:@"Seguros"] objectForKey:@"SegurosPessoais"];
                    NSMutableArray * dctOutrosSegurosLiberty = [[resultados objectForKey:@"Seguros"] objectForKey:@"OutrosSegurosLiberty"];
                    NSMutableArray * dctSeguroEmpresarial = [[resultados objectForKey:@"Seguros"] objectForKey:@"SeguroEmpresarial"];
                
                    if ((NSNull *)dctAuto != [NSNull null]) {
                        for (NSUInteger iCont = 0; iCont < [dctAuto count]; iCont++) {
                            NSMutableDictionary *dict = [dctAuto objectAtIndex:iCont];
                            [dict setObject:@"AUTO" forKey:@"TipoSeguro"];
                            [dctMeusSeguros addObject:[dctAuto objectAtIndex:iCont]];
                        }
                    }
                    
                    if ((NSNull *)dctResidencial != [NSNull null]) {
                        for (NSUInteger iCont = 0; iCont < [dctResidencial count]; iCont++) {
                            NSMutableDictionary *dict = [dctResidencial objectAtIndex:iCont];
                            [dict setObject:@"RESIDENCIA" forKey:@"TipoSeguro"];
                            [dctMeusSeguros addObject:[dctResidencial objectAtIndex:iCont]];
                        }
                    }

                    if ((NSNull *)dctPessoais != [NSNull null]) {
                        for (NSUInteger iCont = 0; iCont < [dctPessoais count]; iCont++) {
                            NSMutableDictionary *dict = [dctPessoais objectAtIndex:iCont];
                            [dict setObject:@"PESSOAL" forKey:@"TipoSeguro"];
                            [dctMeusSeguros addObject:[dctPessoais objectAtIndex:iCont]];
                        }
                    }

                    if ((NSNull *)dctOutrosSegurosLiberty != [NSNull null]) {
                        for (NSUInteger iCont = 0; iCont < [dctOutrosSegurosLiberty count]; iCont++) {
                            NSMutableDictionary *dict = [dctOutrosSegurosLiberty objectAtIndex:iCont];
                            [dict setObject:@"OUTROS" forKey:@"TipoSeguro"];
                            [dctMeusSeguros addObject:[dctOutrosSegurosLiberty objectAtIndex:iCont]];
                        }
                    }
                    
                    if ((NSNull *)dctSeguroEmpresarial != [NSNull null]) {
                        for (NSUInteger iCont = 0; iCont < [dctSeguroEmpresarial count]; iCont++) {
                            NSMutableDictionary *dict = [dctSeguroEmpresarial objectAtIndex:iCont];
                            [dict setObject:@"EMPRESARIAL" forKey:@"TipoSeguro"];
                            [dctMeusSeguros addObject:[dctSeguroEmpresarial objectAtIndex:iCont]];
                        }
                    }
                    
                }
            }
        }
    }
    
    return dctMeusSeguros;
}

-(void)callGetCoberturasApolice:(id)target usuarioId:(NSString *)usuarioId numeroContrato:(NSString *)numeroContrato codigoEmissao:(NSString *)codigoEmissao codigoItem:(NSString *)codigoItem codigoCIA:(NSString *)codigoCIA
{
    typeCall = LMCallWsObterCoberturas;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];
    
    // Create an object to the class above which is the connection to the WCF Service 
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"ObterCoberturasMobileApp";

    NSString *xmlRequest = [NSString stringWithFormat:@"<ObterCoberturasRequest><NumeroContrato>%@</NumeroContrato><CodigoEmissao>%@</CodigoEmissao><CodigoItem>%@</CodigoItem><CodigoCia>%@</CodigoCia></ObterCoberturasRequest>",
                                                              numeroContrato, codigoEmissao, codigoItem, codigoCIA];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];

    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:usuarioId forKey:@"usuarioId"];
    [methodParameters setObject:trace forKey:@"ativarTrace"];
    
    [methodParameters setObject:xmlRequest forKey:@"xmlRequest"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];
    
    [dataCon initiateConnection:self];
}

-(NSMutableArray *)retGetCoberturasApolice
{
    NSMutableArray * dctCoberturas = nil;//[[NSMutableArray alloc] init];
    
    if (webData != nil) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
		NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"ObterCoberturasMobileAppResult"];
		[nsparser setDelegate:self];
		[nsparser parse];
        
        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
            }
            else {
                BOOL bError = FALSE;
                
                NSDictionary *TransactionMessages = [resultados objectForKey:@"TransactionMessages"];
                NSMutableArray *UserErrorMessages = [TransactionMessages objectForKey:@"UserErrorMessages"];
                
                if (UserErrorMessages != nil && [UserErrorMessages count] > 0) {
                    UserErrorMessagesMsg = [UserErrorMessages objectAtIndex:0];   
                    if (![UserErrorMessagesMsg isEqual:@""]){
                        bError = TRUE;
                        
                        // Retorna erro, de acordo com o caso fara chamada de autenticacao e depois chamara o servico novamente
                        if([UserErrorMessagesMsg isEqualToString:@"SESSAO_INVALIDA"]){
                            [NSException raise:UserErrorMessagesMsg format:@"Servidor enviou %@ ", UserErrorMessagesMsg];
                        }
                    }
                }
                
                if (!bError) {
                    //dctCoberturas = [resultados objectForKey:@"Coberturas"];
                    dctCoberturas = [[[NSMutableArray alloc] initWithArray:[resultados objectForKey:@"Coberturas"]] autorelease];
                }
            }
        }
    }
    
    return dctCoberturas;
}

//-------------------------------------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------

-(void)callGetClubeLiberty:(id)target email:(NSString *)email
{
    typeCall = LMCallWsClubeLiberty;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];
    
    // Create an object to the class above which is the connection to the WCF Service 
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"ObterClubeLibertyMobileApp"; //PorWebServiceMobileApp";
    
    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:email forKey:@"usuarioId"];
    [methodParameters setObject:trace forKey:@"ativarTrace"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];
    
    [dataCon initiateConnection:self];
}

-(NSMutableArray *)retGetClubeLiberty
{
    NSMutableArray * dctClubeLiberty = nil; //[[NSMutableArray alloc] init];
    
    if (webData != nil) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
		NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"ObterClubeLibertyMobileAppResult"]; //PorWebServiceMobileAppResult"];
		[nsparser setDelegate:self];
		[nsparser parse];

        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
                /*dctClubeLiberty = nil;
                [dctClubeLiberty release];*/
            }
            else {
                if ((NSNull *)[resultados objectForKey:@"ParceiroClubeLiberty"] != [NSNull null]) {
                    //dctClubeLiberty = [resultados objectForKey:@"ParceiroClubeLiberty"];
                    dctClubeLiberty = [[[NSMutableArray alloc] initWithArray:[resultados objectForKey:@"ParceiroClubeLiberty"]] autorelease];
                }
            }
        }
    }
    
    return dctClubeLiberty;
}

-(void)callGetOficinasReferenciadas:(id)target email:(NSString *)email cep:(NSString *)cep raio:(NSString *)raio
{
    typeCall = LMCallWsConsultarOficinas;
    self.delegate = target;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", addressServerSegurado, @"/ControllerUI.asmx"];
    
    // Create an object to the class above which is the connection to the WCF Service 
    WebServiceHelper *dataCon = [[[WebServiceHelper alloc] init] autorelease];
    
    dataCon.XMLNameSpace = @"http://tempuri.org/LibertyPortalSegurado";
    dataCon.XMLURLAddress = urlString;
    
    //set up method and parameters
    dataCon.MethodName = @"ConsultarOficinasMobileApp";
    
    NSString *xmlRequest = [NSString stringWithFormat:@"<OficinaRequest><CEP>%@</CEP><Raio>%@</Raio></OficinaRequest>", cep, raio];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    xmlRequest = [xmlRequest stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];

    NSMutableDictionary *methodParameters = [[NSMutableDictionary alloc] init];
    [methodParameters setObject:email forKey:@"usuarioId"];
    [methodParameters setObject:trace forKey:@"ativarTrace"];
    
    [methodParameters setObject:xmlRequest forKey:@"xmlRequest"];
    
    [dataCon setMethodParameters:methodParameters];
    [methodParameters release];

    [dataCon initiateConnection:self];
}

-(NSMutableArray *)retGetOficinasReferenciadas
{
    NSMutableArray * dctOficinasReferenciadas = nil; //[[NSMutableArray alloc] init];
    
    if (webData != nil) {
        
        NSString *theXML = [[NSString alloc]
                            initWithBytes: [webData mutableBytes]
                            length: [webData length]
                            encoding:NSUTF8StringEncoding];
        NSLog(@"%@", theXML);
        [theXML release];
        
		NSXMLParser *nsparser = [[NSXMLParser alloc] initWithData:webData];
        findElementName = [[NSString alloc] initWithString:@"ConsultarOficinasMobileAppResult"];
		[nsparser setDelegate:self];
		[nsparser parse];
        
        if (conteudo != nil && [conteudo isEqual:@""] == NO) {
            NSError *error;
            NSData *dataJson = [conteudo dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultados = [NSJSONSerialization JSONObjectWithData:dataJson options:NSJSONReadingMutableContainers error:&error];
            
            if (!resultados) {
                NSLog(@"Erro parsing JSON: %@", error);
                /*dctOficinasReferenciadas = nil;
                [dctOficinasReferenciadas release];*/
            }
            else {
                //dctOficinasReferenciadas = [resultados objectForKey:@"Oficinas"];
                if ((NSNull *)[resultados objectForKey:@"Oficinas"] != [NSNull null]) {
                    dctOficinasReferenciadas = [[[NSMutableArray alloc] initWithArray:[resultados objectForKey:@"Oficinas"]] autorelease];
                }
            }
        }
    }
    
    return dctOficinasReferenciadas;
}

//-------------------------------------------------------------------------------------------------------------------------------------
-(void)saveCookie {
    //------------------------
    //Get SessionId in Cookie from Request
    NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:dictCookie forURL:[NSURL URLWithString:@"http://temp"]];
    
    //Save the Cookie in App Storage
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:@"http://temp"] mainDocumentURL:nil];
    //------------------------
}


//-------------------------------------------------------------------------------------------------------------------------------------
//  Delegates Connection

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    webData = [[NSMutableData alloc] init];
    if (response != nil) {
        NSHTTPURLResponse *webResponse = (NSHTTPURLResponse *) response;
        dictCookie = [[NSDictionary alloc] initWithDictionary:[webResponse allHeaderFields]];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [webData release];
    [connection release];
    if (self != nil) {
        [self.delegate callWebServicesFailWithError:self error:error];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [connection release];
    if (self != nil) {
        [self.delegate callWebServicesDidFinish:self];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------
//  Delegates Parse Xml

//abre tag
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if([self tagFind:elementName]){
		//começou conteudo
		conteudo = [[NSMutableString alloc] init];
		devoler = YES;
	}
}

-(BOOL) tagFind:(NSString*) tag
{
	if([tag isEqualToString:findElementName]) {
        return YES;   
    }
	return NO;
}

//fecha tag
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	devoler = NO;
}

//
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(devoler) {
        [conteudo appendString:string];   
    }
}

@end