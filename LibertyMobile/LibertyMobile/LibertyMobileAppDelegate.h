//
//  LibertyMobileAppDelegate.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MenuPrincipal.h"

@interface LibertyMobileAppDelegate : UIResponder <UIApplicationDelegate, CallWebServicesDelegate> {
    
    DadosLoginSegurado *dadosSegurado;

@private
    NSInteger bage;
	NSManagedObjectContext *managedObjectContext_;
	NSManagedObjectModel *managedObjectModel_;
	NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Clube Liberty
@property(nonatomic,retain)NSMutableArray * clubeLiberty;

// Dados do segurado
@property (nonatomic, retain) DadosLoginSegurado *dadosSegurado;


- (NSString *)applicationDocumentsDirectory;
-(void) alertErrorDB:(NSError *) error;
- (NSString *)applicationDocumentsDirectory;
- (void)saveState;
- (void)rollbackState;

-(void)atualizaDadosLoginSegurado:(DadosLoginSegurado *) dadosLoginSegurado;
-(void)reset;

@end
