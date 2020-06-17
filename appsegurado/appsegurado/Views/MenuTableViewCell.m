//
//  MenuTableViewCell.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "BaseView.h"
@interface MenuTableViewCell(){
    UIColor * bgColor;
}
@end
@implementation MenuTableViewCell
@synthesize imgIcon,lblTitle;



- (void)awakeFromNib {
    [super awakeFromNib];
    if(bgColor == nil){
        bgColor = [BaseView getColor:@"FundoMenu"];
    }
    [lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [lblTitle setTextColor:[BaseView getColor:@"Branco"]];
    [imgIcon setContentMode:UIViewContentModeCenter];
    
    [self setBackgroundColor:bgColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected){
        self.backgroundColor = [BaseView getColor:@"MenuSelecionado2"];
        self.selectedBackgroundView.backgroundColor = [BaseView getColor:@"MenuSelecionado2"];
    }else{
        self.backgroundColor = bgColor;
        self.selectedBackgroundView.backgroundColor = bgColor;
    }
    // Configure the view for the selected state
}
-(void)setBackgroundCellColor:(UIColor *)backgroundColor{
    [self setBackgroundColor:backgroundColor];
    bgColor = backgroundColor;
}
@end
