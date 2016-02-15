//
//  DAAssistanceMenuAllViewController.m
//  DirectAssistHyundai
//
//  Created by Danilo Salvador on 10/29/12.
//  Copyright (c) 2012 Mondial Assistance. All rights reserved.
//

#import "DAAssistanceMenuAllViewController.h"
#import "DABannerCell.h"
#import "DANewCaseViewController.h"
#import "DACasesListViewController.h"
#import "DADealersListViewController.h"
#import "DAAccreditedGaragesViewController.h"
#import "DACallMaker.h"
#import "DAAssistance.h"
#import "DAUserLocation.h"
#import "DASharedManager.h"
#import "DAPhone.h"
#import "DAUserPhone.h"
#import "DAUserPhoneViewController.h"
#import "GoogleAnalyticsManager.h"

#define CELL_HEIGHT_BANNER 140
#define CELL_HEIGHT_DEFAULT 44

@interface DAAssistanceMenuAllViewController ()

@end

@implementation DAAssistanceMenuAllViewController
@synthesize delegate;

//<< EPO: Alteração para não chamar Assistência Residencia:
//    códigos comentados
// >>

enum DAAssistanceMenuSections {
    kDAServicesSectionAuto = 0,
    kDAServicesSectionAutoMyCase,
//    kDAServicesSectionProperty,
//    kDAServicesSectionPropertyMyCase,
    kDAUserPhone,
//    kDABannerSection,
    NUM_SECTIONS
};

enum DAAssistanceMenuRows {
    kDAServicesRowTitle = 0,
    kDAServicesRowNewCase,
    kDAServicesRowCall
};

- (id)initWithOptions:(NSArray *)menuOptions {
    
    if (self = [super initWithNibName:@"DAAssistanceMenuAllViewController" bundle:[NSBundle bundleForClass:[self class]]]) {
		options = menuOptions;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [[DASharedManager sharedManager] clearCaseList];
    
//  [[DAAssistance application] initializeClient:[[Client alloc] init]];
//	[DAUserLocation startUpdatingLocation];
    
    self.navigationItem.title = @"Assistência 24h";
        
    [Utility addBackButtonNavigationBar:self action:@selector(btnMenu:)];
}

-(void)viewDidAppear:(BOOL)animated
{
        
    [[DAAssistance application] initializeClient:[[Client alloc] init]];
    [DAUserLocation startUpdatingLocation];
    
    if ([DAUserPhone getUserPhone] == nil) {
        
        DAUserPhoneViewController *userPhoneVC = [[DAUserPhoneViewController alloc] initWithNibName:@"DAUserPhoneViewController" bundle:[NSBundle bundleForClass:[self class]]];
        
        [self.navigationController pushViewController:userPhoneVC animated:YES];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kDAServicesSectionAuto:
            return 15;
        case kDAServicesSectionAutoMyCase:
            return 0;
//        case kDAServicesSectionProperty:
//            return 0;
//        case kDAServicesSectionPropertyMyCase:
//            return 0;
        case kDAUserPhone:
            return 0;
//        case kDABannerSection:
//            return 0;
        default:
            return 0;
    }
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case kDAServicesSectionAuto:
            return 1;
        case kDAServicesSectionAutoMyCase:
            return 15;
//        case kDAServicesSectionProperty:
//            return 1;
//        case kDAServicesSectionPropertyMyCase:
//            return 15;
        case kDAUserPhone:
            return 15;
//        case kDABannerSection:
//            return 15;
        default:
            return 0;
    }
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kDAServicesSectionAuto:
            return 3;
        case kDAServicesSectionAutoMyCase:
            return 1;
//        case kDAServicesSectionProperty:
//            return 3;
//        case kDAServicesSectionPropertyMyCase:
//            return 1;
        case kDAUserPhone:
            return 1;
//        case kDABannerSection:
//            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if (indexPath.section != kDABannerSection) {
    
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil && indexPath.row == 0 && (indexPath.section == kDAServicesSectionAuto
//                                                  || indexPath.section == kDAServicesSectionProperty
                                                  )) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:CellIdentifier];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        switch (indexPath.section) {
            case kDAServicesSectionAuto:
                
                switch (indexPath.row) {
                    case kDAServicesRowTitle:
                        cell.backgroundColor = [UIColor colorWithRed:8.0/255 green:57.0/255 blue:123.0/255 alpha:1];
                        cell.imageView.image = [Utility imageWithImage:@"03_sinistros-icone-auto.png" scale:2.0];                      
                        cell.textLabel.text = DALocalizedString(@"Automotive", nil);
                        cell.textLabel.textColor = [UIColor whiteColor];
                        cell.userInteractionEnabled = NO;
                        break;
                    case kDAServicesRowNewCase:
                        cell.textLabel.text = DALocalizedString(@"NewCase", nil);
                        cell.textLabel.textColor = [UIColor colorWithRed:82.0/255 green:82.0/255 blue:82.0/255 alpha:1];
                        break;
                    case kDAServicesRowCall:
                        cell.textLabel.text = DALocalizedString(@"CallToAssistanceCentre", nil);
                        cell.textLabel.textColor = [UIColor colorWithRed:82.0/255 green:82.0/255 blue:82.0/255 alpha:1];
                        cell.accessoryView = [[UIImageView alloc ] initWithImage:[Utility imageWithImage:@"20-assistencia-icon-ligar.png" scale:2.0]];
                        break;
                }
                
                break;
            case kDAServicesSectionAutoMyCase:
                
                cell.textLabel.text = DALocalizedString(@"MyFiles", nil);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.textColor = [UIColor colorWithRed:82.0/255 green:82.0/255 blue:82.0/255 alpha:1];
                
                break;
//            case kDAServicesSectionProperty:
//                
//                switch (indexPath.row) {
//                    case kDAServicesRowTitle:
//                        cell.backgroundColor = [UIColor colorWithRed:8.0/255 green:57.0/255 blue:123.0/255 alpha:1];
//                        cell.imageView.image = [Utility imageWithImage:@"20-assistencia-icon-residencia.png" scale:2.0];
//                        cell.textLabel.text = DALocalizedString(@"Property", nil);
//                        cell.textLabel.textColor = [UIColor whiteColor];
//                        cell.userInteractionEnabled = NO;
//                        break;
//                    case kDAServicesRowNewCase:
//                        cell.textLabel.text = DALocalizedString(@"NewCase", nil);
//                        cell.textLabel.textColor = [UIColor colorWithRed:82.0/255 green:82.0/255 blue:82.0/255 alpha:1];
//                        break;
//                    case kDAServicesRowCall:
//                        cell.textLabel.text = DALocalizedString(@"CallToAssistanceCentre", nil);
//                        cell.textLabel.textColor = [UIColor colorWithRed:82.0/255 green:82.0/255 blue:82.0/255 alpha:1];
//                        cell.accessoryView = [[UIImageView alloc ] initWithImage:[Utility imageWithImage:@"20-assistencia-icon-ligar.png" scale:2.0]];
//                        break;
//                }
//
//                break;
//            case kDAServicesSectionPropertyMyCase:
//                
//                cell.textLabel.text = DALocalizedString(@"MyFiles", nil);
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                cell.textLabel.textColor = [UIColor colorWithRed:82.0/255 green:82.0/255 blue:82.0/255 alpha:1];
//                
//                break;
            case kDAUserPhone:
                
                cell.textLabel.text = DALocalizedString(@"MyPhoneNumber", nil);
                cell.imageView.image = [Utility imageWithImage:@"20-assistencia-icon-ligar.png" scale:2.0];
                cell.textLabel.textColor = [UIColor colorWithRed:82.0/255 green:82.0/255 blue:82.0/255 alpha:1];
                
                break;
        }
        
        return cell;
        
//    } else {
//        
//        static NSString *CellIdentifier = @"MainBanner";
//        banner = (DABannerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if (banner == nil) {
//            banner = [[DABannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//
////        banner.bannerImageView.image = [UIImage imageNamed:@"Banner.jpg"];
//        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//        UIImage *image = [UIImage imageNamed:@"Banner.jpg" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
//        banner.bannerImageView.image = image;
//        return banner;
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    return (indexPath.section == kDABannerSection) ? CELL_HEIGHT_BANNER: CELL_HEIGHT_DEFAULT;
    return CELL_HEIGHT_DEFAULT;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kDAServicesSectionAuto:
            
            switch (indexPath.row) {
                case kDAServicesRowTitle:
                    //No action
                    break;
                    
                case kDAServicesRowNewCase:
                {
                    DANewCaseViewController *newCaseVC = [[DANewCaseViewController alloc] init];
                    [newCaseVC setAssistanceType:kDAAssistanceTypeAutomotive];
                    [self.navigationController pushViewController:newCaseVC animated:YES];
                }
                    break;
                    
                case kDAServicesRowCall:
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    DACallMaker *callMaker = [[DACallMaker alloc] init];
                    [callMaker callToClientPhoneNumber:self.view assistanceType:kDAAssistanceTypeAutomotive];
                }
                    break;
            }
            break;
            
        case kDAServicesSectionAutoMyCase:
        {
            if (![Utility hasInternet]) {
                [Utility showNoInternetWarning];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
            
            DACasesListViewController *casesListVC = [[DACasesListViewController alloc] init];
            [casesListVC setAssistanceType:kDAAssistanceTypeAutomotive];
            [self.navigationController pushViewController:casesListVC animated:YES];
        }
            break;
            
//        case kDAServicesSectionProperty:
//            
//            switch (indexPath.row) {
//                case kDAServicesRowTitle:
//                    //No action
//                    break;
//                case kDAServicesRowNewCase:
//                {
//                    DANewCaseViewController *newCaseVC = [[DANewCaseViewController alloc] init];
//                    [newCaseVC setAssistanceType:kDAAssistanceTypeProperty];
//                    [self.navigationController pushViewController:newCaseVC animated:YES];
//                }
//                    break;
//                    
//                case kDAServicesRowCall:
//                {
//                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//                    
//                    DACallMaker *callMaker = [[DACallMaker alloc] init];
//                    [callMaker callToClientPhoneNumber:self.view assistanceType:kDAAssistanceTypeProperty];
//                }
//                    break;
//                    
//            }
//            break;
//            
//        case kDAServicesSectionPropertyMyCase:
//        {
//            if (![Utility hasInternet]) {
//                [Utility showNoInternetWarning];
//                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//                return;
//            }
//            
//            DACasesListViewController *casesListVC = [[DACasesListViewController alloc] init];
//            [casesListVC setAssistanceType:kDAAssistanceTypeProperty];
//            [self.navigationController pushViewController:casesListVC animated:YES];
//        }
//            break;
            
        case kDAUserPhone:
        {
            DAUserPhoneViewController *userPhoneVC = [[DAUserPhoneViewController alloc] initWithNibName:@"DAUserPhoneViewController" bundle:[NSBundle bundleForClass:[self class]]];
            [self.navigationController pushViewController:userPhoneVC animated:YES];
        }
            break;
            
//        case kDABannerSection:
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[DAConfiguration settings].applicationClient.bannerHomepage]];
//            break;
    }
}

- (IBAction)btnMenu:(id)sender
{
    [delegate returnDirectAssist:[[DASharedManager sharedManager] caseList]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
