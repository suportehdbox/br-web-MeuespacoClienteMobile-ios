//
//  IOHelper.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "IOHelper.h"
@interface IOHelper(){
    NSFileManager *fileManager;
    NSString *directory;
}
@end
@implementation IOHelper

- (id)init
{
    self = [super init];
    if (self) {
        fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        directory = [paths objectAtIndex:0];
    }
    return self;
}

-(BOOL) fileExists:(NSString*)fileName{
    if([fileManager fileExistsAtPath:[self getFinalPath:fileName]]){
        return YES;
    }
    return NO;
}

-(NSString*) getFinalPath:(NSString*)fileName{
    return [directory stringByAppendingPathComponent:fileName];
}

-(BOOL) saveFile:(NSData*)data fileName:(NSString*)fileName {
    
    if ([self fileExists:fileName]) {
        return FALSE;
    }
    
    
    if (![data writeToFile:[self getFinalPath:fileName] atomically:NO])
    {
        return FALSE;
        
    }
    
    return TRUE;
    
}

-(void) deleteFile:(NSString*)fileName {
    if (![self fileExists:fileName]) {
        return;
    }
    NSError *error;
    
    if(![fileManager removeItemAtPath:[self getFinalPath:fileName] error:&error]){
        NSLog(@"Error deleting file at: %@ - %@",[self getFinalPath:fileName], error.localizedDescription);
    }
    
}


-(NSData*) loadFile:(NSString*)fileName{
    if(![self fileExists:fileName]){
        return nil;
    }
    return [NSData  dataWithContentsOfFile:[self getFinalPath:fileName]];
}

@end
