//
//  flightListingCell.h
//  vistara
//
//  Created by Amrit Ghose on 21/11/18.
//  Copyright © 2018 Akanksha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface flightListingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *_departureTime;
@property (weak, nonatomic) IBOutlet UILabel *_arrivalTime;
@property (weak, nonatomic) IBOutlet UILabel *_flighNo;
@property (weak, nonatomic) IBOutlet UILabel *_flightType;
@property (weak, nonatomic) IBOutlet UILabel *_duration;
@property (weak, nonatomic) IBOutlet UIButton *_btnAvailability;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;


@end

NS_ASSUME_NONNULL_END
