//
//  BSProfileViewController.m
//  batsignal
//
//  Created by Kyle Warren on 4/30/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import "BSProfileViewController.h"

#import "BSProfileView.h"

@interface BSProfileViewController ()

@end

@implementation BSProfileViewController

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
    self.view = _profileView = [[BSProfileView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
