//
//  ExtractViewController.m
//  appsegurado
//
//  Created by Luiz Zenha on 04/06/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//

#import "ExtractViewController.h"
#import "ExtractView.h"
#import "ExtractTableViewCell.h"

@interface ExtractViewController (){
    ExtractView *view;
    Vision360Model *conn;
    Vision360Beans *currentBeans;
    Vision360Model *model;
    NSString *currentPolicy;

}
@end


@implementation ExtractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentBeans = [[Vision360Beans alloc] init];
    currentBeans.event = [[NSMutableArray alloc] init];
    /*
    [arrayObjects addObject:  [[Vision360EventBeans alloc] initWithDictionary: @{
        @"dataOcorrencia": @"2019-05-17T13:08:43.9715785-03:00",
        @"descricao": @"Sinistro 1",
        @"valorFranquia": @1500.00,
        @"valorPago": @800.00
    }]];
    
    [arrayObjects addObject: [[Vision360EventBeans alloc] initWithDictionary: @{
                               @"dataOcorrencia": @"2019-08-17T13:08:43.9715785-03:00",
                               @"descricao": @"Troca parabrisas",
                               @"valorFranquia": @0.00,
                               @"valorPago": @200.00
                               }]];
    
   */
    
    view = (ExtractView *) self.view;
    [view loadView];

    model = [[Vision360Model alloc] init];
    [model setDelegate:self];

    [model getListEvent:[NSString stringWithFormat:@"%@", currentPolicy]];
    
    [view showLoading];
    
    self.title = NSLocalizedString(@"TitleExtract", @"");
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([currentBeans.event count] > 0 && indexPath.row < ([currentBeans.event count]+2) ){
        if(indexPath.row == 0){
            return 70;
            
        }else if((indexPath.row-1) == [currentBeans.event count]){
            return 145;
        }
        int index = (int) (indexPath.row - 1);
        return [ExtractTableViewCell returnHeightRowWithBeans: [currentBeans.event objectAtIndex:index]];
    }else{
        if([currentBeans.assists count] > 0){
            int correctIndex =  (int) indexPath.row;
            if([currentBeans.event count] > 0){
                correctIndex =  correctIndex - ((int) [currentBeans.event count]) - 2;
            }
            int index = (int) (correctIndex - 1);
            if(index == [currentBeans.assists count] - 1){
                return 120;
            }
            return 90;
        }
        
        return 90;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    if([currentBeans.event count] > 0 && indexPath.row < ([currentBeans.event count]+2) ){
        if(indexPath.row == 0){
            HeaderExtractTableViewCell * viewCell = (HeaderExtractTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"Header" forIndexPath:indexPath];
            [viewCell.title setText:NSLocalizedString(@"TitleHeaderExtract", @"")];
            viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [viewCell addShadow];
            return viewCell;
            
        }else if((indexPath.row-1) == [currentBeans.event count]){
            FooterExtractTableViewCell * viewCell = (FooterExtractTableViewCell*)  [tableView dequeueReusableCellWithIdentifier:@"Footer" forIndexPath:indexPath];
            [viewCell.lblValueTotal setText:NSLocalizedString(@"TotalExtract", @"")];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
            [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            
            [viewCell.lblValueTotal setText:[formatter stringFromNumber:[NSNumber numberWithFloat:currentBeans.totalDesc]]];
            [viewCell.lblPhrase setText:[NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"PhraseExtract", @""), [formatter stringFromNumber:[NSNumber numberWithFloat:currentBeans.totalPre]]]];
            viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [viewCell addShadow];
            return viewCell;
        }
        
        int index = (int) (indexPath.row - 1);
        ExtractTableViewCell * viewCell = (ExtractTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"Extract"];
        Vision360EventBeans *beans = [currentBeans.event objectAtIndex:index];
        NSDirection dir = NSBoth;
        if(index == 0){
            if(index == [currentBeans.event count]-1){
                dir = NSNone;
            }else{
                dir = NSBottom;
            }
        }else if( index == [currentBeans.event count] - 1){
            dir = NSTop;
        }
        
        NSString *row = [NSString stringWithFormat:@"%d", index + 1];
        
        [viewCell configLayout:dir beans:beans indexPath:row];
        
        viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return viewCell;
    }else if([currentBeans.assists count] > 0){
        int correctIndex =  (int) indexPath.row;
        if([currentBeans.event count] > 0){
            correctIndex =  correctIndex - ((int) [currentBeans.event count]) - 2;
        }
        if(correctIndex == 0){
            HeaderAssistExtractTableViewCell * viewCell = (HeaderAssistExtractTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"HeaderAssist" forIndexPath:indexPath];
            [viewCell.title setText:NSLocalizedString(@"TitleHeaderExtractAssist", @"")];
            [viewCell.title setTextColor:[BaseView getColor:@"Verde"]];
            viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [viewCell addShadow];
            return viewCell;
            
        }else{
            int index = (int) (correctIndex - 1);
            NSString *identifier = @"ExtractAssist";
            if(index == [currentBeans.assists count] - 1){
                identifier = @"ExtractAssistFooter";
            }
            AssistItemExtractTableViewCell * viewCell = (AssistItemExtractTableViewCell*) [tableView dequeueReusableCellWithIdentifier:identifier];
            Vision360EventBeans *beans = [currentBeans.assists objectAtIndex:index];
            [viewCell configLayoutBeans:beans];
            viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return viewCell;
        }
    }
        
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Empty"];

    
}

-(void)dealloc{
    if(model != nil){
        
        [model setDelegate:nil];
        model = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int totalEvents = (int) [currentBeans.event count];
    if(totalEvents > 0){
        totalEvents += 2;
    }
    
    int totalAssists = (int) [currentBeans.assists count];
    if(totalAssists > 0){
        totalAssists++;
    }
    return totalEvents+totalAssists;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void) setPolicy:(NSString*)policy{
    currentPolicy = policy;
}
-(void) visionResult:(Vision360Beans * )current{
    [view stopLoading];
    currentBeans = current;
    [view reloadTable];
}

-(void) visionError:(NSString*)message{
    [view stopLoading];
    [view showMessage:NSLocalizedString(@"ErrorTitle",@"") message:message];
}



    

@end
