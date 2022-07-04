//
//  OpcoesPgtoEnum.h
//  appsegurado
//
//  Created by Samuel Henrique on 31/03/22.
//  Copyright © 2022 Liberty Seguros. All rights reserved.
//

#ifndef OpcoesPgtoEnum_h
#define OpcoesPgtoEnum_h

typedef NS_ENUM (NSUInteger, PaymentOpt) {
    PaymentOptTicket                       = 1,
    PaymentOptReprogramming                = 2,
    PaymentOptOnline                       = 3,  // à Pagamento online
    PaymentOptTicketAndOnline              = 4,  // à Código de barras e Pagamento online
    PaymentOptReprogrammingAndOnline       = 5,  // à Reprograma e Pagamento online
    PaymentOptReprogrammingAndOnlineStatus = 6,  // à Reprograma e consulta pgt. online
    PaymentOptTicketAndOnlineStatus        = 7,  // à Código de barras e consulta pgt. online
    PaymentOptOnlineStatus                 = 8,  // à Consulta pagamento online
    PaymentOptPixExpired                   = 9,  // Pix vencido
    PaymentOptPixActive                    = 10, // Pix não vencido
};

#endif /* OpcoesPgtoEnum_h */
