//
//  Constants.h
//  LibertyMutual
//
//  Created on 8/23/10.
//  Copyright 2010 Liberty Mutual. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LMLineOfBusinessTypeAuto = 0,
    LMLineOfBusinessTypeHome,
} LMLineOfBusinessType;

typedef enum {
    LMCallWsLogonSegurado = 100,
    LMCallWsLogonSeguradoToken = 107,
    LMCallWsEsqueciMinhaSenhaSegurado = 101,
    LMCallWsObterDadosSegurado = 102,
//    LMCallWsObterNovaImagemAcesso = 103,
    LMCallWsCadastrarUsuario = 104,
    LMCallWsMeusSeguros = 105,
    
    LMCallWsClubeLiberty = 106,
    
    LMCallWsObterCoberturas = 107,
    LMCallWsConsultarOficinas = 108,
    
    LMCallWsEnviarToken = 109,
    
} LMCallWs;

typedef enum {
    LMCallWsErrorConnection = 1
} LMCallWsError;

typedef enum {
    LMTipoExecucaoDesenv = 1,
    LMTipoExecucaoAceite = 2,
    LMTipoExecucaoProducao = 3,
    LMTipoExecucaoAceiteExterno = 4
} LMTipoExecucao;

typedef enum {
    LMPesquisa_GPS_LOCAL = 1,
    LMPesquisa_CEP,
    LMPesquisa_FEITA
} LMPesquisa;

static LMPesquisa pesquisa;

//LMTipoExecucao execucao = LMTipoExecucaoProducao;

//static NSString *LMUrlInterna = @"br-lihi-spi:8080";
static NSString *LMUrlInterna = @"vwkipbr-spaap01";
static NSString *LMUrlExterna = @"www.libertyseguros.com.br";

@interface Constants : NSObject {
    

}

+ (LMPesquisa) pesquisa;
+ (void)setPesquisa:(LMPesquisa) lmpesquisa;

@end
