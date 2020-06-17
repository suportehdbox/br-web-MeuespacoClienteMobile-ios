//
//  IOHelper.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOHelper : NSObject

-(id)init;
-(BOOL) fileExists:(NSString*)fileName;
-(NSData*) loadFile:(NSString*)fileName; //Returns nill when file not exists
-(BOOL) saveFile:(NSData*)data fileName:(NSString*)fileName; //Return Success state
-(void) deleteFile:(NSString*)fileName; //Delete File
@end
