//
//  CoverageView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/04/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "CoverageView.h"
#import "CoverageBeans.h"
#import "Tools.h"
@interface CoverageView (){
    NSArray *arrayItens;
}
@end
@implementation CoverageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView:(NSArray*) array titleCoverage:(NSString*)title{
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [BaseView addDropShadow:_bgView];
    [BaseView addDropShadow:_bgTitleCoverage];
    [_lblTitleCoverage setText:title];
    [_lblTitleCoverage setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitleCoverage setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitleCoverage setMinimumScaleFactor:0.5f];
    [_lblTitleCoverage setNumberOfLines:2];
    [_lblTitleCoverage setAdjustsFontSizeToFitWidth:YES];
    
    [_lblOtherCoverage setText:NSLocalizedString(@"OUTROS ITENS", @"")];
    [_lblOtherCoverage setFont:[BaseView getDefatulFont:Nano bold:NO]];
    [_lblOtherCoverage setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblOtherCoverage setTextAlignment:NSTextAlignmentCenter];
    [_lblOtherCoverage setMinimumScaleFactor:0.5f];
    [_lblOtherCoverage setNumberOfLines:2];
    [_lblOtherCoverage setAdjustsFontSizeToFitWidth:YES];
    arrayItens = array;

    [_tableView reloadData];
    _tableView.estimatedRowHeight = 44.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
}
-(void) unloadView{

}

-(void) hideOtherCoverages:(BOOL) hide{
    [_lblOtherCoverage setHidden:hide];
    [_arrow setHidden:hide];
}
- (BOOL)tableView:(JNExpandableTableView *)tableView canExpand:(NSIndexPath *)indexPath{
    return ![self indexIsSection:indexPath];
}

-(BOOL) indexIsSection:(NSIndexPath*) indexPath{
    if(![[arrayItens objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        return FALSE;
    }
    return TRUE;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    
        if ([self.tableView.expandedContentIndexPath isEqual:indexPath])
        {
            static NSString *CellIdentifier = @"DetailCoverage";
    
            CoverageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            CoverageBeans *beans = [arrayItens objectAtIndex:(indexPath.row - 1)];
            [cell.txtDetail setText:beans.detail];
            [cell.txtDetail setFont:[BaseView getDefatulFont:Micro bold:NO]];
            [cell.txtDetail setTextColor:[UIColor darkGrayColor]];
            [cell.txtDetail sizeToFit];
            [cell.layer setBorderColor:[[Tools colorFromHexString:NSLocalizedString(@"CellBG", @"")] CGColor]];
            [cell.layer setBorderWidth:1.0f];
            
            return cell;
    
        }
    
        else
        {
            NSIndexPath * adjustedIndexPath = [self.tableView adjustedIndexPathFromTable:indexPath];
            
            if([self indexIsSection:adjustedIndexPath]){
                return [self tableView:tableView viewForHeaderIndexPath:adjustedIndexPath];
            }
            static NSString *cellIdentifier = @"TitleCoverage";
    
            CoverageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            CoverageBeans *beans = [arrayItens objectAtIndex:adjustedIndexPath.row];
            
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:beans.coverageDescription];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
            [attributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributed.length)];
             [attributed addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [attributed length])];
            
            NSMutableAttributedString *attributed2 = [[NSMutableAttributedString alloc] initWithString:beans.value];
            NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init] ;
            [paragraphStyle2 setAlignment:NSTextAlignmentRight];
            [attributed2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, attributed2.length)];
            
             [attributed2 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [attributed2 length])];
            [cell.lblTitle setNumberOfLines:3];
            [cell.lblTitle setFont:[BaseView getDefatulFont:Micro bold:NO]];
            [cell.lblTitle setText:beans.coverageDescription];
            
            [cell.lblValue setNumberOfLines:3];
            [cell.lblValue setAttributedText:attributed2];;
            [cell setIsTitle:YES];
            return cell;
        }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return JNExpandableTableViewNumberOfRowsInSection((JNExpandableTableView *)tableView,section,[arrayItens count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView viewForHeaderIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"HeaderCoverage";
    
    CoverageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString: [arrayItens objectAtIndex:indexPath.row]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [attributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributed.length)];
    [attributed addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Medium bold:NO] range:NSMakeRange(0, [attributed length])];
    [attributed addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [attributed length])];

    [cell.lblTitle setAttributedText:attributed];
    return cell;

}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSIndexPath * adjustedIndexPath = [self.tableView adjustedIndexPathFromTable:indexPath];
//    if([self indexIsSection:adjustedIndexPath]){
//        return 80;
//    }else{
//        if ([self.tableView.expandedContentIndexPath isEqual:indexPath]){
//            return UITableViewAutomaticDimension;
//        }else{
//            return 45;
//        }
//    }
//}


@end
