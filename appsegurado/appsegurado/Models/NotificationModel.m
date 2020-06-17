//
//  NotificationModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 14/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "NotificationModel.h"
#import "AppDelegate.h"
#import "NotificationBeans.h"
#import "AFSQLManager.h"
#import <Foundation/Foundation.h>
@interface NotificationModel(){
    bool databaseOpenned;
    AppDelegate *appDelegate;
}
@end
@implementation NotificationModel

@synthesize delegate;

-(void) getNotifications{

    appDelegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];

    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Notificacao/",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    
    NSString *idDevice = ([[UIDevice currentDevice] identifierForVendor] != nil ? [[[UIDevice currentDevice] identifierForVendor] UUIDString] : @"");
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    [conn addGetParameters:idDevice key:@"DeviceId"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(parseNotification:)];
    [conn startRequest];

}



-(void)parseNotification:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
//    
//    
//    NSMutableArray *arrayReturn = [[NSMutableArray alloc] init];
////
//    NotificationBeans *beans = [[NotificationBeans alloc] initWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:@"10/07/2016", @"date", @"Diego, aproveite os seus beneficios exclusivos da liberty seguros no Clube Liberty", @"alert", nil]];
//    
//    NotificationBeans *beans2 = [[NotificationBeans alloc] initWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:@"10/07/2016", @"date", @"2, aproveite os seus beneficios exclusivos da liberty seguros no Clube Liberty", @"alert", nil]];
//    
//    NotificationBeans *beans3 = [[NotificationBeans alloc] initWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:@"10/07/2016", @"date", @"3, aproveite os seus beneficios exclusivos da liberty seguros no Clube Liberty https://www.libertyseguros.com.br", @"alert", nil]];
//    
//    NotificationBeans *beans4 = [[NotificationBeans alloc] initWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:@"10/07/2016", @"date", @"4, aproveite os seus beneficios exclusivos da liberty seguros no Clube Liberty", @"alert", nil]];
//    [arrayReturn addObject:beans];
//    [arrayReturn addObject:beans2];
//    [arrayReturn addObject:beans3];
//    [arrayReturn addObject:beans4];
////
//    for (NotificationBeans *not in arrayReturn) {
//        [self insertNotification:not];
//    }
//
//    if(delegate && [delegate respondsToSelector:@selector(returnNotifications:)]){
//        [delegate returnNotifications:[self getStoragedNotifications]];
//    }
//
//    return;
    
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers error:&error];
    //    To Reset notifications badge number
    [[UIApplication sharedApplication]  setApplicationIconBadgeNumber:0];
    if(!error){
        if([result isKindOfClass:[NSDictionary class]] &&  [result objectForKey:@"message"] != nil && [result objectForKey:@"message"] != [NSNull null] && ![[result objectForKey:@"message"] isEqualToString:@""]){
//            
//            if(delegate && [delegate respondsToSelector:@selector(notificationsError:)]){
//                [delegate notificationsError:[result objectForKey:@"message"]];
//            }
            if(delegate && [delegate respondsToSelector:@selector(returnNotifications:)]){
                [delegate returnNotifications:[self getStoragedNotifications]];
            }
            [self closeDataBase];
            
            return;
        }else{
//            NSMutableArray *arrayReturn = [[NSMutableArray alloc] init];
            if([result isKindOfClass: [NSArray class]]){
                for (NSDictionary *dic in result) {
                    NotificationBeans *beans = [[NotificationBeans alloc] initWithDictionary:dic];
                    [self insertNotification:beans];
//                    [arrayReturn addObject:beans];
                }
            }

            if(delegate && [delegate respondsToSelector:@selector(returnNotifications:)]){
                [delegate returnNotifications:[self getStoragedNotifications]];
            }
            [self closeDataBase];
        }
    }
    
}


-(void) deleteNotification:(int)idNotification{
    if(!databaseOpenned){
        [self loadDataBase];
    }
    //[appDelegate getLoggeduser]
    NSString *query = [NSString stringWithFormat:@"DELETE FROM notifications WHERE id = %d", idNotification];
    
    [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (!error) {
            if (!finished) {
                
            }
        } else {
            NSLog(@"Error open database %@", error.localizedDescription);
        }
        
    }];
    
    [self closeDataBase];

    

}

-(void) loadDataBase{
    
    [[AFSQLManager sharedManager] openDocumentsDatabaseWithName:@"libertymobile.db" andStatusBlock:^(BOOL success, NSError *error) {
        databaseOpenned = success;
        if(!error){
            NSString *query = @"CREATE TABLE IF NOT EXISTS notifications (id INTEGER PRIMARY KEY AUTOINCREMENT, date STRING (11), alert STRING (255), cpfCnpj BIGINT)";
            [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
                if (!error) {
                    
                }
            }];
        }else{
            NSLog(@"Error open database %@", error.localizedDescription);
        }
    }];
    
 
}
-(void) closeDataBase{
    databaseOpenned = false;
    [[AFSQLManager sharedManager] closeLocalDatabase];
}

-(void) insertNotification:(NotificationBeans*) notification{
    if(!databaseOpenned){
        [self loadDataBase];
    }
    //[appDelegate getLoggeduser]
    NSString *query = [NSString stringWithFormat:@"INSERT INTO notifications (date,alert,cpfCnpj) VALUES ('%@','%@', %@) ", notification.date, notification.alert, [appDelegate getLoggeduser].cpfCnpj];
    
    [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (!error) {
            if (!finished) {
       
            }
        } else {
            NSLog(@"Error open database %@", error.localizedDescription);
        }
        
    }];
    

}

-(NSMutableArray *) getStoragedNotifications{
    if(!databaseOpenned){
        [self loadDataBase];
    }

    NSMutableArray *notificationsArray = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT id,date,alert FROM notifications WHERE cpfCnpj = %@ ORDER BY date DESC", [appDelegate getLoggeduser].cpfCnpj];

    [[AFSQLManager sharedManager] performQuery:query withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (!error) {
            if (!finished) {
                NotificationBeans *beans = [[NotificationBeans alloc] init];
                beans.idNotification = [[row objectAtIndex:0] intValue];
                beans.date = [row objectAtIndex:1];
                beans.alert = [row objectAtIndex:2];
                [notificationsArray addObject:beans];
            }
        } else {
            NSLog(@"Error open database %@", error.localizedDescription);
        }
        
    }];

    return notificationsArray;

}
-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);
    
}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    
    NSLog(@"Retorno erro conexão %@, %@", response , error);
    //    if(delegate && [delegate respondsToSelector:@selector(forgotError:)]){
    //        [delegate forgotError:NSLocalizedString(@"ConnectionError",@"") ];
    //    }
}
@end
