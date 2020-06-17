//
//  StatusClaimView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "StatusClaimView.h"
#import "StatusViewCell.h"

@interface StatusClaimView(){
    NSMutableArray *arrayClaims;
}
@end
@implementation StatusClaimView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    arrayClaims = [[NSMutableArray alloc] init];
}

-(void) unloadView{
    
}
-(void) loadClaims:(NSArray*) array{
    [arrayClaims addObjectsFromArray:array];
    [_table reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 45;
    }
    ClaimBeans *beans = (ClaimBeans*) [arrayClaims objectAtIndex:indexPath.section-1];
    if([beans getStatusClaimCode] == 100){
            return 200;
    }
    return 240;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([arrayClaims count] == 0){
        return 0;
    }
    return [arrayClaims count] + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
                       target:(id) target action:(SEL)action {
    
    if(indexPath.section == 0){
        StatusViewCell * cell = (StatusViewCell*) [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        [cell.lblPolicy setTextColor:[BaseView getColor:@"AzulEscuro"]];
        [cell.lblPolicy setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblPolicy setText:NSLocalizedString(@"StatusSinistro", @"") ];
        [cell.bgView setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
        [cell setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
        return cell;
    }else{

        StatusViewCell * cell = (StatusViewCell*) [tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
        ClaimBeans *beans = (ClaimBeans*) [arrayClaims objectAtIndex:indexPath.section-1];
        
        cell.lblTitlePolicy.text = NSLocalizedString(@"Apolice",@"");
        [cell.lblTitlePolicy setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblTitlePolicy setTextColor:[BaseView getColor:@"AzulEscuro"]];

        cell.lblTitleClaim.text = NSLocalizedString(@"BoldSinistro",@"");
        [cell.lblTitleClaim setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblTitleClaim setTextColor:[BaseView getColor:@"AzulEscuro"]];
        
        cell.lblTitleDate.text = NSLocalizedString(@"DataAbertura",@"");
        [cell.lblTitleDate setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblTitleDate setTextColor:[BaseView getColor:@"AzulEscuro"]];
        
        [cell.iconStatus setImage:[UIImage imageNamed:[NSString stringWithFormat:@"status_%d.png",[beans getStatusClaimCode]]]];
        cell.lblStatus.text = [NSString stringWithFormat:@"%@",beans.statusClaim];
        switch ([beans getStatusClaimCode]) {
            case 10:
            case 40:
            case 100:
                [cell.lblStatus setTextColor:[BaseView getColor:@"Verde"]];
                break;
                
            default:
                [cell.lblStatus setTextColor:[BaseView getColor:@"Laranja"]];
            break;
        }

        [cell.lblStatus setFont:[BaseView getDefatulFont:Small bold:NO]];
        
        
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *dueDate = [dateformat dateFromString:beans.date];
        [dateformat setTimeZone:[NSTimeZone localTimeZone]];
        [dateformat setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
        [dateformat setDateFormat:@"dd/MM/yyyy"];
        
        
        
        cell.lblDate.text = [dateformat stringFromDate:dueDate];
        [cell.lblDate setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblDate setTextColor:[BaseView getColor:@"CinzaEscuro"]];

        [cell.lblPolicy setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblPolicy setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [cell.lblPolicy setText:beans.policy];
        
        [cell.lblNumber setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblNumber setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [cell.lblNumber setText:beans.number];
        
        if([beans getStatusClaimCode] != 100){
            [cell.btOpenUpload addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [cell.btOpenUpload setTag:(indexPath.section-1)];
        }else{
            [cell.btOpenUpload setHidden:YES];
            [cell.lblUpload setHidden:YES];
        }
        
        
        
        [cell setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
        [BaseView addDropShadow:cell.bgView];
        

        return cell;
    }
    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
}



@end
