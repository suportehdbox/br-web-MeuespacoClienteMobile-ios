//
//  DACaseCell.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 18/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DACaseCell : UITableViewCell {
	IBOutlet UILabel *lblFileNumber;
	IBOutlet UILabel *lblFileDate;
}

-(void) setCellDataWithFileNumber:(NSString *)fileNumber withFileDate:(NSString *)fileDate;

@end
