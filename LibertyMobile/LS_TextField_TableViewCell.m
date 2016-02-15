//
//  TextFullFieldTableViewCell.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/27/12.
//
//

#import "LS_TextField_TableViewCell.h"
#import "Util.h"

@implementation LS_TextField_TableViewCell

@synthesize txt_cadastro;
@synthesize btn_apagar;
@synthesize btn_olho;
@synthesize linha;
@synthesize tvw_cadastro;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setup:(BOOL)ispwd
{
    isPwd = ispwd;
    [tvw_cadastro setHidden:true];
    [btn_olho setHidden:true];
    [btn_apagar setHidden:true];
    
    [linha setBackgroundColor:[Util colorwithHexString:@"#ABABAB" alpha:1.0]];
    
    txt_cadastro.secureTextEntry = isPwd;
}

- (void)showErro:(NSString*) errorMsg
{
    if (nil == errorMsg ||[errorMsg isEqualToString:@""] )
    {
        [self clearErro];
    }
    else
    {
        [linha setBackgroundColor:[Util colorwithHexString:@"#E31C23" alpha:1.0]];
        [tvw_cadastro setText:errorMsg];
        [tvw_cadastro setHidden:false];
    }
}

- (void)clearErro
{
    [linha setBackgroundColor:[Util colorwithHexString:@"#ABABAB" alpha:1.0]];
    [tvw_cadastro setText:@""];
    [tvw_cadastro setHidden:true];
}

-(IBAction)btnApagar:(id)sender
{
    [txt_cadastro setText:@""];
}

-(IBAction)btnOlho:(id)sender
{
    if([btn_olho isSelected]){
        txt_cadastro.secureTextEntry = YES;
    }else{
        txt_cadastro.secureTextEntry = NO;
    }    
    btn_olho.selected = !btn_olho.selected;
}

-(IBAction)txtEditingDidBegin:(id)sender
{
    [linha setBackgroundColor:[Util colorwithHexString:@"#3F72CE" alpha:1.0]];
    
    if (isPwd) {
        [btn_olho setHidden:NO];
    }else{
        [btn_apagar setHidden:NO];
    }
    
}

-(IBAction)txtEditingDidEnd:(id)sender
{
    [linha setBackgroundColor:[Util colorwithHexString:@"#ABABAB" alpha:1.0]];
    
    if (isPwd) {
        [btn_olho setHidden:YES];
    }else{
        [btn_apagar setHidden:YES];
    }
}

@end
