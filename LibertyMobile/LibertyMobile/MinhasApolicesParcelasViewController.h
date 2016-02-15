//
//  MinhasApolicesParcelasViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MinhasApolicesParcelasViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* parcelasTableView;
    NSMutableArray* parcelas;
}

@property (nonatomic,retain) IBOutlet UITableView* parcelasTableView;
@property (nonatomic,retain) NSMutableArray* parcelas;

//- (IBAction)btnVoltar:(id)sender;

@end
