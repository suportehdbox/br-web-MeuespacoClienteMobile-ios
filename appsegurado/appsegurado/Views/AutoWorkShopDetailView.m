//
//  AutoWorkShopDetailView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "AutoWorkShopDetailView.h"
#import "BaseView.h"
#import "AutoWorkShopModel.h"

@interface AutoWorkShopDetailView() {
    UILabel *lblIndication;
    UILabel *lblFull;
    UILabel *lblName;
    UILabel *lblAddress;
    UILabel *lblTitle;
    UIButton *btPhone;
    UILabel *lblDistance;
    UILabel *lblOfficeHours;
    UIView *divisor;
    UIImageView *imageViewCar;
    UIImageView *imageViewPhone;
    UIButton *btRoute;
    float margin;
    float widthLbls;
    float marginY;
    BOOL loaded;
    
    
}

@end
@implementation AutoWorkShopDetailView
@synthesize latitude,longitude;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //[self loadView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
       // [self loadView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // [self loadView];
    }
    return self;
}

-(void) loadView:(BOOL)isIndication {
    

    self.layer.shadowColor = [[BaseView getColor:@"CinzaClaro"]  CGColor];
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.75f;
    
    UIImage *imageRoute = [UIImage imageNamed:@"route_button" ];
    
    margin = 15;
    float innerSpacing = 3;
    widthLbls = self.frame.size.width - imageRoute.size.width - (margin*4) - 8;
    marginY = 10;
    float posY = marginY+5;
    float heightLabel = Small;

    if(lblIndication){
        [lblIndication removeFromSuperview];
    }
    
    if(isIndication){
        
        
        lblIndication = [[UILabel alloc] initWithFrame:CGRectMake(margin, posY, CGRectGetMaxX(self.frame) - (margin*3), heightLabel)];
        [lblIndication setFont:[BaseView getDefatulFont:Small bold:YES]];
        [lblIndication setTextColor:[BaseView getColor:@"Verde"]];
        [lblIndication setNumberOfLines:1];
        [lblIndication setMinimumScaleFactor:0.5f];
        [lblIndication setAdjustsFontSizeToFitWidth:TRUE];
        NSString *txt = @"Nossa sugestão para você";
        [lblIndication setText:[txt uppercaseString]];
        [self addSubview:lblIndication];
        posY += heightLabel + innerSpacing;
    }
    
    
    if(lblName){
        [lblName removeFromSuperview];
    }
    
    lblName = [[UILabel alloc] initWithFrame:CGRectMake(margin, posY, CGRectGetMaxX(self.frame) - (margin*3), heightLabel)];
    [lblName setFont:[BaseView getDefatulFont:Micro bold:YES]];
    [lblName setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [lblName setNumberOfLines:1];
    [lblName setMinimumScaleFactor:0.5f];
    [lblName setAdjustsFontSizeToFitWidth:TRUE];
    
    [self addSubview:lblName];
    
    posY += heightLabel + innerSpacing;
    
    if(lblFull){
        [lblFull removeFromSuperview];
    }
    
    lblFull = [[UILabel alloc] initWithFrame:CGRectMake(margin, posY, CGRectGetMaxX(self.frame) - (margin*3), heightLabel)];
    [lblFull setFont:[BaseView getDefatulFont:Small bold:YES]];
    [lblFull setTextColor:[BaseView getColor:@"Vermelho"]];
    [lblFull setNumberOfLines:1];
    [lblFull setMinimumScaleFactor:0.5f];
    [lblFull setAdjustsFontSizeToFitWidth:TRUE];
    [lblFull setText:@"Oficina Lotada"];
    [lblFull setHidden:YES];
    [self addSubview:lblFull];
    
    
    posY += heightLabel + innerSpacing;
    
    
    if(divisor){
        [divisor removeFromSuperview];
    }
    
    divisor = [[UIView alloc] initWithFrame:CGRectMake(widthLbls + margin, posY + (marginY/2), 1, CGRectGetHeight(self.frame) - (heightLabel * 3) -  posY + (marginY/2) )];
    [divisor setBackgroundColor:[BaseView getColor:@"CinzaClaro"]];
    [self addSubview:divisor];
    
    if(lblAddress){
        [lblAddress removeFromSuperview];
    }
    
    lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(margin, posY, widthLbls, (heightLabel*2))];
    [lblAddress setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [lblAddress setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [lblAddress setNumberOfLines:2];
    [lblAddress setMinimumScaleFactor:0.5f];
    [lblAddress setAdjustsFontSizeToFitWidth:TRUE];
    [self addSubview:lblAddress];
    
    posY += (heightLabel*3) + innerSpacing;
    
    
    //Car With Distance
    UIImage *car = [UIImage imageNamed:@"car_green"];
   
    if(imageViewCar){
        [imageViewCar removeFromSuperview];
    }
    
    imageViewCar = [[UIImageView alloc ] initWithImage:car];
    [imageViewCar setFrame:CGRectMake(margin, posY, car.size.width, car.size.height)];
    [self addSubview:imageViewCar];
    
    if(lblDistance){
        [lblDistance removeFromSuperview];
    }
    
    
    lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(imageViewCar.frame.origin.x + imageViewCar.frame.size.width + (margin/2) , posY, widthLbls - car.size.width, car.size.height)];
    [lblDistance setFont:[BaseView getDefatulFont:Small bold:NO]];
    [lblDistance setTextColor:[BaseView getColor:@"Verde"]];
    [lblDistance setText:@"3 Km"];
    [self addSubview:lblDistance];
    
    
    posY += heightLabel + innerSpacing + 5;
    
    
    //Phone Number
    UIImage *phone = [UIImage imageNamed:@"phone_green"];
    
    if(imageViewPhone){
        [imageViewPhone removeFromSuperview];
    }
    
    imageViewPhone = [[UIImageView alloc ] initWithImage:phone];
    [imageViewPhone setFrame:CGRectMake(margin, posY, phone.size.width, phone.size.height)];
    [self addSubview:imageViewPhone];
    
   
    if(btPhone){
        [btPhone removeFromSuperview];
    }
    
    btPhone = [[UIButton alloc] initWithFrame:CGRectMake(imageViewCar.frame.origin.x + imageViewCar.frame.size.width + (margin/2) , posY, widthLbls - phone.size.width, car.size.height)];
    [btPhone.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [btPhone setTitleColor:[BaseView getColor:@"Verde"] forState:UIControlStateNormal];
    [btPhone setTitle:@"84 2222-9999" forState:UIControlStateNormal];
    [btPhone.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [btPhone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btPhone setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btPhone setContentMode:UIViewContentModeLeft];
    [btPhone addTarget:self action:@selector(callNumber) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btPhone];
    
    
    posY += heightLabel + innerSpacing + 5;

    if(lblOfficeHours){
        [lblOfficeHours removeFromSuperview];
    }
    
    
    //Hours
    lblOfficeHours = [[UILabel alloc] initWithFrame:CGRectMake(margin, posY, CGRectGetMaxX(self.frame) - (margin*3) , heightLabel)];
    [lblOfficeHours setFont:[BaseView getDefatulFont:Small bold:NO]];
    [lblOfficeHours setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [lblOfficeHours setMinimumScaleFactor:0.5f];
    [lblOfficeHours setAdjustsFontSizeToFitWidth:TRUE];
    [lblOfficeHours setNumberOfLines:1];
    [lblOfficeHours setText:@"SEG. À SEXTA DAS 8:00 AS 18:00 E SÁB. DAS 08:00 ÀS 13:00"];
    [self addSubview:lblOfficeHours];
    
    
    float px = CGRectGetMaxX(divisor.frame) + (self.frame.size.width - CGRectGetMaxX(divisor.frame))/2 - (imageRoute.size.width/2);
    
    if(btRoute){
        [btRoute removeFromSuperview];
    }
    
    btRoute = [[UIButton alloc] initWithFrame:CGRectMake(px, ((CGRectGetHeight(self.frame) - imageRoute.size.height)/2)  , imageRoute.size.width, (imageRoute.size.width*2))];
    
    [btRoute setImage:imageRoute forState:UIControlStateNormal];
//    float px = divisor.frame.origin.x + (self.frame.size.width - divisor.frame.origin.x  - imageRoute.size.width)/2;
    
//    [btRoute setFrame:];
    
    
    NSMutableAttributedString *subTitleText = [[NSMutableAttributedString alloc] initWithString : NSLocalizedString(@"TracarRota", @"")
                                                                                     attributes : @{
                                                                                                    NSFontAttributeName : [BaseView getDefatulFont:Nano bold:NO],
                                                                                                    NSForegroundColorAttributeName : [BaseView getColor:@"Verde"]}];
    [btRoute setAttributedTitle:subTitleText forState:UIControlStateNormal];
    
    [btRoute.imageView setContentMode:UIViewContentModeCenter];
    [btRoute.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btRoute.titleLabel setNumberOfLines:2];
    
    CGSize imageSize = btRoute.imageView.frame.size;
    CGSize titleSize = btRoute.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageRoute.size.width*2);//(imageSize.height + titleSize.height);
    CGFloat marginButton = (CGRectGetWidth(btRoute.frame) -  imageSize.width)/2;
    [btRoute setImageEdgeInsets:UIEdgeInsetsMake(- (totalHeight - imageSize.height) - 15,
                                                marginButton,
                                                0.0f,
                                                marginButton
                                                )];
    
    [btRoute setTitleEdgeInsets:UIEdgeInsetsMake((imageSize.height/2) - titleSize.height,
                                                - imageSize.width,
                                                0,
                                                0.0f)];
    [btRoute addTarget:self action:@selector(traceRoute:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btRoute];
    
    
}

-(IBAction)traceRoute:(id)sender{
    AutoWorkShopModel *model = [[AutoWorkShopModel alloc] init];
    [model openRouteApp:latitude longitude:longitude destination:lblName.text];
}

-(void) addBoxTitle:(NSString *) title{
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(margin, marginY, CGRectGetWidth(self.frame) - margin, Nano)];
    [lblTitle setFont:[BaseView getDefatulFont:Nano bold:NO]];
    [lblTitle setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [lblTitle setText:title];
    [self addSubview:lblTitle];
    
    float addtop = Nano + (margin/2);
    [lblIndication setFrame:[self adjustTopPosition:lblIndication top:addtop adujstHeight:false]];
    [lblName setFrame:[self adjustTopPosition:lblName top:addtop adujstHeight:false]];
    [divisor setFrame:[self adjustTopPosition:divisor top:addtop adujstHeight:true]];
    [lblAddress setFrame:[self adjustTopPosition:lblAddress top:addtop adujstHeight:false]];
}

-(CGRect) adjustTopPosition:(UIView *)view top:(int) top adujstHeight:(BOOL)adjustHeight{
    if(adjustHeight){
        return CGRectMake(view.frame.origin.x, view.frame.origin.y + top, view.frame.size.width, view.frame.size.height - (top * 1.3f));
    }else{
        return CGRectMake(view.frame.origin.x, view.frame.origin.y + top, view.frame.size.width, view.frame.size.height);
    }
    
}

-(void) setName:(NSString*) name{
    [lblName setText:name];
    
}

-(void) setAddress:(NSString*) address{
    [lblAddress setText:address];
}

-(void) setPhoneNumber:(NSString*) phone{
    [btPhone setTitle:phone forState:UIControlStateNormal];
}

-(void) setDistance:(NSString*) distance{
    [lblDistance setText:distance];

}

-(void) setOfficeHours:(NSString*) hoursPhrase{
    [lblOfficeHours setText:hoursPhrase];
    
}

-(void) setUnavailable{
    [lblFull setHidden:NO];
}

-(void) setIndication{
    [lblIndication setHidden:NO];
}

-(void)callNumber{
    NSString *phone = [NSString stringWithFormat:@"tel:%@",btPhone.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[phone stringByReplacingOccurrencesOfString:@" " withString:@""]]];
}



@end
