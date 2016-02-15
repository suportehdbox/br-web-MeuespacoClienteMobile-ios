//
//  DAUserPhoneViewController.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 05/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//
#import "DAAssistanceMenuAllViewController.h"
#import "DAUserPhoneViewController.h"
#import "DAUserPhoneCell.h"
#import "DAUserPhone.h"

@implementation DAUserPhoneViewController
@synthesize basePhone;
@synthesize ddd11;

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.navigationItem.title = DALocalizedString(@"PhoneNumber", nil);
	self.ddd11 = @"11";
    
    UIBarButtonItem *saveItem = [Utility addCustomButtonNavigationBar:self action:@selector(save:) imageName:@"44-assistenciares-localref-btn-salvar.png"];
    self.navigationItem.rightBarButtonItem = saveItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)save:(id)sender {
	
    if (self.basePhone.length >= 9) {
		
		DAUserPhone *userPhone = [[DAUserPhone alloc] init];
		userPhone.areaCode = [self.basePhone substringToIndex:2];
		userPhone.phoneNumber = [self.basePhone substringFromIndex:2];
		[userPhone save];
        
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Aviso"
                                                            message:@"As informações preenchidas no aplicativo serão enviadas aos nossos servidores quando você solicitar um serviço."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
		[alertView show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"FailSavingPhoneNumber", nil)
														message:DALocalizedString(@"CheckFilledInformation", nil) 
													   delegate:nil 
											  cancelButtonTitle:nil 
											  otherButtonTitles:DALocalizedString(@"OK", nil), nil];
		[alert show];
	}
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return DALocalizedString(@"FillPhoneNumberInformation", nil); 
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"UserPhone";
    
    phoneCell = (DAUserPhoneCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (phoneCell == nil) {
		//phoneCell = [[DAUserPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       [[NSBundle bundleForClass:[self class]] loadNibNamed:@"DAUserPhoneCell" owner:self options:nil];
    }
   
	DAUserPhone *userPhone = [DAUserPhone getUserPhone];
	if (userPhone.phoneNumber != nil) {
		NSRange range;
		range.location = 4;
		range.length = 4;
		
		self.basePhone = [NSString stringWithFormat:@"%@%@", userPhone.areaCode, userPhone.phoneNumber];
		//formattedPhone = [NSString stringWithFormat:@"(%@) %@-%@", userPhone.areaCode,
		//				  [userPhone.phoneNumber substringToIndex:4],
		//				  [userPhone.phoneNumber substringFromIndex:4]];
		//phoneCell.txtUserPhone.text = formattedPhone;
        phoneCell.txtUserPhone.text = [self formatPhoneNumber:self.basePhone];
	} else {
		self.basePhone = @"";
		formattedPhone = @"";
		phoneCell.txtUserPhone.text = @"";
	}
	
	phoneCell.selectionStyle = UITableViewCellSelectionStyleNone;
	phoneCell.txtUserPhone.delegate = self;
	[phoneCell.txtUserPhone becomeFirstResponder];
	
    return phoneCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
    int lenghtNumber = 10;
    
    if (self.basePhone.length >= 2) {
        if ([[self.basePhone substringToIndex:2] isEqualToString:self.ddd11]) {
            lenghtNumber = 11;
        } else {
            lenghtNumber = 10;
        }
    }
    
	if (self.basePhone.length < lenghtNumber || [string isEqualToString:@""]) {
		NSString *tmpString = string;
		
		if (![tmpString isEqualToString:@""])
			self.basePhone = [self.basePhone stringByAppendingString:tmpString];
		else
			self.basePhone = [self.basePhone substringToIndex:self.basePhone.length - 1];
		
		if (self.basePhone.length > 2)
			formattedPhone = [self formatPhoneNumber:self.basePhone];
		else
			formattedPhone = self.basePhone;
	}
	
	textField.text = formattedPhone;
	return NO;
}

- (NSString *) formatPhoneNumber:(NSString *)phoneNumber {
	
	NSString *tempStr = [[NSString alloc] initWithString:@""];
	NSString *areaCode = [phoneNumber substringToIndex:2];
	
	if (phoneNumber.length > 6) {
		
		NSRange range;
        NSString *phone1;
        NSString *phone2;
        
        if ([areaCode isEqualToString:self.ddd11]) {
        
            range.location = 2;
            range.length = 5;
		
            phone1 = [phoneNumber substringWithRange:range];
            phone2 = [phoneNumber substringFromIndex:7];
            
        } else {
        
            range.location = 2;
            range.length = 4;
            
            phone1 = [phoneNumber substringWithRange:range];
            phone2 = [phoneNumber substringFromIndex:6];
        }
		tempStr = [NSString stringWithFormat:@"(%@) %@-%@", areaCode, phone1, phone2];
	} else {
		NSString *phone = [phoneNumber substringFromIndex:2];
		tempStr = [NSString stringWithFormat:@"(%@) %@", areaCode, phone];		
	}
	
	return tempStr;
}
	


@end

