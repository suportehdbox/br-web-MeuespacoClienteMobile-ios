//
//  CheckBoxTableViewCell.h
//  LibertyMobile
//
//  Created by Evandro Oliveira on 06/11/15.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckBoxTableViewCell : UITableViewCell {
    
}

@property(nonatomic, assign) BOOL selecionado;
@property(nonatomic, retain) IBOutlet UIButton* BtnCheckBox;
@property(nonatomic, retain) IBOutlet UIWebView* link;
@property(nonatomic, retain) IBOutlet UILabel* lblErro;

//-(IBAction)btnCheckBox:(id)sender;

@end
