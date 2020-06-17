//
//  UploadPicturesView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 19/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "UploadPicturesView.h"
#import "CustomImageFlowLayout.h"
#import "FAImageView.h"
@interface UploadPhotoCell(){
    FAImageView *img_selected;
    BOOL selctedToDelete;
}
@end
@implementation UploadPhotoCell
@synthesize imgPhoto, delegate,indexpath, button, selected;
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    
    UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
    longpressGesture.minimumPressDuration = 1;
    [longpressGesture setDelegate:self];
    longpressGesture.cancelsTouchesInView = NO;
    

    UITapGestureRecognizer *tabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [tabGesture setDelegate:self];
    tabGesture.cancelsTouchesInView = NO;
    
    [self addGestureRecognizer:longpressGesture];
    [self addGestureRecognizer:tabGesture];
    
    selctedToDelete = false;
}

-(IBAction)clicked:(id)sender{
//    [delegate photoSelected:indexpath];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}



-(void) tapGestureHandler:(UITapGestureRecognizer*) gestureRecognizer{
    NSLog(@"tap handler");
//    if(selctedToDelete){
//        [delegate longPressed:(int)self.button.tag];
//        [self setSelectedDelete:NO];
//        return;
//    }
    if(delegate && [delegate respondsToSelector:@selector(photoSelected:button:)]){
        [delegate photoSelected:(int)self.button.tag button:self.button];
    }else{
        [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)longPressHandler:(UILongPressGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
         NSLog(@"longPressHandler Ended");
    }else if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        [delegate longPressed:(int)self.button.tag];
//        [self setSelectedDelete:!selctedToDelete];
        NSLog(@"longPressHandler");
    }
}

-(void) setSelectedDelete:(BOOL) select{
    selctedToDelete = select;
    [self updateLayout];
}

-(void) updateLayout{

    
    if(selctedToDelete){
        if(img_selected == nil){
            img_selected = [[FAImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
            [img_selected setBackgroundColor:[UIColor clearColor]];
            [img_selected setOpaque:NO];
            [img_selected.defaultView setTextColor:[BaseView getColor:@"Laranja"]];
            [img_selected.defaultView setBackgroundColor:[UIColor clearColor]];
            [img_selected.defaultView setOpaque:NO];
            [self addSubview:img_selected];
            img_selected.image = nil;
        }
        
//        self.layer.borderColor = [[UIColor redColor] CGColor];
//        self.layer.borderWidth = 2.0f;
        [img_selected setDefaultIconIdentifier:@"fa-check-circle"];
        [img_selected setHidden:NO];
    }else{
//        self.layer.borderColor = [[UIColor whiteColor] CGColor];
//        self.layer.borderWidth = 0;
        if(img_selected != nil){
            [img_selected setHidden:YES];
        };
//        [img_selected setDefaultIconIdentifier:@"fa-square"];
    }
   
    
}



@end

@implementation UploadPicturesView{
    NSMutableArray *dataArray;
    BOOL isEditing;
    UILabel *lblTimer;
}



-(void) loadView{
   _collectionPhotos.collectionViewLayout = [[CustomImageFlowLayout alloc] initWithNumberOfColumns:4];
    
    [_lblInstructionPhoto setText:NSLocalizedString(@"ApagarFoto",@"")];
    [_lblInstructionPhoto setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblInstructionPhoto setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblInstructionPhoto setHidden:YES];
    
    [_heightPhotos setConstant:110];
    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
    [_activity setHidden:YES];
    
    [_lblLoading setFont:[BaseView getDefatulFont:Micro bold:YES]];
    
    [_lblLoading setNumberOfLines:3];
    [_lblLoading setTextColor:[BaseView getColor:@"CinzaFundo"]];
    
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:YES]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setText:NSLocalizedString(@"ClaimTitle4", @"")];
    
    
    NSMutableAttributedString *title1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EstouComDuvidas", @"")];
    
    [title1 addAttribute:NSForegroundColorAttributeName
                   value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"EstouComDuvidas", @"") length])];
    
    
    [_lblReportPhoto setText:NSLocalizedString(@"PhotosRelato", @"")];
    [_lblReportPhoto setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblReportPhoto setTextColor:[BaseView getColor:@"Laranja"]];
    
    [_lblQtdPhotos setText:@""];
    [_lblQtdPhotos setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [_lblQtdPhotos setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    
    [BaseView addDropShadow:_bgView];
    
    [_lblLoading setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblLoading setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    
    //ArquivosEnviados" = "DOCUMENTOS ENVIADOS COM SUCESSO";
    //"DocumentoVinculado" = "Documentos vinculados ao sinistro: %@";

    
    [_lblTitleSuccess setFont:[BaseView getDefatulFont:XLarge bold:NO]];
    [_lblTitleSuccess setTextColor:[BaseView getColor:@"Verde"]];
    [_lblTitleSuccess setText:NSLocalizedString(@"ArquivosEnviados", @"")];
    [_lblSubTitleSuccess setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblSubTitleSuccess setTextColor:[BaseView getColor:@"Branco"]];
    [_lblSubTitleSuccess setText:NSLocalizedString(@"DocumentoVinculado", @"")];
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
    
    
    [_btNext setTitle:NSLocalizedString(@"Enviar", @"") forState:UIControlStateNormal];
    [_btNext.titleLabel setFont:[BaseView getDefatulFont:Nano bold:NO]];
    [_btNext setBorderRound:7];
    [_btNext setBorderWidth:1];
    [_btNext setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_btNext setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btNext setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    
    
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

-(void) unloadView{
    
}

-(void) updateArrayImages:(NSMutableArray*) array{
    dataArray = array;
    [self updateCollectionViewLayout:(int)[array count]];
    [_collectionPhotos reloadData];
    [self updateQtdPhotos];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath delegate:(id<UploadPhotoCellDelegate>) delegate{
    
    static NSString *cellIdentifier = @"PhotoCell";
    
    UploadPhotoCell *cell = (UploadPhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setDelegate:delegate];
    [cell setIndexpath:indexPath];
    [cell.imgPhoto setImage:[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
    
}

-(void) startLoading:(NSString*)message{
    [_bgView setHidden:YES];
    [_btNext setHidden:YES];
    [_activity startAnimating];
    [_activity setHidden:NO];
    [_lblLoading setText:message];
    [_lblLoading setHidden:NO];
    
}

-(void) stopLoading{
    [_bgView setHidden:NO];
    [_btNext setHidden:NO];
    [_activity setHidden:YES];
    [_lblLoading setHidden:YES];
}



-(void) showSuccessPopUp:(NSString*) claim{
    [_popUpSuccess setHidden:NO];
    [_lblClaimNumber setText:claim];
    
    
}

@end
