//
//  Util.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject {
    
}

//+(void)initCustomNavigationBar:(UINavigationBar *)customNavigationBar;
+(BOOL) fieldIsValidString:(NSString *)theField andMinChars:(NSInteger)minChars andMaxChars:(NSInteger)maxChars;
+(void) alertError:(NSError *) error;
+(UIBarButtonItem *) addCustomButtonNavigationBar:(id)target action:(SEL)action imageName:(NSString *)imageName;
+(void) addBackButtonNavigationBar:(id)target action:(SEL)action;
+(void)callAlert:(id)target alertTitle:(NSString*)alertTitle  alertNumber:(NSString*)alertNumber;
+(void)callNumber:(id)target phoneNumber:(NSString*)phoneNumber;
+(NSString*)fmtNSDateToString:(NSDate*)dataSource dateFormatter:(NSDateFormatter*)dateFormatter;
+(NSDate*)convertStringToNSDate:(NSString*)dataSource  dateFormatter:(NSDateFormatter*)dateFormatter;
+(NSString*)fmtDoubleToString:(double)numberSource;
+(int)getCountSectionArray:(int)numSection sourceArray:(NSMutableArray*)sourceArray;
+(int)getPositionSectionArray:(int)numSection numRow:(int)numRow sourceArray:(NSMutableArray*)sourceArray;
+(UIColor*)getColorHeader;
+(void)loadHtml:(NSString*)file webViewControl:(UIWebView*)webViewControl;
+(UIView*)getViewButtonTableView:(id)target action:(SEL)action textButton:(NSString*)textButton imageName:(NSString *)imageName;
+(void)openKeyBoardTableView:(UITableViewCell*)tableViewCell;
+(int)getFieldLengthByFieldTagArray:(int)tagFind sourceArray:(NSMutableArray*)sourceArray;

+(UIView *) obtainUIViewSuperview:(UIView *) aView withClass:(Class) aClass;
+(UITableView *) obtainSuperviewUITableView:(UIControl *) aControl;
+(UITableViewCell *) obtainSuperviewUITableViewCell:(UIControl *) aControl;
+(BOOL) changeResponder:(int) tagChange forTextField:(UIControl *) activeTextField withTagRange: (NSRange) activeTagRange;
+ (void) makeTableCellVisibleFromSubview: (UIView *) aUIView usingScrollPosition:(UITableViewScrollPosition) scrollPosition;
+ (void) makeTableCellControlVisible: (UIControl *) view;
+ (void) dropTableBackgroudColor:(UITableView *)tableView;

+(BOOL) checkCPF:(NSString *)cpfNum;
+(BOOL) checkCnpj:(NSString*)cnpj;
+(NSDate*)addDate:(NSDate*)dataSource days:(int)days;
+(NSDate*)getDateFromJSON:(NSString *)dateString;

+(NSString*)getColumnDict:(NSDictionary*)dict columnName:(NSString*)columnName;

+(void)viewMsgErrorConnection:(id)target codeError:(NSError*)codeError;

+(void)formatInput:(UITextField*)aTextField string:(NSString*)aString range:(NSRange)aRange maskValid:(NSString *)maskValid;

+(BOOL)validateEmail:(NSString *)emailStr;

+(UITableViewCell*)getViewButtonTableViewCell:(id)target action:(SEL)action textButton:(NSString*)textButton tableView:(UITableView *)tableView;

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
