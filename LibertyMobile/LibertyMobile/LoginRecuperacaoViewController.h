//
//  LoginRecuperacaoViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 12/12/12.
//
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CallWebServices.h"
#import "DadosLoginSegurado.h"
#import "LibertyMobileViewController.h"

@interface LoginRecuperacaoViewController : LibertyMobileViewController <CallWebServicesDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *arrayFields;

    NSString *userName;
    NSString *cpf;
    NSString *email;
    
    UIActivityIndicatorView *indicator;
    
    NSInteger               MAX_FIELD_TAG;
}

//Property
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *cpf;
@property (nonatomic,retain) NSString *email;

//- (IBAction)btnCancelar:(id)sender;

@end
