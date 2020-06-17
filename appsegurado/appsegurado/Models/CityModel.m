//
//  CityModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 03/01/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "CityModel.h"
#import "AFSQLManager.h"

@interface CityModel(){
    bool databaseOpenned;
}
@end
@implementation CityModel
-(void) loadDataBase{
    
    [[AFSQLManager sharedManager] openDocumentsDatabaseWithName:@"libertymobile.db" andStatusBlock:^(BOOL success, NSError *error) {
        databaseOpenned = success;
        if(!error){
//            NSString *query = @"CREATE TABLE IF NOT EXISTS notifications (id INTEGER PRIMARY KEY AUTOINCREMENT, date STRING (11), alert STRING (255), cpfCnpj BIGINT)";
//            [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
//                if (!error) {
//                    
//                }
//            }];
        }else{
            NSLog(@"Error open database %@", error.localizedDescription);
        }
    }];
    
    
}
-(void) closeDataBase{
    databaseOpenned = false;
    [[AFSQLManager sharedManager] closeLocalDatabase];
}


-(NSMutableArray *) getCityFromState:(NSString*) state{
    if(!databaseOpenned){
        [self loadDataBase];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT citycode,city FROM city WHERE state = '%@' ORDER BY city", state];
    
    [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (!error) {
            if (!finished) {
                CityBeans *beans = [[CityBeans alloc] init];
                beans.state =state;
                beans.cityCode = [[row objectAtIndex:0] intValue];
                beans.city = [row objectAtIndex:1];
                [array addObject:beans];
            }
        } else {
            NSLog(@"Error open database %@", error.localizedDescription);
        }
        
    }];
    
    return array;
    
}

@end
