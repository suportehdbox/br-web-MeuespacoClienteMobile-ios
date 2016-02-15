//
//  DASchedulePickerViewController.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/6/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
	kDAScheduleOptionStart = 0,
	kDAScheduleOptionEnd
};
typedef NSInteger DAScheduleOption;

@protocol DASchedulePickerViewControllerDelegate;

@interface DASchedulePickerViewController : UITableViewController {

	UIDatePicker *schedulePicker;
	DAScheduleOption currentScheduleOption;
	
	NSDate *scheduleStartDate;
	NSDate *scheduleEndDate;

	NSDateFormatter *dateFormat;
	NSDateFormatter *timeFormat;
	NSDateFormatter *hourFormat;
	NSDateFormatter *dateTimeFormat;
	
	id <DASchedulePickerViewControllerDelegate> delegate;
	BOOL isDatesValidated;
}

@property (nonatomic, copy) NSDate *scheduleStartDate;
@property (nonatomic, copy) NSDate *scheduleEndDate;

@property (nonatomic, strong) id <DASchedulePickerViewControllerDelegate> delegate;

- (void)validateDates;
- (id)initWithScheduleBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
- (IBAction)btnBack:(id)sender;
- (IBAction)btnOK:(id)sender;

@end

@protocol DASchedulePickerViewControllerDelegate <NSObject>
@optional

- (void)schedulePickerViewControllerDidPickScheduleDates:(DASchedulePickerViewController *)schedulePickerViewController;

@end