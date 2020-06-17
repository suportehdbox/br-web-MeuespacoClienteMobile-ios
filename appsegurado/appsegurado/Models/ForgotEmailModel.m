//
//  ForgotEmailModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ForgotEmailModel.h"
@interface ForgotEmailModel(){
    NSString*currentCpf;
}
@end
@implementation ForgotEmailModel
@synthesize delegate;


-(void) getQuestions:(NSString*) cpf lastQuestions:(NSArray*) array{
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/NovoEmail/Question",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    currentCpf = cpf;
    [conn addPostParameters:cpf key:@"CpfCnpj"];
    NSError *error;
    NSArray *arrayLast;
    if([array count] > 0){
        arrayLast =[[NSArray alloc] initWithArray:array];
    }else{
        arrayLast = [self getLastsQuestionsCpf:cpf];
        if(arrayLast == nil){
            arrayLast = [[NSArray alloc] init];
        }
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrayLast options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [conn addPostParameters:jsonString key:@"PerguntasSorteadas"];
    [conn addPostParameters:brandMarketing key:@"brandMarketing"];
    //PerguntasSorteadas: [1,3,7]
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnEmail:)];
    [conn startRequest];
    
}

-(void)returnEmail:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
   
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers error:&error];
        
        if(!error){
            if([result objectForKey:@"message"] != nil && [result objectForKey:@"message"] != [NSNull null] && ![[result objectForKey:@"message"] isEqualToString:@""]){
                
                if(delegate && [delegate respondsToSelector:@selector(questionsError:)]){
                    [delegate questionsError:[result objectForKey:@"message"]];
                }
                
                return;
            }else{
                
                ForgotEmailBeans * beans = [[ForgotEmailBeans alloc] initWithDictionary:result];
                [self storeLastQuestions:beans.sortedQuestions cpf:currentCpf];
                
                if(delegate && [delegate respondsToSelector:@selector(returntQuestions:)]){
                    [delegate returntQuestions:beans];
                }
            }
        }
    
}


-(void)sendAnswersCPF:(NSString*) cpf newEmail:(NSString*)newEmail questions:(NSArray*) arrayQuestions{


    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/NovoEmail/Answer",[super getBaseUrl]] contentType:@"application/json"];
    [conn addBodyParameters:cpf key:@"CpfCnpj"];
    [conn addBodyParameters:newEmail key:@"Email"];
    
    [conn addBodyParameters:brandMarketing key:@"brandMarketing"];
    NSMutableArray *arrayAnswerFinal = [[NSMutableArray alloc] init];
    for (Question *quest in arrayQuestions) {
//        if(![answers isEqualToString:@"["]){
//            answers = [answers stringByAppendingString:@","];
//        }
//        answers = [answers stringByAppendingString:[NSString stringWithFormat:@"{\"idPergunta\":%d,\"Resposta\":\"%@\"}",quest.idQuestion, quest.userAnswer]];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:quest.idQuestion], @"idPergunta", [[NSArray alloc] initWithObjects:quest.userAnswer, nil], @"resposta", nil];
        [arrayAnswerFinal addObject:dic];
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:arrayAnswerFinal, @"listaDePerguntas", nil];
    [conn addBodyParameters:dic key:@"Respostas"];
    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    [conn addPostParameters:jsonString key:@"PerguntasSorteadas"];
    //PerguntasSorteadas: [1,3,7]
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnAnswers:)];
    [conn startRequest];
    
}

-(void)returnAnswers:(NSData *)responseData{
    
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    if([responseData length] == 0){
        if(delegate && [delegate respondsToSelector:@selector(returnAnswerSucessfully)]){
            [delegate returnAnswerSucessfully];
        }
    }else{
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers error:&error];
        
        if(!error){
            if([result objectForKey:@"message"] != nil && [result objectForKey:@"message"] != [NSNull null] && ![[result objectForKey:@"message"] isEqualToString:@""]){
               
                if(delegate && [delegate respondsToSelector:@selector(answersError:)]){
                    [delegate answersError:[result objectForKey:@"message"]];
                }
                
                return;
            }else{
                if(delegate && [delegate respondsToSelector:@selector(returnAnswerSucessfully)]){
                    [delegate returnAnswerSucessfully];
                }
            }
        }
    }
    
}

-(void) storeLastQuestions:(NSArray*) questions cpf:(NSString*)cpf{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:questions forKey:[NSString stringWithFormat:@"quest%@",cpf]];
    [defaults synchronize];
}
-(NSArray*) getLastsQuestionsCpf:(NSString*)cpf{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    return (NSArray*) [defaults objectForKey:[NSString stringWithFormat:@"quest%@",cpf]];
}

-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(delegate && [delegate respondsToSelector:@selector(answersError:)]){
        [delegate answersError:NSLocalizedString(@"ConnectionError",@"") ];
    }
}
@end
