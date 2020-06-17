//
//  UserProfileView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 06/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "UserInfoView.h"
@import GoogleSignIn;

@interface UserProfileView : BaseView


@property (strong, nonatomic) IBOutlet UserInfoView *userView;
@property (strong, nonatomic) IBOutlet CustomButton *btFacebook;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewMenu;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottonMargin;
@property (strong, nonatomic) IBOutlet GIDSignInButton *btGoogle;

-(void) loadView;
-(void) loadViewAfterAppeared;
-(void) unloadView;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(int) numberOfRows;
-(NSString*) getSegueAtIndexPath:(NSIndexPath *)indexPath;
-(void) showLoadingFacebook:(BOOL) loading;
-(void) facebookLinked;
-(void) googleLinked;
@end
