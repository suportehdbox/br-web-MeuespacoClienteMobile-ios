//
//  LS_TextField_TableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/27/12.
//
//

#import <UIKit/UIKit.h>

@interface LS_TextField_TableViewCell : UITableViewCell {
    UITextField* txt_cadastro;
    UIButton* btn_apagar;
    UIButton* btn_olho;
    UIView* linha;
    UILabel* tvw_cadastro;
    bool isPwd;
}

@property(nonatomic,retain)IBOutlet UITextField* txt_cadastro;
@property(nonatomic,retain)IBOutlet UIButton* btn_olho;
@property(nonatomic,retain)IBOutlet UIButton* btn_apagar;
@property(nonatomic,retain)IBOutlet UIView* linha;
@property(nonatomic,retain)IBOutlet UILabel* tvw_cadastro;

//Configurar a visibilidade
- (void)setup:(BOOL)ispwd;

- (void)showErro:(NSString*) errorMsg;

@end
