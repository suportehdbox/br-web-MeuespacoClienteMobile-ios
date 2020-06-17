//
//  DigitableLineBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 22/03/18.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DigitableLineBeans : NSObject

@property (nonatomic, strong) NSString *dueDate;
@property (nonatomic, strong) NSString *digitableLine;
@property (nonatomic, strong) NSString *summaryInstructions;
@property (nonatomic, strong) NSString *completeInstructions;
@property (nonatomic, strong) NSString *value;

-(id)initWithDictionary:(NSDictionary*)dic;

@end
