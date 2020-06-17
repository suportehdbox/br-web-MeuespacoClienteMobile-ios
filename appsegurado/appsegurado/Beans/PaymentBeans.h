//
//  Payment.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 19/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentBeans : NSObject

@property (nonatomic) float amountPayable;
@property (nonatomic) bool canExtend;
@property (nonatomic,strong) NSString *dueDate;
@property (nonatomic) int number;
@property (nonatomic) int amountOfInstallment;
@property (nonatomic) int status;
@property (nonatomic) float nextValue;
@property (nonatomic,strong) NSString *nextDueDate;
@property (nonatomic,strong) NSString *codigoTipoModalidadeCobranca;
@property (nonatomic) long issuance;
@property (nonatomic) int showComponent; //0 = None (não exibe nada na parcela)
                                         //1 = Ticket (exibe o botão que disponibiliza o código de barras para o segurado)
                                         //2 = Reprogramming (exibe o botão que realiza a reprogramação da parcela para o segurado).


- (id)initWithDictionary:(NSDictionary*)dic;

@end
