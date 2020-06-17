//
//  ContactTableViewCell.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ContactTableViewCell.h"
@import Firebase;

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_btPhone  addTarget:self action:@selector(callNumber) forControlEvents:UIControlEventTouchUpInside];
    [_btPhone2  addTarget:self action:@selector(callNumber2) forControlEvents:UIControlEventTouchUpInside];
    [_btSkype  addTarget:self action:@selector(callSkype) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)callNumber{
    
    [self doCall:_btPhone.titleLabel.text];
}
-(void)callNumber2{
    [self doCall:_btPhone2.titleLabel.text];

}

-(void) doCall:(NSString*) number{
    
    [FIRAnalytics logEventWithName:@"Atendimento" parameters:@{
                                                               kFIRParameterItemName:@"Ligação",
                                                               kFIRParameterValue : @"Atendimento" }];
        NSString *condensedPhoneNumber = [[number componentsSeparatedByCharactersInSet:
                                       [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"]
                                        invertedSet]]
                                      componentsJoinedByString:@""];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",condensedPhoneNumber]]];
}

-(void) callSkype{
    //
    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"skype:"]];
    if(installed)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"skype:libertyseguros_central?call"]]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/skype/id304878510?mt=8"]];
    }
}
@end
