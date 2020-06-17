//
//  AgentContactViewCell.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "AgentContactViewCell.h"

@implementation AgentContactViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_btPhone  addTarget:self action:@selector(callNumber) forControlEvents:UIControlEventTouchUpInside];
    [_btMail  addTarget:self action:@selector(openMail) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)callNumber{
    [self doCall:_btPhone.titleLabel.text];
}

-(void)openMail{
    NSString *toEmail= _btMail.titleLabel.text;
    //opens mail app with new email started
    NSString *email = [NSString stringWithFormat:@"mailto:%@", toEmail];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void) doCall:(NSString*) number{
    NSString *condensedPhoneNumber = [[number componentsSeparatedByCharactersInSet:
                                       [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"]
                                        invertedSet]]
                                      componentsJoinedByString:@""];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",condensedPhoneNumber]]];
}

@end
