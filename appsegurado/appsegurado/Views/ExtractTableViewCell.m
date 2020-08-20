//
//  ExtractTableViewCell.m
//  appsegurado
//
//  Created by Luiz Zenha on 04/06/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//

#import "ExtractTableViewCell.h"
#import "BaseView.h"


@implementation HeaderExtractTableViewCell
@synthesize title, icon, bg;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) addShadow{
    self.backgroundColor = [BaseView getColor:@"CinzaFundo"];
    [self.contentView setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [BaseView addDropShadow:bg];
}

@end

@implementation FooterExtractTableViewCell
@synthesize lblTotal, lblPhrase, lblValueTotal, bg;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void) addShadow{
    self.backgroundColor = [BaseView getColor:@"CinzaFundo"];
    [self.contentView setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [BaseView addDropShadow:bg];
}
@end

@implementation ExtractTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) configLayout:(NSDirection)direction beans:(Vision360EventBeans *)beans indexPath:(NSString*)indexPath{
    self.backgroundColor = [BaseView getColor:@"CinzaFundo"];
    [self.contentView setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
     [BaseView addDropShadow:_bg];
    _viewNumber.layer.cornerRadius = _viewNumber.frame.size.width/2;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssSSSZ"];
    NSString *textDate =  beans.dateOc;
    NSDate *dateCurrent = [dateFormatter dateFromString:textDate];
    
    NSDateFormatter *mothForm = [[NSDateFormatter alloc] init];
    [mothForm setDateFormat:@"MMM"];
    
    [_mounthLabel setText:[mothForm stringFromDate:dateCurrent]];
    
    
    NSDateFormatter *dayForm = [[NSDateFormatter alloc] init];
    [dayForm setDateFormat:@"d"];
    
    //[_lblNumber setText:[dayForm stringFromDate:dateCurrent]];
    [_lblNumber setText:[NSString stringWithFormat:@"%@", indexPath]];
    
    
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:beans.description attributes:@{
                                                                                                                        NSForegroundColorAttributeName : [BaseView getColor:@"AzulEscuro"],
                                                                                                                        NSBackgroundColorAttributeName : [BaseView getColor:@"CinzaFundo"],
                                                                                                                        }];
    [_lblTitle setAttributedText:title];
    
    [_vlineTop setHidden:NO];
    [_vlineBot setHidden:NO];
    if(direction == NSTop){
        [_vlineBot setHidden:YES];
    }else if(direction == NSBottom){
        [_vlineTop setHidden:YES];
    }else if(direction == NSNone){
        [_vlineTop setHidden:YES];
        [_vlineBot setHidden:YES];
    }
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_lblValue setText:[formatter stringFromNumber:[NSNumber numberWithFloat:beans.value]]];
    
    NSString *dateTxt = @"";
    if(beans.valueFranq > 0){
        dateTxt = [dateTxt stringByAppendingString:NSLocalizedString(@"FranchiseValue", @"")];
        dateTxt = [dateTxt stringByAppendingString:[formatter stringFromNumber:[NSNumber numberWithFloat:beans.valueFranq]]];
        dateTxt = [dateTxt stringByAppendingString:@"\n"];
        [_lblDate setNumberOfLines:2];
    }
    NSDateFormatter *finalDate = [[NSDateFormatter alloc] init];
    [finalDate setDateFormat:@"dd.MM.yyyy"];
    
    dateTxt = [dateTxt stringByAppendingString:[finalDate stringFromDate:dateCurrent]];
    
    [_lblDate  setText:dateTxt];
    
    
}

+(CGFloat) returnHeightRowWithBeans:(Vision360EventBeans *)beans{
    if(beans.valueFranq <= 0){
        return 70;
    }
    return 90;
}


@end


@implementation HeaderAssistExtractTableViewCell
@synthesize title, icon, bg;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) addShadow{
    self.backgroundColor = [BaseView getColor:@"CinzaFundo"];
    [self.contentView setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [BaseView addDropShadow:bg];
}

@end


@implementation AssistItemExtractTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) configLayoutBeans:(Vision360EventBeans *)beans{
    self.backgroundColor = [BaseView getColor:@"CinzaFundo"];
    [self.contentView setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
     [BaseView addDropShadow:_bg];

    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:beans.description attributes:@{
                                                                                                                        NSForegroundColorAttributeName : [BaseView getColor:@"AzulEscuro"],
                                                                                                                        NSBackgroundColorAttributeName : [BaseView getColor:@"CinzaFundo"],
                                                                                                                    }];
    [_lblTitle setAttributedText:title];
    
    NSString *dateTxt = @"";
    
    NSDateFormatter *finalDate = [[NSDateFormatter alloc] init];
    [finalDate setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssSSSZ"];
    
    NSString *textDate =  beans.dateOc;
    NSDate *dateCurrent = [dateFormatter dateFromString:textDate];
    
    
    dateTxt = [dateTxt stringByAppendingString:[finalDate stringFromDate:dateCurrent]];
    
    [_lblDate  setText:dateTxt];
    
    [_icon setImage:[UIImage imageNamed:beans.image]];
    
    
}

+(CGFloat) returnHeightRowWithBeans:(Vision360EventBeans *)beans{
    if(beans.valueFranq <= 0){
        return 70;
    }
    return 90;
}


@end
