//
//  CitiesView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 04/01/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "CitiesView.h"
#import "CityBeans.h"

@interface CitiesView(){
    NSMutableArray *arrayCities;
}
@end
@implementation CitiesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    arrayCities = [[NSMutableArray alloc] init];
    [_searchBar setShowsScopeBar:YES];;
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [BaseView addDropShadow:_bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
//    [self addGestureRecognizer:tap];

}
-(void) unloadView{
    
}

-(void)tapView:(UITapGestureRecognizer *)recognizer{
    [_searchBar resignFirstResponder];
}

-(void) loadCities:(NSArray*) array{
    if(arrayCities == nil){
        arrayCities = [[NSMutableArray alloc] init];
    }
    [arrayCities removeAllObjects];
    [arrayCities addObjectsFromArray:array];
    [_tableView reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CitiesCell * cell = (CitiesCell*) [tableView dequeueReusableCellWithIdentifier:@"CitiesCell"];
    CityBeans *beans = [arrayCities objectAtIndex:indexPath.row];
    [cell.lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [cell.lblTitle setTextColor:[BaseView getColor:NSLocalizedString(@"CinzaEscuro",@"")]];
    [cell.separator setBackgroundColor:[BaseView getColor:NSLocalizedString(@"CinzaClaro",@"")]];
    [cell.lblTitle setText:beans.city];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayCities count];
}


@end
