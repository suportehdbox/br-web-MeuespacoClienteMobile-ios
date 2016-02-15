//
//  NotificacaoConsultaTableViewCell.h
//  LibertyMobile
//
//  Created by Evandro Oliveira on 20/01/2015.
//  Copyright 2015 Liberty Seguros S/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NotificacaoConsultaTableViewCell : UITableViewCell {
    UILabel* lblDate;
    UITextView* txtAlert;
}

@property(nonatomic,retain)IBOutlet UILabel* lblDate;
@property(nonatomic,retain)IBOutlet UITextView* txtAlert;


@end
