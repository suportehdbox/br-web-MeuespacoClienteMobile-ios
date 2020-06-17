//
//  AutoWorkShopModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 22/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "AutoWorkShopModel.h"
#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "AppDelegate.h"
@import Firebase;

@interface AutoWorkShopModel(){
    CLGeocoder *geocoder;
    NSString *latRoute;
    NSString *longRoute;
    NSString *lastAddress;
    NSString *lastCep;
}

@end
@implementation AutoWorkShopModel

@synthesize locationManager,delegate, kindSearch;

- (id)init
{
    self = [super init];
    if (self) {
        kindSearch = Score;
        lastAddress = @"";
        lastCep = @"";
    }
    
    
    
    return self;
}

-(void) getNearestAutoWorkShop{
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

-(void) searchAutoWorksByAddress:(NSString *)address andCEP:(NSString *)CEP{
    lastAddress = address;
    lastCep = CEP;
    
    if([CEP isEqualToString:@""]){
        [self getZipCodeFromAddress:address];
    }else{
        conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Oficina/",[super getBaseUrl]]];
        //[conn addGetParameters:@"99999" key:@"UserId"];
        
//        if(![address isEqualToString:@""]){
            [conn addGetParameters:address key:@"address"];
//        }
        [conn addGetParameters:[CEP stringByReplacingOccurrencesOfString:@"-" withString:@""] key:@"CEP"];
       
        if(kindSearch == Nearest){
            [conn addGetParameters:@"Distancia" key:@"TipoPesquisa"];
        }else{
            [conn addGetParameters:@"Score" key:@"TipoPesquisa"];
        }
        
        [conn addGetParameters:@"30" key:@"Radius"];
        [conn setDelegate:self];
        [conn setRetornoConexao:@selector(returnNearestAutoWork:)];
        [conn startRequest];
    }

    
}
-(void) searchAutoWorksByCEP:(NSString *)CEP{
    lastCep = CEP;
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Oficina/",[super getBaseUrl]]];
    [conn addGetParameters:[CEP stringByReplacingOccurrencesOfString:@"-" withString:@""] key:@"CEP"];
    [conn addGetParameters:@"30" key:@"Radius"];
    
    if(kindSearch == Nearest){
        [conn addGetParameters:@"Distancia" key:@"TipoPesquisa"];
    }else{
        [conn addGetParameters:@"Score" key:@"TipoPesquisa"];
    }
    
    
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnNearestAutoWork:)];
    [conn startRequest];
    
    
}


-(void) repeatLastConnection{
    
    if([lastAddress isEqualToString:@""]){
        [self searchAutoWorksByCEP:lastCep];
        return;
    }
    
    [self searchAutoWorksByAddress:lastAddress andCEP:lastCep];
}

-(void)returnNearestAutoWork:(NSData *)responseData{
    NSError *error;
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    NSArray *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                      options:NSJSONReadingMutableContainers error:&error];
    
    NSMutableArray *arrayWithObjs = [[NSMutableArray alloc] init];
    if(!error){
        for (NSDictionary *obj in result) {
            MapPin *pin = [[MapPin alloc] initWithAutoWorkShop:[[AutoWorkShopBeans alloc] initWithDicionary:obj]];
            [arrayWithObjs addObject:pin];
        }
    }
    
//    if([arrayWithObjs count] > 0 ){
        if(delegate && [delegate respondsToSelector:@selector(returnAutoWorkShops:)]){
            [delegate returnAutoWorkShops:arrayWithObjs];
        }
//    }else{
//        if(delegate && [delegate respondsToSelector:@selector(returnErrorAutoWorkShops)]){
//            [delegate returnErrorAutoWorkShops];
//        }
//    }

    
}

-(void)retornaConexao:(NSURLResponse *)response responseString:(NSString *)responseString{
    
    NSLog(@"Retorno Conexao [%@] \n\n %@",response, responseString);

}

-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{

    NSLog(@"Retorno erro conexão %@, %@", response , error);
    if(delegate && [delegate respondsToSelector:@selector(returnErrorAutoWorkShops)]){
        [delegate returnErrorAutoWorkShops];
    }
    //
}



-(void)locationManager:(CLLocationManager *)mangar didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted){
        delegate != nil ? [delegate locationManagerAuthorizationDenied] : NSLog(@"Delegate null");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [locationManager stopUpdatingLocation];
    
    if (!geocoder)
        geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if(!error){
             if ([placemarks count] > 0)
             {
                 CLPlacemark *place = [placemarks objectAtIndex:0];
                 NSLog(@"Placemark %@", place);
                 NSString *postCodeExt = @"000";
                 if([place.addressDictionary objectForKey:@"PostCodeExtension"] != nil){
                     postCodeExt = [place.addressDictionary objectForKey:@"PostCodeExtension"];
                 }
                 
                 NSString *zip = @"";
                 if(![[place.addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey] containsString:@"-"]){
                    zip = [NSString stringWithFormat:@"%@-%@",[place.addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey], postCodeExt];
                 }else{
                     zip = [place.addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey];
                 }
                 

                 if(delegate && [delegate respondsToSelector:@selector(addressFoundSearchShops)]){
                     [delegate addressFoundSearchShops];
                 }
                 [self searchAutoWorksByCEP:zip];
             }else{
                 if(delegate && [delegate respondsToSelector:@selector(locationZipCodeNotFound)]){
                     [delegate locationZipCodeNotFound];
                 }
             }
         }else{
             if(delegate && [delegate respondsToSelector:@selector(locationZipCodeNotFound)]){
                 [delegate returnErrorAutoWorkShops];
             }
         }
     }];

}


-(void) getZipCodeFromAddress:(NSString*) address{
    if (!geocoder)
        geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:address  completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if(!error){
             if ([placemarks count] > 0)
             {
                 CLPlacemark *place = [placemarks objectAtIndex:0];
                 NSLog(@"Placemark %@", place);
                 NSString *postCodeExt = @"000";
                 if([place.addressDictionary objectForKey:@"PostCodeExtension"] != nil){
                     postCodeExt = [place.addressDictionary objectForKey:@"PostCodeExtension"];
                 }
                 
                 NSString *zip = [NSString stringWithFormat:@"%@-%@",[place.addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey], postCodeExt];
                 if(delegate && [delegate respondsToSelector:@selector(addressFoundSearchShops)]){
                     [delegate addressFoundSearchShops];
                 }
                 [self searchAutoWorksByCEP:zip];
             }else{
                 if(delegate && [delegate respondsToSelector:@selector(locationZipCodeNotFound)]){
                     [delegate locationZipCodeNotFound];
                 }
             }
         }else{
             if(delegate && [delegate respondsToSelector:@selector(locationZipCodeNotFound)]){
                 [delegate locationZipCodeNotFound];
             }
         }
     }];

}

-(void) openRouteApp:(NSString*)latitude longitude:(NSString*)longitude destination:(NSString*) destination{
//    latitude = @"-23.6619190";
//    longitude = @"-46.5296640";

    [FIRAnalytics logEventWithName:@"Busca de Oficinas" parameters:@{
                                                               kFIRParameterItemName:@"Clique",
                                                               kFIRParameterValue : @"Traçar Rota"
                                                               }];
//    [GoogleAnalyticsManager sendActionScreen:@"Busca de Oficinas" event:@"Clique" label:@"Traçar Rota"];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"AbrirAppRota", @"")
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* appleMapsAction = [UIAlertAction actionWithTitle:@"Apple Maps" style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {
                                          Class mapItemClass = [MKMapItem class];
                                              if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
                                              {
                                                  // An MKMapItem which we will pass to Maps app.
                                                  // I'm using properties from my Shop object.
                                                  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue);
                                                  MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
                                                  MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                                                  [mapItem setName:destination];
                                                  // Set the directions mode to "Driving"
                                                  NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
                                                  // Get the "Current User Location" MKMapItem
                                                  MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                                                  // Pass the current location and destination map items to the Maps app
                                                  [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
                                              }
                                      }];

    UIAlertAction* wazeAction = [UIAlertAction actionWithTitle:@"Waze" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                                // Waze is installed. Launch Waze and start navigation
                                                NSString *urlStr =
                                                [NSString stringWithFormat:@"waze://?ll=%@,%@&navigate=yes",
                                                 latitude, longitude];
                                                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                                                }else {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {
//                                                        if(!success){
//                                                            if(delegate != nil && [delegate respondsToSelector:@selector(returnErrorOpenRoute:)]){
//                                                                [delegate returnErrorOpenRoute:@"Waze"];
//                                                            }
//                                                        }
                                                    }];
                                                }
                                   }];
    
    UIAlertAction* mapsAction = [UIAlertAction actionWithTitle:@"Google Maps" style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {

                                               NSString *urlStr =
                                               [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@,%@&directionsmode=driving",
                                                latitude, longitude];
                                               if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                                               } else {
                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {
//                                                       if(success){
//                                                           if(delegate != nil && [delegate respondsToSelector:@selector(returnErrorOpenRoute:)]){
//                                                               [delegate returnErrorOpenRoute:@"Google Maps"];
//                                                           }
//                                                       }
                                                   }];
                                               }
                                           }];
    
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancelar", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]){
        [alert addAction:wazeAction];
    }
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        [alert addAction:mapsAction];
    }
    [alert addAction:appleMapsAction];
    [alert addAction:cancelAction];
    
    [[self getTopViewController] presentViewController:alert animated:YES completion:nil];

}

- (UIViewController *)getTopViewController {
    UIViewController *topViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topViewController.presentedViewController) topViewController = topViewController.presentedViewController;
    
    return topViewController;
}

-(BOOL) shouldShowInfo{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    BOOL returnInfo = [defaults boolForKey:@"showedInfo"];
    [defaults setBool:YES forKey:@"showedInfo"];
    [defaults synchronize];
    
    return !returnInfo;
}
@end
