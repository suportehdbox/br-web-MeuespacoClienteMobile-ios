//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "MenuViewController.h"
#import "BaseView.h"
#import "MenuTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+Letters.h"
#import "BaseModel.h"
#import <appsegurado-Swift.h>

@implementation SWUITableViewCell{
    
    
}
@end
@interface MenuViewController(){
    UIColor *bgColor;
    NSMutableArray *arrayMenus;
    AppDelegate *appDelegate;
    BOOL inTransition;
    BOOL loaded;
    NSString *version;
    HomeAssistWebViewController *wvc;
}
@end
@implementation MenuViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    if(PRODUCTION){
        version = [NSString stringWithFormat:@"Versão: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];;
    }else{
        version = [NSString stringWithFormat:@"Versão: %@ - ACT",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];;
    }
    
    
    bgColor = [BaseView getColor:@"FundoMenu"];
    
    if (@available(iOS 13.0, *)) {
        //Obj-C:
        UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
        statusBar.backgroundColor = [BaseView getColor:@"NavBarCollor"];
        [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
        
        
    }else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [BaseView getColor:@"NavBarCollor"];
        }
    }
    inTransition = false;
    arrayMenus = [[NSMutableArray alloc] init];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([appDelegate isUserLogged]){
        
        
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"OlaVisitante",@""),@"title",
                               @"user.png",@"image", @"ShowHome", @"identifier", nil]];
        
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"MeusDadosMenu",@""),@"title",
                               @"login.png",@"image", @"ShowMyData", @"identifier",nil]];
        
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"ApolicesMenu",@""),@"title",
                               @"polices.png",@"image", @"ShowPolicy", @"identifier",nil]];
    }else{
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"OlaVisitante",@""),@"title",
                               @"user.png",@"image", @"ShowHomeOff", @"identifier", nil]];
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"FacaLoginMenu",@""),@"title",
                               @"login.png",@"image", @"dismiss", @"identifier", nil]];
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"CadastrarMenu",@""),@"title",
                               @"register.png",@"image",@"DoRegisterLogout", @"identifier", nil]];
    }
    
    
    if( [appDelegate has_auto_policy] || ![appDelegate isUserLogged]){
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"AcidenteMenu",@""),@"title",
                               @"accident.png",@"image", @"ShowAccidentAssist", @"identifier",nil]];
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"OficinasMenu",@""),@"title",
                               @"workshops.png",@"image",@"ShowAutoWorkShops", @"identifier", nil]];
    }else if([appDelegate isUserLogged] &&  [[[appDelegate getLoggeduser] policyHome] insurance].allowPHS){
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"AcidenteMenu",@""),@"title",
                               @"accident.png",@"image", @"ShowAccidentAssistHome", @"identifier",nil]];
    }
    
    if(![Config isAliroProject]){
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"ClubeMenu",@""),@"title",
                               @"club.png",@"image",@"ShowNewClub", @"identifier", nil]];
    }
    
    if([appDelegate isUserLogged]){
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"NotificacoesMenu",@""),@"title",
                               @"notification.png",@"image",@"NotificationMenu", @"identifier", nil]];
        
    }
    
    [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"FaleConoscomenu",@""),@"title",
                           @"contact.png",@"image", @"ShowContact", @"identifier",nil]];
    
    if([appDelegate isUserLogged]){
        [arrayMenus addObject:[[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"SairMenu",@""),@"title",
                               @"exit.png",@"image",@"dismiss", @"identifier", nil]];
        
    }
    
    
    [self.tableView setBackgroundColor:bgColor];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!loaded){
        [self.tableView reloadData];
        loaded = true;
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    inTransition = false;
}
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    //    if ( [sender isKindOfClass:[UITableViewCell class]] )
    //    {
    //        UILabel* c = [(SWUITableViewCell *)sender label];
    //        UINavigationController *navController = segue.destinationViewController;
    //
    //    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayMenus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    
    MenuTableViewCell *cell;
    if(indexPath.row ==0){
        
        
        
        cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier: @"MenuCellUsuario" forIndexPath: indexPath];
        [cell setBackgroundCellColor:[BaseView getColor:@"MenuSelecionado"]];
        [cell.imgIcon setContentMode:UIViewContentModeScaleAspectFit];
        
        if([appDelegate isUserLogged]){
            //"OlaLogado" = "Olá %@";
            UserBeans * beans = [appDelegate getLoggeduser];
            [cell.lblTitle setText:[NSString stringWithFormat:NSLocalizedString(@"OlaLogado", @""), [[beans.userName componentsSeparatedByString:@" "] firstObject]]];
            if(beans.photoImg == nil){
                [cell.imgIcon setContentMode:UIViewContentModeScaleAspectFill];
                
                [cell.imgIcon setImageWithString:[beans.userName substringToIndex:1]  color:[BaseView getColor:@"AzulClaro"] circular:NO ];
                //                [cell.imgIcon setImage:[UIImage imageNamed:[[arrayMenus objectAtIndex:indexPath.row] objectForKey:@"image"]]];
                [cell.imgIcon.layer setCornerRadius:14];
                cell.imgIcon.clipsToBounds = YES;
            }else{
                [cell.imgIcon setImage:beans.photoImg];
                [cell.imgIcon.layer setCornerRadius:14];
                cell.imgIcon.clipsToBounds = YES;
            }
            
            if(![Config isAliroProject]){
                if(beans.photoImg == nil){
                    [cell.imgIcon setImageWithString:[beans.userName substringToIndex:1]  color:[BaseView getColor:@"Verde"] circular:NO textAttributes:@{
                        NSFontAttributeName: [BaseView getDefatulFont:Menu bold:YES],                                      NSForegroundColorAttributeName: [BaseView getColor:@"AzulEscuro"]
                    }];
                }
            }
        }else{
            [cell.lblTitle setText:[[arrayMenus objectAtIndex:indexPath.row] objectForKey:@"title"]];
            [cell.imgIcon setImage:[UIImage imageNamed:[[arrayMenus objectAtIndex:indexPath.row] objectForKey:@"image"]]];
        }
    }else{
        cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
        [cell.lblTitle setText:[[arrayMenus objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [cell.imgIcon setImage:[UIImage imageNamed:[[arrayMenus objectAtIndex:indexPath.row] objectForKey:@"image"]]];
        if([cell.lblTitle.text isEqualToString:NSLocalizedString(@"NotificacoesMenu", @"")]){
            int numNotifications = (int)[[UIApplication sharedApplication] applicationIconBadgeNumber];
            if(numNotifications > 0 ){
                [cell.lblNumNotifications setText:[NSString stringWithFormat:@"%d",numNotifications]];
                [cell.lblNumNotifications setFont:[BaseView getDefatulFont:Nano bold:NO]];
                [cell.imgIcon setImage:[UIImage imageNamed: @"notification_red.png"]];
            }
        }else{
            [cell.lblNumNotifications setText:@""];
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSString *identifier = [[arrayMenus objectAtIndex:indexPath.row] objectForKey:@"identifier"];
    if(![identifier isEqualToString:@""] && !inTransition){
        inTransition = true;
        if([identifier isEqualToString:@"dismiss"]){
            if([appDelegate isUserLogged]){
                [appDelegate logoutUser];
            }
            if([[[arrayMenus objectAtIndex:indexPath.row] objectForKey:@"title"] isEqualToString:NSLocalizedString(@"FacaLoginMenu",@"")]){
                [appDelegate setGotoLoginView:YES];
            }
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if([identifier isEqualToString:@"ShowAccidentAssistHome"]){
            
            if(wvc == nil){
                wvc = [[HomeAssistWebViewController alloc] init];
            }
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:wvc];
            [self.revealViewController pushFrontViewController:navController animated:YES];
            
        }else if([identifier isEqualToString:@"ShowNewClub"]){
            NewClubViewController *newClub = [[NewClubViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newClub];
            [self.revealViewController pushFrontViewController:navController animated:YES];
            
        }else{
            [self performSegueWithIdentifier:identifier sender:nil];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sampleView = [[UIView alloc] init];
    sampleView.frame = CGRectMake(10, 0, 240, 30);
    UILabel *lblVersion = [[UILabel alloc] initWithFrame:sampleView.frame];
    [lblVersion setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [lblVersion setTextColor:[UIColor whiteColor]];
    [lblVersion setText:version];
    [lblVersion setTextAlignment:NSTextAlignmentRight];
    [sampleView addSubview:lblVersion];
    return sampleView;
}

#pragma mark state preservation / restoration
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}

- (void)applicationFinishedRestoringState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO call whatever function you need to visually restore
}

@end
