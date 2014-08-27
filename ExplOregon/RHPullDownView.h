//
//  RHPullDownView.h
//  ExplOregon
//
//  Created by Herrington, Ryley on 8/27/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RHPullDownDelegate <NSObject>

@optional
- (void)didTapButton;

@end

@interface RHPullDownView : UIView
@property (nonatomic, weak) id<RHPullDownDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
