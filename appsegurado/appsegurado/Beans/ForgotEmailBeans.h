//
//  Pergunta.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic,strong) NSString *desc;
@property (nonatomic) int idQuestion;
@property (nonatomic,strong) NSString *userAnswer;
- (id)initWithDictionary:(NSDictionary*)dic;
@end


@interface ForgotEmailBeans : NSObject

@property (nonatomic,strong) NSMutableArray *questionsList;
@property (nonatomic,strong) NSArray *sortedQuestions;

- (id)initWithDictionary:(NSDictionary*)dic;
@end
