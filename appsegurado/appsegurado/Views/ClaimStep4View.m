//
//  ClaimStep4View.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClaimStep4View.h"
#import <UITextView+Placeholder.h>
#import "CustomImageFlowLayout.h"
@implementation ClaimPhotoCell
@synthesize imgPhoto, delegate,indexpath;

-(IBAction)clicked:(id)sender{
    [delegate photoSelected:indexpath];
}


@end
@interface ClaimStep4View(){
    NSMutableArray *dataArray;
    BOOL isEditing;
    UILabel *lblTimer;
}

@end
@implementation ClaimStep4View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
    [_widthSpace setConstant:self.frame.size.width - 40];
    [_betweenSpace setConstant: 15];
    _collectionPhotos.collectionViewLayout = [[CustomImageFlowLayout alloc] initWithNumberOfColumns:4];
    
    [_lblInstructionPhoto setText:NSLocalizedString(@"ApagarFoto",@"")];
    [_lblInstructionPhoto setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblInstructionPhoto setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblInstructionPhoto setHidden:YES];
    
    [_heightPhotos setConstant:110];
    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
    [_activity setHidden:YES];
    
    [_lblLoading setFont:[BaseView getDefatulFont:Small bold:YES]];
    [_lblLoading setTextColor:[BaseView getColor:@"CinzaFundo"]];
    
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:YES]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setText:NSLocalizedString(@"ClaimTitle4", @"")];
    
    
    NSMutableAttributedString *title1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EstouComDuvidas", @"")];
    
    [title1 addAttribute:NSForegroundColorAttributeName
                   value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"EstouComDuvidas", @"") length])];
    
    
    //    [_btDoubts setTintColor:[BaseView getColor:@"AzulEscuro"]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FaleComLiberty", @"")];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    
    [title addAttribute:NSUnderlineColorAttributeName
                  value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    [title addAttribute:NSUnderlineStyleAttributeName
                  value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    
    [title1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    [title1 appendAttributedString:title];
    
    [_btDoubts setAttributedTitle:title1 forState:UIControlStateNormal];
    [_btDoubts.titleLabel setFont:[BaseView getDefatulFont:Micro bold:NO]];
    
    
    [_btNext setTitle:NSLocalizedString(@"FinalizarSinistro", @"") forState:UIControlStateNormal];
    [_btNext.titleLabel setFont:[BaseView getDefatulFont:Nano bold:NO]];
    [_btNext setBorderRound:7];
    [_btNext setBorderWidth:1];
    [_btNext setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_btNext setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btNext setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    
    if(![Config isAliroProject]){
        [_btNext setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btNext setBackgroundColor:[BaseView getColor:@"Amarelo"]];
    }
    
    [_txtReport setPlaceholder:NSLocalizedString(@"DigiteRelato", @"")];
    [_txtReport setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtReport setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtReport setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    [_txtReport setDelegate:self];
    [_txtReport setText:@""];
    
    [_lblReportAudio setText:NSLocalizedString(@"AudioRelato", @"")];
    [_lblReportAudio setFont:[BaseView getDefatulFont:Medium bold:NO]];
    [_lblReportAudio setTextColor:[BaseView getColor:@"Verde"]];

    
    [_lblReportPhoto setText:NSLocalizedString(@"PhotosRelato", @"")];
    [_lblReportPhoto setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblReportPhoto setTextColor:[BaseView getColor:@"Laranja"]];
    
    [_lblQtdPhotos setText:@""];
    [_lblQtdPhotos setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [_lblQtdPhotos setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    

    [BaseView addDropShadow:_bgView];
    [BaseView addDropShadow:_bgView2];
    [BaseView addDropShadow:_bgView3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    
    [_lblLoading setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblLoading setTextColor:[BaseView getColor:@"CinzaEscuro"]];

    
    [_lblTitleSuccess setFont:[BaseView getDefatulFont:XLarge bold:NO]];
    [_lblTitleSuccess setTextColor:[BaseView getColor:@"Verde"]];
    [_lblTitleSuccess setText:NSLocalizedString(@"AvisoSinistroEnviado", @"")];
    [_lblSubTitleSuccess setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblSubTitleSuccess setTextColor:[BaseView getColor:@"Branco"]];
    [_lblSubTitleSuccess setText:NSLocalizedString(@"NumeroSinistro", @"")];
    [_lblClaimNumber setFont:[BaseView getDefatulFont:XLarge bold:NO]];
    [_lblClaimNumber setTextColor:[BaseView getColor:@"Branco"]];
    [_lblClaimNumber setText:@""];
    [_lblInstructions setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblInstructions setTextColor:[BaseView getColor:@"Branco"]];
    [_lblInstructions setText:NSLocalizedString(@"InstrucoesSinistro",@"")];

    [_btPopUpSuccess setTitle:NSLocalizedString(@"BtPopUpSucesso", @"") forState:UIControlStateNormal];
    [_btPopUpSuccess setBackgroundColor:[UIColor clearColor]];
    [_btPopUpSuccess setBorderColor:[BaseView getColor:@"Branco"]];
    [_btPopUpSuccess setBorderRound:7];
    [_btPopUpSuccess setBorderWidth:1];
    
    if(![Config isAliroProject]){
        [_btPopUpSuccess setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btPopUpSuccess setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btPopUpSuccess setBorderColor:[BaseView getColor:@"Verde"]];
        [_btPopUpSuccess customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }
    
    

    [self updateQtdPhotos];
}
-(void) updateLblTimer:(int) seconds{
    if(lblTimer == nil){
        lblTimer = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btAudio.frame), CGRectGetMinY(_btAudio.frame), CGRectGetMaxX(_bgView2.frame)  - CGRectGetMaxX(_btAudio.frame)-30, CGRectGetHeight(_btAudio.frame))];
        [lblTimer setTextAlignment:NSTextAlignmentCenter];
        [lblTimer setFont:[BaseView getDefatulFont:Small bold:NO]];
        [lblTimer setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [_bgView2 addSubview:lblTimer];
    }
    if(seconds == 0){
        [lblTimer setHidden:YES];
    }else{
        [lblTimer setHidden:NO];
    }
    int sec = seconds % 60;
    int min = (seconds / 60) % 60;
    
    [lblTimer setText:[NSString stringWithFormat:@"%02d:%02d", min, sec]];
}
-(void) updateQtdPhotos{
    //    "FotosAdicionadas1" = "Você possui";
    //    "FotosAdicionadas2" = " fotos";
    //    "FotosAdicionadas3" = " adicionadas";
    
    [_lblQtdPhotos setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblQtdPhotos setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    
    NSMutableAttributedString *qtdPhotos = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FotosAdicionadas1", @"")];
    
    [qtdPhotos addAttribute:NSFontAttributeName
                      value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"FotosAdicionadas1", @"") length])];
    
    NSString* num = [NSString stringWithFormat:@" %d%@", [dataArray count] ,NSLocalizedString(@"FotosAdicionadas2", @"")];
    NSMutableAttributedString *qtdPhotos2 = [[NSMutableAttributedString alloc] initWithString:num ];
    
    [qtdPhotos2 addAttribute:NSFontAttributeName
                       value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, [num  length])];
    
    NSMutableAttributedString *qtdPhotos3 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FotosAdicionadas3", @"")];
    
    [qtdPhotos3 addAttribute:NSFontAttributeName
                       value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"FotosAdicionadas3", @"") length])];
    
    //    [_btDoubts setTintColor:[BaseView getColor:@"AzulEscuro"]];
    NSMutableAttributedString *txtQtd = [[NSMutableAttributedString alloc] initWithAttributedString:qtdPhotos];
    
    [txtQtd appendAttributedString:qtdPhotos2];
    [txtQtd appendAttributedString:qtdPhotos3];
    
    [_lblQtdPhotos setAttributedText:txtQtd];
    
    if([dataArray count] > 0){
        [_lblInstructionPhoto setHidden:NO];
        [_lblQtdPhotos setHidden:NO];
    }else{
        [_lblQtdPhotos setHidden:YES];
        [_lblInstructionPhoto setHidden:YES];
    }
}

-(void) updateCollectionViewLayout:(int)numItens{
    if(numItens > 0 && numItens <= 4){
        CustomImageFlowLayout *flow = (CustomImageFlowLayout *) _collectionPhotos.collectionViewLayout;
        [_heightPhotos setConstant:110 + [flow itemSize].height];
    }else if(numItens > 4){
        CustomImageFlowLayout *flow = (CustomImageFlowLayout *) _collectionPhotos.collectionViewLayout;
        [_heightPhotos setConstant:110 + ([flow itemSize].height * 2) + 15];
    }else{
        [_heightPhotos setConstant:110];
    }
    
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //handle user taps text view to type text
    isEditing = true;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    //handle text editing finished
    isEditing= false;
}
#define MAX_LENGTH 1500 // text limit
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    if(newLength <= MAX_LENGTH)
    {
        return YES;
    } else {
        NSUInteger emptySpace = MAX_LENGTH - (textView.text.length - range.length);
        textView.text = [[[textView.text substringToIndex:range.location]
                          stringByAppendingString:[text substringToIndex:emptySpace]]
                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
        return NO;
    }
}
-(void)tapView:(UITapGestureRecognizer *)recognizer{
    if(isEditing){
        [_txtReport resignFirstResponder];
    }
}
-(void) unloadView{

}

-(void) changeButtonPlay{
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.12f];
    _btAudio.transform = CGAffineTransformMakeScale(1.0,1.0);
    [UIView commitAnimations];

    [_btAudio setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [_btDelete setHidden:NO];
    [self updateLblTimer:0];
}

-(void) changeButtonPause{
    [_btAudio setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
}

-(void) changeButtonRecord{
    [_btAudio setImage:[UIImage imageNamed:@"audio"] forState:UIControlStateNormal];
    [_btDelete setHidden:YES];
}
-(void) changeButtonRecording{
    [_btAudio setImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.12f];
    _btAudio.transform = CGAffineTransformMakeScale(1.2,1.2);
    [UIView commitAnimations];
    
}

-(void) updateArrayImages:(NSMutableArray*) array{
    dataArray = array;
    [self updateCollectionViewLayout:[array count]];
    [_collectionPhotos reloadData];
    [self updateQtdPhotos];
}

-(NSString*) getDesc{
    return [_txtReport text];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath delegate:(id<ClaimPhotoCellDelegate>) delegate{

    static NSString *cellIdentifier = @"PhotoCell";

    ClaimPhotoCell *cell = (ClaimPhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setDelegate:delegate];
    [cell setIndexpath:indexPath];
    [cell.imgPhoto setImage:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
    
}

-(void) startLoading:(NSString*)message{
    [_scrollView setHidden:YES];
    [_activity startAnimating];
    [_activity setHidden:NO];
    [_lblLoading setText:message];
    [_lblLoading setHidden:NO];

}

-(void) stopLoading{
    [_activity setHidden:YES];
    [_lblLoading setHidden:YES];
    [_scrollView setHidden:NO];
}



-(void) showSuccessPopUp:(NSString*) claim{
    [_popUpSuccess setHidden:NO];
    [_lblClaimNumber setText:claim];
    

}


@end
