//
//  GoogleAnalyticsManager.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/29/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GoogleAnalyticsManager : NSObject {
    
}

+(void)initialize;
+(void)send:(NSString *)screen;

@end
