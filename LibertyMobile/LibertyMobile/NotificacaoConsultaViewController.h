//
//  SinistroConsultaViewController.h
//  LibertyMobile
//
//  Created by Evandro Oliveira on 13/01/15.
//  Copyright 2015 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificacaoConsultaTableViewCell.h"

@interface NotificacaoConsultaViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *consultaTableView;
    NSMutableArray  *arrayFields;
    BOOL            receberNotificacoes;
}

@property (nonatomic, retain) IBOutlet UITableView  *consultaTableView;

//- (IBAction) btnMenu:(id)sender;
- (IBAction) btnEdit:(id)sender;
- (IBAction) btnOk:(id)sender;

+ (NSString*) getPathNotificationPlist;
+ (void) addAndSaveNotificationPlist:(NSMutableDictionary*)pushNotification;

@end
