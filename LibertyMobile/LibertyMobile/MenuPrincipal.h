//
//  MenuPrincipal.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Constants.h"
#import "LoginViewController.h"
#import "MinhasApolicesViewController.h"
#import "DadosLoginSegurado.h"
#import <DirectAssistLib/DAAssistanceMenuAllViewController.h>
#import <DirectAssistLib/Utility.h>

@interface MenuPrincipal : UIViewController <LoginViewControllerDelegate, DAAssistanceMenuAllDelegate, CallWebServicesDelegate, UIActionSheetDelegate>
{
    IBOutlet UIActivityIndicatorView *indicator;
    
    IBOutlet UIView *viewButtons;
    
    IBOutlet UIScrollView *scrollView;
    
    NSManagedObjectContext *managedObjectContext;

    //DadosLoginSegurado *dadosLoginSegurado;
    
    Boolean callingLogonSeguradoToken;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

//@property (nonatomic, retain) DadosLoginSegurado *dadosLoginSegurado;

@property (nonatomic, retain)IBOutlet UIButton * btnMinhasApolices;
@property (nonatomic, retain)IBOutlet UIButton * btnLogin;
@property (nonatomic, retain)IBOutlet UIButton * btnCadastro;
@property (nonatomic, retain)IBOutlet UIButton * btnPoliticaPrivacidade;

-(IBAction)btnSetupPressed:(id)sender;
-(IBAction)btnComunicacaoAcidentePressed:(id)sender;
-(IBAction)btnAssistencia24HorasPressed:(id)sender;
-(IBAction)btnMinhasApolicesPressed:(id)sender;
-(IBAction)btnOficinasReferenciadasPressed:(id)sender;
-(IBAction)btnClubeLibertyVantagensPressed:(id)sender;
-(IBAction)btnAtendimentoPressed:(id)sender;
-(IBAction)btnPoliticaPrivacidadePressed:(id)sender;
-(IBAction)btnLoginPressed:(id)sender;
-(IBAction)btnCadastroPressed:(id)sender;

-(void)logout;
-(void)loginSegurado;
-(void)returnDirectAssist:(NSArray *)caseList;
-(void)gotoNotificacoes;

@end
