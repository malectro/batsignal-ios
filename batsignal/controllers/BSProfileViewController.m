//
//  BSProfileViewController.m
//  batsignal
//
//  Created by Kyle Warren on 4/30/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSProfileViewController.h"

#import "BSProfileView.h"
#import "BSSession.h"
#import "BSUser.h"

@interface BSProfileViewController ()

@property (nonatomic) BSUser *user;

@end

@implementation BSProfileViewController

@synthesize profileView = _profileView;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.user = [BSSession defaultSession].user;
    }
    return self;
}

- (void)loadView
{
    self.view = self.profileView;
}

- (BSProfileView *)profileView
{
    if (_profileView == nil) {
        self.view = _profileView = [[BSProfileView alloc] init];
        [self viewDidLoad];
    }
    return _profileView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profileView.username.delegate = self;
    
    [self.profileView.username addTarget:self action:@selector(changedHandle) forControlEvents:UIControlEventEditingDidEnd];
    [self.profileView.logoutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchDown];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.user = [BSSession defaultSession].user;
    self.profileView.username.text = self.user.handle;
}

- (void)logOut
{
    [[BSSession defaultSession] logOut];
}

- (void)changedHandle
{
    NSString *newHandle = self.profileView.username.text;
    NSString *oldHandle = self.user.handle;
    
    if (![newHandle isEqualToString:@""]) {
        self.user.handle = newHandle;
        [self.user sync:^(NSDictionary *resultingUser) {
            if (resultingUser && resultingUser[@"handle"] && [self.user.handle isEqualToString:resultingUser[@"handle"]]) {
                // success
                [self.user save];
                self.profileView.username.textColor = [UIColor greenColor];
            } else {
                // failure
                self.user.handle = oldHandle;
                self.profileView.username.textColor = [UIColor redColor];
            }
        }];
    }
}

#pragma mark - textfielddelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
