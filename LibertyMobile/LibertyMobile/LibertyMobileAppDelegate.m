 //
//  LibertyMobileAppDelegate.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LibertyMobileAppDelegate.h"
#import "KeychainItemWrapper.h"
#import "NotificacaoConsultaViewController.h"

@implementation LibertyMobileAppDelegate

@synthesize window;
@synthesize navigationController;

//Clube Liberty
@synthesize clubeLiberty;

//Dados do segurado logado
@synthesize dadosSegurado;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GoogleAnalyticsManager initialize];
    [GoogleAnalyticsManager send:@"Menu Principal"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navigationController = [[UINavigationController alloc] init];
    
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    
    MenuPrincipal *viewController = [[[MenuPrincipal alloc] init] autorelease];
    viewController.managedObjectContext = self.managedObjectContext;
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    [self.window makeKeyAndVisible];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    /*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"local" message:[launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];

    
    UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"remote" message:[launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView2 show];
    */
    
    //-- check if there is some pending push notification
    /*
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *notificacao = [userInfo objectForKey:@"aps"];
    if(notificacao) {
    */
    //UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        /*
        //NSString *json = [localNotif valueForKey:@"data"];
        // Parse your string to dictionary
        NSDictionary *notificacao = [localNotif valueForKey:@"aps"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[notificacao description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        // adiciona notificação na lista:
        [NotificacaoConsultaViewController addAndSaveNotificationPlist:[notificacao mutableCopy]];
        */
    
        /*    // TODO temporariamente desabilitado:
        // set badgenumber : badge pendentes + badge da notificaçao anterior da execucao do app
        bage = [[UIApplication sharedApplication] applicationIconBadgeNumber] + [[userInfo objectForKey:@"badge"]intValue];
        
        [[UIApplication sharedApplication] applicationIconBadgeNumber];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:bage];
         */
        
        // Show the desired viewController in this if block        
        [viewController gotoNotificacoes];
    }
    
    //-- Set Notification - Let the device know we want to receive push notifications
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
                [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound
                                                              | UIUserNotificationTypeAlert
                                                              | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    } else{
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
                (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert
                 | UIRemoteNotificationTypeSound)];
    }
    NSLog(@"Set Notification ");
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self reset];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //TODO possivel verificacao se recebeu PUsh
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
        //TODO possivel verificacao se recebeu PUsh
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc {
	
	[managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
    navigationController = nil;
    window = nil;
    
    [dadosSegurado release];
	
    [super dealloc];
}



#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"LibertyMutual" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    //Open SQLite in Version 2
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"LibertyMutualV2.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
		if (error != nil) {
            [self alertErrorDB:error];
			[error release];
		}
    }    
    
    return persistentStoreCoordinator_;
}

// TODO: Not sure all saving should take place here
- (void) saveState {
	NSError *error = nil;
	if (managedObjectContext_ != nil) {
		NSLog(@"LibertyMobileAppDelegate Changes Found");
		if ([managedObjectContext_ save:&error]) {
			NSLog(@"LibertyMobileAppDelegate Saved");
		}
		else {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			if (error != nil) {
				[self alertErrorDB:error];
				[error release];
			}
		} 
	}
}


- (void) rollbackState 
{
	if (managedObjectContext_ != nil) 
    {
		[managedObjectContext_ rollback];
	}
}

-(void) alertErrorDB:(NSError *) error
{
	NSLog(@"Unresolved error %@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aperte o botão de iniciar para sair" 
													message:[NSString stringWithFormat:@"An error has occurred.:\n\nFully terminate the app from background and reopen.\n\n %@.", [error localizedDescription]]
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}



#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Atualiza Dados Segurado
-(void)atualizaDadosLoginSegurado:(DadosLoginSegurado *) dadosLoginSegurado
{
 
    self.dadosSegurado.cpf = dadosLoginSegurado.cpf;
    self.dadosSegurado.tokenAutenticacao = dadosLoginSegurado.tokenAutenticacao;
    self.dadosSegurado.tokenNotificacao = dadosLoginSegurado.tokenNotificacao;
    self.dadosSegurado.logado = dadosLoginSegurado.logado;
    self.dadosSegurado.minhasApolices = dadosLoginSegurado.minhasApolices;
    self.dadosSegurado.minhasApolicesAnteriores = dadosLoginSegurado.minhasApolicesAnteriores;
    
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"LibertySeguros" accessGroup:nil];
    
    if (nil != self.dadosSegurado.tokenAutenticacao) {
        [keychain setObject:self.dadosSegurado.tokenAutenticacao forKey:(id)kSecAttrDescription];
        
        if (nil != self.dadosSegurado.cpf) {
            [keychain setObject:self.dadosSegurado.cpf forKey:(id)kSecAttrAccount];
        }
        if (nil != self.dadosSegurado.tokenNotificacao) {
            [keychain setObject:self.dadosSegurado.tokenNotificacao forKey:(id)kSecAttrComment];
        }
        
    }else{
        [keychain resetKeychainItem];
    }
    [keychain release];

}


#pragma  mark - limpa dados off-line

-(void)reset
{
    /*N'ao pode dar reset no cookie quando pausa a app para nao invalidar a sessao
    / EPO: reset nos dados do cookie/
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }*/
    
    // EPO: reset no clube liberty
    [self setClubeLiberty:nil];
    
    // EPO: reset dados do segurado para consulta ficar atualizada
    dadosSegurado.minhasApolices = nil;
    dadosSegurado.minhasApolicesAnteriores = nil;
}

#pragma  mark - Push Notification

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *tokenNotificacao = [[[[deviceToken description]
                                        stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"Device Token: %@", tokenNotificacao);

    //--  Verifica se usuário escolheu "manterLogado" e se "tokenNotificacao" foi renovado
    // caso positivo envia tokenNotificação:

    NSString* tokenAutenticacao = [dadosSegurado tokenAutenticacao];
    if (nil != tokenAutenticacao && ![tokenAutenticacao isEqual:@""])
    {
        if (![[dadosSegurado tokenNotificacao] isEqual:tokenNotificacao])
        {
            [dadosSegurado setTokenNotificacao:tokenNotificacao];
            
            // send the device token to Provider Liberty
            CallWebServices *callWs = [[[CallWebServices alloc] init] autorelease];
            [callWs callEnviarToken:self cpfCnpj:[dadosSegurado cpf] tokenNotificacao:tokenNotificacao];
        }
    }
    else
    {
        // caso não "manterLogado" apenas persiste na memória aguardando usuário fazer Login
        [dadosSegurado setTokenNotificacao:tokenNotificacao];
    }
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // TODO - correct way for ERROR
	NSLog(@"Failed to get token, error: %@", error);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSMutableDictionary *notificacao = [userInfo valueForKey:@"aps"];
    
    // adiciona notificação na lista:    
    [NotificacaoConsultaViewController addAndSaveNotificationPlist:[notificacao mutableCopy]];

    
    /*     // TODO temporariamente desabilitado:
    // set badgenumber
    bage += [[notificacao objectForKey:@"badge"]intValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:bage];
     */
    
    if (application.applicationState == UIApplicationStateActive){
        
        // Caso esteje na view de `notificação` atualiza a tableView
        UIViewController *presentingView = [self.navigationController visibleViewController];
        if ([presentingView isKindOfClass:[NotificacaoConsultaViewController class]]) {
            [((NotificacaoConsultaViewController*)presentingView) viewDidLoad];
            [[((NotificacaoConsultaViewController*)presentingView) consultaTableView] reloadData];
        }
        
        // if applicationState is Active display alert view.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[notificacao objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    else {
        // Show the desired viewController in this if block
        [((MenuPrincipal*)[[self.navigationController viewControllers] objectAtIndex:0]) gotoNotificacoes];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    /*
    NSMutableDictionary *notificacao = [userInfo valueForKey:@"aps"];
    
    // if applicationState is Active display alert view.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[notificacao objectForKey:@"alert"]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
     */
    NSMutableDictionary *notificacao = [userInfo valueForKey:@"aps"];
    
    // adiciona notificação na lista:
    [NotificacaoConsultaViewController addAndSaveNotificationPlist:[notificacao mutableCopy]];
    
    if (application.applicationState == UIApplicationStateActive){
        
        // Caso esteje na view de `notificação` atualiza a tableView
        UIViewController *presentingView = [self.navigationController visibleViewController];
        if ([presentingView isKindOfClass:[NotificacaoConsultaViewController class]]) {
            [((NotificacaoConsultaViewController*)presentingView) viewDidLoad];
            [[((NotificacaoConsultaViewController*)presentingView) consultaTableView] reloadData];
        }
        
        // if applicationState is Active display alert view.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:[notificacao objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    else {
        // Show the desired viewController in this if block
        [((MenuPrincipal*)[[self.navigationController viewControllers] objectAtIndex:0]) gotoNotificacoes];
    }
    
    /*     // TODO temporariamente desabilitado:
    // set badgenumber
    bage += [[notificacao objectForKey:@"badge"]intValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:bage];
     */
}


#pragma mark Delegate de CallWebServices

- (void)callWebServicesDidFinish:(CallWebServices *)call
{
    if (call.typeCall == LMCallWsEnviarToken) {
        
        bool returnEnviarToken = [call retEnviarToken];
        
        if (returnEnviarToken)
        {
            /*//Atualiza status de que não precisa EnviarToken!
            LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate atualizaDadosLoginSegurado:dadosSegurado];
             */
        }
    }
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error
{
    //[Util viewMsgErrorConnection:self codeError:error];
}

@end


@implementation UINavigationController (iOS6OrientationFix)


-(NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    // << EPO
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
    // >>
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end