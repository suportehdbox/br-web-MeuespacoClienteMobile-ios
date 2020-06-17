//
//  SearchPopUpView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 31/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "CustomButton.h"


@protocol SearchPopUpViewDelegate <NSObject>
-(void) searchClicked:(NSString*)address zipCode:(NSString*)zipCode;
@end
@interface SearchPopUpView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *popUpBox;
@property (nonatomic, strong) IBOutlet UILabel *lblTitlePopUp;
@property (nonatomic, strong) IBOutlet UILabel *lblOr;
@property (nonatomic, strong) IBOutlet CustomTextField *txtZipCode;
@property (nonatomic, strong) IBOutlet CustomTextField *txtAddress;
@property (nonatomic, strong) IBOutlet CustomButton *btSearch;
@property (assign) IBOutlet id<SearchPopUpViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constTop;
-(void) unRegisterKeyboard;
-(IBAction)btSearchClicked:(id)sender;
-(void) setTitleText:(NSString*)title;
-(void) loadPopUp;
-(void) hideKeyboard;
-(void) show;
-(void) hide;
@end
