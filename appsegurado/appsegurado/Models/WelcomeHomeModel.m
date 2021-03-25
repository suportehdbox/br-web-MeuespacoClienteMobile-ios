//
//  WelcomeHomeModel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "WelcomeHomeModel.h"
#import "Reachability.h"

@implementation WelcomeHomeModel
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) getUpdateRequired{
    conn = [[Conexao alloc] initWithURL:[NSString stringWithFormat:@"%@Acesso/UpdateRequired",[super getBaseUrl]] contentType:@"application/x-www-form-urlencoded"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [conn addGetParameters:version key:@"AppVersion"];
    [conn setDelegate:self];
    [conn setRetornoConexao:@selector(returnUpdateRequired:)];
    [conn startRequest];
}

-(void)returnUpdateRequired:(NSData *)responseData{
    NSLog(@"Response: %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                      options:NSJSONReadingMutableContainers error:&error];

    if(!error){
        if([result objectForKey:@"updateRequired"] != nil){
            if(delegate && [delegate respondsToSelector:@selector(returnUpdateRequired:)]){
                [delegate returnUpdateRequired:[[result objectForKey:@"updateRequired" ] boolValue]];
            }
        }
    }
}

-(void) getWelcomeBackgroundImage{
   
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
    NSString *urlString = @"";
    if([Config isAliroProject]){
        urlString = @"http://www.libertyseguros.com.br/MobileApp/aliro/Iphone/%@/1.jpg";
    }else{
        urlString = @"https://meuespaco.libertyseguros.com.br/SitePages/Deslogado/Imagens/Segurado/Iphone/%@/1.jpg";
    }
    
    
    if([[UIScreen mainScreen] bounds].size.height == 568){
        return [NSString stringWithFormat:urlString,@"5"];
    }else if([[UIScreen mainScreen] bounds].size.height == 667){
        return [NSString stringWithFormat:urlString,@"6"];
    }else if([[UIScreen mainScreen] bounds].size.height == 960){
        return [NSString stringWithFormat:urlString,@"6Plus"];
    }else{
        return [NSString stringWithFormat:urlString,@"4S"];
    }
}

-(void) downloadImage:(NSString*) imageUrl{
    //just init
    conn = [[Conexao alloc] initWithURL:@"http://www.libertyseguros.com.br/"];
    [conn setDelegate:self];
    [conn downloadImage:imageUrl object:nil];
}

-(void)retornaDownloadImage:(UIImage *)image object:(id)object{
    if(delegate != nil && [delegate respondsToSelector:@selector(updateBackgroundImage:)] && image != nil){
        [self saveImage:image];
        [delegate updateBackgroundImage:image];
    }
}

-(BOOL) cacheExpired{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastDateString = [defaults objectForKey:@"cached_date"];
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
    
    NSString *imagePath =[cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",@"cached"]];
    
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
    [defaults setObject:[dateFormatter stringFromDate:myDate] forKey:@"cached_date"];
}

-(UIImage*) loadCachedImage{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",@"cached"]];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
