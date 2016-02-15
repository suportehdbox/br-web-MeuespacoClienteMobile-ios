//
//  AtendimentoViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AtendimentoViewController : UIViewController  <UIAlertViewDelegate>
{
    UITableView *camposTableView;
}

//Property
@property (nonatomic, retain) IBOutlet UITableView *camposTableView;

- (IBAction)btnCancelarAtendimento:(id)sender;
- (IBAction)btnAtendimentoCapital:(id)sender;
- (IBAction)btnAtendimentoLocalidades:(id)sender;
- (IBAction)btnAssistenciaAutoVida:(id)sender;
- (IBAction)btnAssistenciaEmpresas:(id)sender;

@end
