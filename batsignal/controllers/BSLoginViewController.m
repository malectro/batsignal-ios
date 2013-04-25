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
    [[BSSession defaultSession] auth];
}

@end
