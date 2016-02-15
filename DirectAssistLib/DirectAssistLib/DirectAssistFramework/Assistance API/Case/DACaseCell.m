//
//  FileCell.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 18/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DACaseCell.h"


@implementation DACaseCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCellDataWithFileNumber:(NSString *)fileNumber withFileDate:(NSString *)fileDate {
	lblFileNumber.text = fileNumber;

	
	lblFileDate.text = fileDate;
}



@end
