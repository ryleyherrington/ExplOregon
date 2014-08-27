//
//  RHDetailCell.h
//  ExplOregon
//
//  Created by Herrington, Ryley on 8/27/14.
//  Copyright (c) 2014 Ryley Herrington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHDetailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@end
