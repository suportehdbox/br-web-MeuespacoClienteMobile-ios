//
//  Pergunta.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ForgotEmailBeans.h"

@implementation Question
@synthesize  idQuestion, desc, userAnswer;
- (id)initWithDictionary:(NSDictionary*)dic;{
    
    self = [super init];
    if (self) {
        idQuestion = [[dic objectForKey:@"idPergunta"] intValue];
        desc = [dic objectForKey:@"descricao"];
    }
    return self;
}

@end


@implementation ForgotEmailBeans

- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        _questionsList = [[NSMutableArray alloc] init];
        for (NSDictionary *dic_quest in [[dic objectForKey:@"perguntas"] objectForKey:@"listaDePerguntas"]) {
            Question *quest = [[Question alloc] initWithDictionary:dic_quest];
            [_questionsList addObject:quest];
        }
        _sortedQuestions = [dic objectForKey:@"perguntasSorteadas"];

    }
    return self;
}

@end
