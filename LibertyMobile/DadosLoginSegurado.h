//
//  DadosUser.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DadosLoginSegurado : NSObject {
    @private
}

@property(nonatomic,assign)BOOL logado;
//@property(nonatomic,assign)BOOL sincronizado;
@property(nonatomic,retain)NSString *cpf;
@property(nonatomic,retain)NSString *placa;
@property(nonatomic,retain)NSString *telefone;
@property(nonatomic,retain)NSString *tokenAutenticacao;
@property(nonatomic,retain)NSString *tokenNotificacao;
@property(nonatomic,retain)NSMutableArray * minhasApolices;
@property(nonatomic,retain)NSMutableArray * minhasApolicesAnteriores;

@end
