//
//  DocumentsView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 18/07/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "DocumentsView.h"
#import "DocumentBeans.h"

@interface DocumentsView(){
    NSMutableArray *dataArray;
    BOOL isEditing;
    UILabel *lblTimer;
    NSMutableArray *selectedDelete;
}
@end
@implementation DocumentsView


-(void) loadView{
    selectedDelete = [[NSMutableArray alloc] init];
    [_btDeletePicture setHidden:YES];
    _collectionPhotos.collectionViewLayout = [[CustomImageFlowLayout alloc] initWithNumberOfColumns:2];
    _collectionPhotos.autoresizesSubviews = YES;
    
    [_lblInstructionPhoto setText:@""];
    [_lblInstructionPhoto setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblInstructionPhoto setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblInstructionPhoto setNumberOfLines:0];
    [_lblInstructionPhoto setMinimumScaleFactor:0.5f];
    [_lblInstructionPhoto setHidden:YES];
    
    [_lblDesc setText:NSLocalizedString(@"DocumentsTitle", @"")];
    [_lblDesc setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblDesc setTextColor:[BaseView getColor:@"Laranja"]];
    [_lblDesc setNumberOfLines:0];
    [_lblDesc setMinimumScaleFactor:0.5f];
    [_lblDesc setHidden:NO];
    
    [_heightPhotos setConstant:110];
    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
    [_activity setHidden:YES];
    
    [_lblLoading setFont:[BaseView getDefatulFont:Micro bold:YES]];
    [_lblLoading setNumberOfLines:3];
    [_lblLoading setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblLoading setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:YES]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setText:NSLocalizedString(@"ClaimTitle4", @"")];
    
    
    NSMutableAttributedString *title1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EstouComDuvidas", @"")];
    
    [title1 addAttribute:NSForegroundColorAttributeName
                   value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"EstouComDuvidas", @"") length])];
    
    
    [_lblReportPhoto setText:NSLocalizedString(@"AdicionarDocumentos", @"")];
    [_lblReportPhoto setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblReportPhoto setTextColor:[BaseView getColor:@"Laranja"]];
    
    [_lblQtdPhotos setText:@""];
    [_lblQtdPhotos setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [_lblQtdPhotos setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    
    [BaseView addDropShadow:_bgView];
    

    
    
    //ArquivosEnviados" = "DOCUMENTOS ENVIADOS COM SUCESSO";
    //"DocumentoVinculado" = "Documentos vinculados ao sinistro: %@";
    
    
    [_lblTitleSuccess setFont:[BaseView getDefatulFont:XLarge bold:NO]];
    [_lblTitleSuccess setTextColor:[BaseView getColor:@"Verde"]];
    [_lblTitleSuccess setText:NSLocalizedString(@"ArquivosEnviados", @"")];
    [_lblSubTitleSuccess setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblSubTitleSuccess setTextColor:[BaseView getColor:@"Branco"]];
    [_lblSubTitleSuccess setText:@""];
    [_lblClaimNumber setFont:[BaseView getDefatulFont:XLarge bold:NO]];
    [_lblClaimNumber setTextColor:[BaseView getColor:@"Branco"]];
    [_lblClaimNumber setText:@""];
    [_lblInstructions setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblInstructions setTextColor:[BaseView getColor:@"Branco"]];
    [_lblInstructions setText:@""];
    [_lblInstructions setHidden:YES];
    
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
    
    [_btNext setTitle:NSLocalizedString(@"Salvar", @"") forState:UIControlStateNormal];
    [_btNext.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btNext setBorderRound:7];
    [_btNext setBorderWidth:1];
    [_btNext setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_btNext setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btNext setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    
    if(![Config isAliroProject]){
        [_btNext setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btNext setBackgroundColor:[BaseView getColor:@"Amarelo"]];
    }
    
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
    
    [self updateQtdPhotos];
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
    
    NSString* num = [NSString stringWithFormat:@" %ld%@", [dataArray count] ,NSLocalizedString(@"FotosAdicionadas2", @"")];
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
    if(numItens > 0 && numItens <= 2){
        CustomImageFlowLayout *flow = (CustomImageFlowLayout *) _collectionPhotos.collectionViewLayout;
        [_heightPhotos setConstant:110 + [flow itemSize].height];
    }else if(numItens > 2){
//        CustomImageFlowLayout *flow = (CustomImageFlowLayout *) _collectionPhotos.collectionViewLayout;
//        float totalConstant = 110 + ([flow itemSize].height * 2) + 15;
        [_heightPhotos setConstant:CGRectGetHeight(self.frame) - CGRectGetHeight(_btNext.frame) -  CGRectGetMinY(_bgView.frame) -  25];
        
    }else{
        [_heightPhotos setConstant:110];
    }
    [self updateConstraints];
    
}

-(void) unloadView{
    
}

-(void) updateArrayImages:(NSMutableArray*) array{
    dataArray = array;
    [selectedDelete removeAllObjects];
    [self updateCollectionViewLayout:(int)[array count]];
    [_collectionPhotos reloadData];
    [self updateQtdPhotos];
    [_btDeletePicture setHidden:true];
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath target:(nullable id)target action:(nonnull SEL)action{
    
    static NSString *cellIdentifier = @"DocumentsPhotoCell";
    
    UploadPhotoCell *cell = (UploadPhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    id object = [dataArray objectAtIndex:indexPath.row];
    [cell.imgPhoto setContentMode:UIViewContentModeScaleToFill];
    if([object isKindOfClass:[UIImage class]]){
        [cell.imgPhoto setImage:object];
    }else{
        [cell.imgPhoto setImage:[(DocumentBeans*)object image]];
    }
//    [cell setBackgroundColor:[UIColor redColor]];
    [cell.imgPhoto updateConstraints];
    if(cell.button == nil)
        cell.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [cell.button setTag:indexPath.row];
    [cell.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [cell setDelegate: self];
    [cell updateConstraints];
    BOOL selected = false;
    for (NSNumber *selectedObj in selectedDelete) {
        if([selectedObj integerValue] == indexPath.row){
            
            selected =true;
        }
    }
    [cell setSelectedDelete:selected];
    return cell;
    
}


-(void) startLoading:(NSString*)message{
    [_bgView setHidden:YES];
    [_btNext setHidden:YES];
    [_activity startAnimating];
    [_activity setHidden:NO];
    [_lblLoading setText:message];
    [_lblLoading setHidden:NO];
    [selectedDelete removeAllObjects];
    
}



-(void) stopLoading{
    [_bgView setHidden:NO];
    [_btNext setHidden:NO];
    [_activity setHidden:YES];
    [_lblLoading setHidden:YES];
}



-(void) showSuccessPopUp:(NSString*) claim{
    [_popUpSuccess setHidden:NO];
    [_lblClaimNumber setText:@""];
    [_lblTitleSuccess setText:claim];

    
}

-(void) closeSuccessPopUp{
    [_popUpSuccess setHidden:YES];
}



-(void)longPressed:(int)index{
    //show
    NSNumber *numIndex = [NSNumber numberWithInt:index];
    if([selectedDelete containsObject:numIndex]){
        [selectedDelete removeObject:numIndex];
    }else{
        [selectedDelete addObject:numIndex];
    }
    [_btDeletePicture setHidden:!([selectedDelete count] > 0)];
    [_collectionPhotos reloadData];
}

- (void)photoSelected:(int)index button:(UIButton *)button{
    if([selectedDelete count] > 0){
        [self longPressed:(int)index];
    }else{
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

-(NSMutableArray*) getSelecteds{
    return selectedDelete;
}

@end
