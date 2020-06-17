//
//  CoverageBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/04/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoverageBeans : NSObject

typedef NS_ENUM(NSInteger, CoverageType) {
    CT_UNKNOWN,
    CT_COVERAGE,
    CT_ASSIST
};
@property (nonatomic,strong) NSString *coverageDescription;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,strong) NSString *value;
@property (nonatomic) CoverageType type;


- (id)initWithDictionary:(NSDictionary*)dic;

@end
