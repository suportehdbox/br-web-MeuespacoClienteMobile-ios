//
//  AutoWorkShopModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 22/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@protocol AutoWorkShopModelDelegate <NSObject>

-(void) locationManagerAuthorizationDenied;
-(void) locationZipCodeNotFound;
-(void) addressFoundSearchShops;
-(void) returnAutoWorkShops:(NSMutableArray*)arrayShops;
-(void) returnErrorAutoWorkShops;
-(void) returnErrorOpenRoute:(NSString*) appName;
@end
@interface AutoWorkShopModel : BaseModel <ConexaoDelegate, CLLocationManagerDelegate>


typedef enum {
    Nearest  = 0,
    Score = 1,
} NSKindSearch;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,weak) id<AutoWorkShopModelDelegate> delegate;
@property (nonatomic) NSKindSearch kindSearch;
-(id)init;
-(void) getNearestAutoWorkShop;
-(void) searchAutoWorksByAddress:(NSString *)address andCEP:(NSString *)CEP;
-(void) searchAutoWorksByCEP:(NSString *)CEP;
-(void) openRouteApp:(NSString*)latitude longitude:(NSString*)longitude destination:(NSString*) destination;
-(BOOL) shouldShowInfo;
-(void) repeatLastConnection;
@end
