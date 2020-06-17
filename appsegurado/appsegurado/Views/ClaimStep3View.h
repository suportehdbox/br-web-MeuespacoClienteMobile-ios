//
//  ClaimStep3View.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "CustomTextField.h"

@interface ClaimStep3View : BaseView <UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *imgSteps;
@property (strong, nonatomic) IBOutlet CustomButton *btNext;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *betweenSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthSpace;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btDoubts;
@property (strong, nonatomic) IBOutlet CustomTextField *txtNumber;

@property (strong, nonatomic) IBOutlet CustomTextField *txtDate;
@property (strong, nonatomic) IBOutlet CustomTextField *txtTime;
@property (strong, nonatomic) IBOutlet CustomTextField *txtAddress;
@property (strong, nonatomic) IBOutlet CustomTextField *txtRef;
@property (strong, nonatomic) IBOutlet CustomTextField *txtCity;
@property (strong, nonatomic) IBOutlet CustomTextField *txtNeighborhood;
@property (strong, nonatomic) IBOutlet CustomTextField *txtState;


@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;









-(void) loadView;
-(void) unloadView;
- (void)registerForKeyboardNotifications;
-(NSString*) getNumber;
-(NSString*) getDateTime;
-(NSString*) getAddress;
-(NSString*) getReference;
-(NSString*) getCity;
-(NSString*) getNeighborhood;
-(NSString*) getDate;
-(NSString*) getTime;
-(NSString*) getState;
-(void) showNumberError:(NSString*) msg;
-(void) showDateError:(NSString*) msg;
-(void) showTimeError:(NSString*) msg;
-(void) showAddressError:(NSString*) msg;
-(void) showReferenceError:(NSString*) msg;
-(void) showCityError:(NSString*) msg;
-(void) showNeighborhoodError:(NSString*) msg;
-(void) showStateError:(NSString*) msg;
-(void) updateCity:(NSString*)cityName;
-(void)tapView:(UITapGestureRecognizer *)recognizer;
@end
