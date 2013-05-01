//
//  BSLoginViewController.h
//  batsignal
//
//  Created by Kyle Warren on 4/25/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSLoginView;

@interface BSLoginViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic) BSLoginView *loginView;

@end
