//
//  flightListingCell.m
//  vistara
//
//  Created by Amrit Ghose on 21/11/18.
//  Copyright © 2018 Akanksha. All rights reserved.
//

#import "flightListingCell.h"

@implementation flightListingCell
@synthesize _departureTime,_flighNo,_duration,_flightType,_arrivalTime;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
