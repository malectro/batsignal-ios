//
//  BSPostSignalView.h
//  batsignal
//
//  Created by Kyle Warren on 5/3/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSPostSignalView : UIView

@property (nonatomic, readonly) UIView *textFieldBg;
@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, readonly) UIButton *postButton;
@property (nonatomic, readonly) UIButton *cancelButton;

@end
