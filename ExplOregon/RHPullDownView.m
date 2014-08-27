//
//  RHPullDownView.m
//  ExplOregon
//
//  Created by Herrington, Ryley on 8/27/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import "RHPullDownView.h"



@implementation RHPullDownView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}


- (void)initialize {
    NSLog(@"Initializing view");
    self.button.titleLabel.text = @"Woot";
    self.label.text = @"Changed text";
}

- (IBAction)buttonTouched:(id)sender {
    NSLog(@"Button Touched in view.");
    if (self.delegate){
        [self.delegate didTapButton];
    }
}
@end
