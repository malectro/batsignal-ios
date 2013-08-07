//
//  BSLoginViewController.m
//  batsignal
//
//  Created by Kyle Warren on 4/25/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSLoginViewController.h"

#import "BSLoginView.h"
#import "BSSession.h"

@interface BSLoginViewController ()

@property (nonatomic) UIActionSheet *actionSheet;
@property (nonatomic) NSArray *twitterAccounts;

@end

@implementation BSLoginViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = self.loginView = [[BSLoginView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.loginView.twitterLoginButton addTarget:self action:@selector(twitterLogin) forControlEvents:UIControlEventTouchDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)twitterLogin
{
    [[BSSession defaultSession] getTwitterAccounts:^(NSArray *accounts, NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.twitterAccounts = accounts;
            
            _actionSheet = nil;
            self.actionSheet = [self.actionSheet initWithTitle:@"Which account?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            
            for (ACAccount *account in self.twitterAccounts) {
                [self.actionSheet addButtonWithTitle:account.username];
            }
            
            [self.actionSheet showInView:self.view];
        });
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[BSSession defaultSession] authWithTwitterAccount:self.twitterAccounts[buttonIndex]];
    [self.actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (UIActionSheet *)actionSheet
{
    if (_actionSheet == nil) {
        _actionSheet = [[UIActionSheet alloc] init];
    }
    return _actionSheet;
}

@end
