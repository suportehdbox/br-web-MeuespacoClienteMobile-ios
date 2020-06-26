//
//  ClubModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 03/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClubModel.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface ClubModel (){
    Conexao *connImage;
    AppDelegate *appDelegate;
}

@end
@implementation ClubModel
@synthesize delegate;

- (id) init
{
    self = [super init];
    if (self) {
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
    }
    return self;
}

-(NSUserDefaults*) getUserDefault {
    return [[NSUserDefaults alloc] initWithSuiteName:[appDelegate getCPF]];
}
-(BOOL) getAlreadyAgreed {
    if(![appDelegate isUserLogged]){
        return false;
    }
    return [[self getUserDefault] boolForKey:@"agreed_club"];
}

-(void) setAgreedTerms {
    if(![appDelegate isUserLogged]){
        return;
    }
    NSUserDefaults *defaults = [self getUserDefault];
    [defaults setBool:YES forKey:@"agreed_club"];
    [defaults synchronize];
}

-(void) getClientSession{
    
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Segurado/Clube",[super getBaseUrl:@"v3"]] contentType:@"application/x-www-form-urlencoded"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [conn addHeaderValue:[NSString stringWithFormat:@"Bearer %@",[appDelegate getLoggeduser].access_token] field:@"Authorization"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnSession:)];
    [conn startRequest];
    
}


-(void)returnSession:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    
    NSError *error;
    
    
    id result = [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers error:&error];
    
    if(!error){
        if([result isKindOfClass:[NSDictionary class]]){
            
            if([result objectForKey:@"message"] != [NSNull null] && ![[result objectForKey:@"message"] isEqualToString:@""]){
                if(delegate && [delegate respondsToSelector:@selector(clubeError:)]){
                    [delegate clubeError:[result objectForKey:@"message"]];
                }
            }else{
                @try {
                    
                    if(delegate && [delegate respondsToSelector:@selector(clubeSession:url:)]){
                        NSString *token = [result objectForKey:@"token"] == nil ? @"" : [result objectForKey:@"token"];
                        [delegate clubeSession:token url:[result objectForKey:@"url"]];
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"Exception %@", exception.description);
                    if(delegate && [delegate respondsToSelector:@selector(clubeError:)]){
                        [delegate clubeError:NSLocalizedString(@"ErroNoSerivdor",@"")];
                    }
                }
            }
            
        }
        
    }else{
        
        
        
        //        if(delegate && [delegate respondsToSelector:@selector(policyError:)]){
        //            [delegate policyError:NSLocalizedString(@"ConnectionError",@"") ];
        //        }
        
        
    }
}



-(void)retornaErroConexao:(NSDictionary *)dictUserInfo response:(NSURLResponse *)response error:(NSError *)error{
    if(delegate && [delegate respondsToSelector:@selector(clubeError:)]){
        [delegate clubeError:error.localizedDescription];
    }
}

//Controle Imagem

-(void) getClubImage{
    
    Reachability *reach = [Reachability reachabilityForLocalWiFi];
    NetworkStatus networkStatus = [reach currentReachabilityStatus];
    if ([self cacheExpired] || networkStatus == ReachableViaWiFi) {
        //over wifi
        [self downloadImage:[self getDownloadUrl]];
    }else{
        //over local data connection
        UIImage *image = [self loadCachedImage];
        if(image != nil){
            [self retornaDownloadImage:image object:nil];
        }else{
            [self downloadImage:[self getDownloadUrl]];
        }
        
    }
}

-(NSString*) getDownloadUrl{
    
    NSString *urlString = @"http://www.libertyseguros.com.br/MobileApp/segurado/iphone/%@/club.png";
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        return [NSString stringWithFormat:urlString,@"5"];
    }else if([[UIScreen mainScreen] bounds].size.height == 667){
        return [NSString stringWithFormat:urlString,@"6"];
    }else if([[UIScreen mainScreen] bounds].size.height == 960){
        return [NSString stringWithFormat:urlString,@"6Plus"];
    }else{
        return [NSString stringWithFormat:urlString,@"5"];
    }
}

-(void) downloadImage:(NSString*) imageUrl{
    //just init
    connImage = [[Conexao alloc] initWithURL:@"http://www.libertyseguros.com.br/"];
    [connImage setDelegate:self];
    [connImage downloadImage:imageUrl object:nil];
}

-(void)retornaDownloadImage:(UIImage *)image object:(id)object{
    if(delegate != nil && [delegate respondsToSelector:@selector(updateClubImage:)] && image != nil){
        [self saveImage:image];
        [delegate updateClubImage:image];
    }
}

-(BOOL) cacheExpired{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastDateString = [defaults objectForKey:@"cached_date_club"];
    if(lastDateString == nil || [lastDateString isEqualToString:@""]){
        return false;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *dateNow = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate * lastDate = [dateFormatter dateFromString:lastDateString];
    CGFloat difDays = [dateNow timeIntervalSinceDate:lastDate] / (24.0 * 60.0 * 60.0);
    if(difDays > 5){
        return true;
    }
    return false;
}

-(void) saveImage:(UIImage*) image{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",@"cachedClub"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if([fileManager fileExistsAtPath:imagePath]){
        if (![fileManager removeItemAtPath:imagePath error:&error]) {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
    
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *myDate = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [defaults setObject:[dateFormatter stringFromDate:myDate] forKey:@"cached_date_club"];
}

-(UIImage*) loadCachedImage{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",@"cachedClub"]];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}


@end
