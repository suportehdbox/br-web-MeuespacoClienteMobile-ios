//
//  DASchedulePickerViewController.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/6/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DASchedulePickerViewController.h"

@implementation DASchedulePickerViewController

#define SCHEDULE_TIME_INTERVAL 2

@synthesize scheduleStartDate, scheduleEndDate, delegate;

enum {
	kDASchedulePickerComponentDate,
	kDASchedulePickerComponentHour,
	kDASchedulePickerComponentMinute,
	TOTAL_COMPONENTS
};

- (id)init {

	if (self = [super initWithNibName:@"DASchedulePickerViewController" bundle:[NSBundle bundleForClass:[self class]]]) {

		dateTimeFormat = [[NSDateFormatter alloc] init];
		[dateTimeFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
		
		dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"dd/MM/yyyy"];
		
		timeFormat = [[NSDateFormatter alloc] init];
		[timeFormat setDateFormat:@"HH:mm"];
		
		hourFormat = [[NSDateFormatter alloc] init];
		[hourFormat setDateFormat:@"HH"];

		NSInteger hours = [[hourFormat stringFromDate:[NSDate date]] intValue];
		scheduleStartDate = [[NSDate dateWithoutTime] dateByAddingHours:hours+1]; 
		scheduleEndDate = [[NSDate dateWithoutTime] dateByAddingHours:hours+3]; 
	}
	return self;
}

- (id)initWithScheduleBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate {

	if (self = [self init]) {
		
		if (nil != beginDate) 
			scheduleStartDate = beginDate;

		if (nil != endDate) 
			scheduleEndDate = endDate;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = DALocalizedString(@"Schedule", nil);

	currentScheduleOption = kDAScheduleOptionStart;		
		
	schedulePicker = [[UIDatePicker alloc] init];
	schedulePicker.datePickerMode = UIDatePickerModeDateAndTime;
	[schedulePicker addTarget:self action:@selector(controlEventValueChanged) forControlEvents:UIControlEventValueChanged];	

	schedulePicker.minuteInterval = 30;
	
	NSInteger hours = [[hourFormat stringFromDate:[NSDate date]] intValue];
	schedulePicker.minimumDate = [[NSDate dateWithoutTime] dateByAddingHours:hours+1];
	schedulePicker.maximumDate = [[NSDate date] dateByAddingDays:5];
	schedulePicker.date = scheduleStartDate;

	CGRect pickerRect = schedulePicker.frame;
	pickerRect.origin.y = self.tableView.frame.size.height - pickerRect.size.height - 44;
	schedulePicker.frame = pickerRect;

	[self.view addSubview:schedulePicker];
    
    [Utility addBackButtonNavigationBar:self action:@selector(btnBack:)];
    
    UIBarButtonItem *okButton = [Utility addCustomButtonNavigationBar:self action:@selector(btnOK:) imageName:@"btn-ok.png"];
    self.navigationItem.rightBarButtonItem = okButton;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnOK:(id)sender
{
    if ([delegate respondsToSelector:@selector(schedulePickerViewControllerDidPickScheduleDates:)])
		[delegate schedulePickerViewControllerDidPickScheduleDates:self];
	
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
	if (indexPath.row == kDAScheduleOptionStart) {
		cell.textLabel.text = [DALocalizedString(@"From", nil) lowercaseString];
		cell.detailTextLabel.text = [dateTimeFormat stringFromDate:scheduleStartDate];
	}
	else {
		cell.textLabel.text = [DALocalizedString(@"To", nil) lowercaseString];
		cell.detailTextLabel.text = [timeFormat stringFromDate:scheduleEndDate];
	}
	
	if (currentScheduleOption == indexPath.row) 
		[self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
				
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
	switch (indexPath.row) {
		case kDAScheduleOptionStart:
			currentScheduleOption = kDAScheduleOptionStart;
			[schedulePicker setDate:[scheduleStartDate copy] animated:YES];
			break;
		case kDAScheduleOptionEnd:
			currentScheduleOption = kDAScheduleOptionEnd;
			[schedulePicker setDate:[scheduleEndDate copy] animated:YES];
			break;
		default:
			break;
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;	
}
*/


- (void)controlEventValueChanged {
	
	if (currentScheduleOption == kDAScheduleOptionStart) {
		
		scheduleStartDate = [schedulePicker.date copy];
		
		scheduleEndDate = [scheduleStartDate dateByAddingHours:SCHEDULE_TIME_INTERVAL];
	}
	else {
		
		scheduleEndDate = [schedulePicker.date copy];

		scheduleStartDate = [scheduleEndDate dateByAddingHours:-SCHEDULE_TIME_INTERVAL];
	}
	
	[self.tableView reloadData];
}


- (void)validateDates {
	
	
	
	isDatesValidated = YES;
}



@end

