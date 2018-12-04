//
//  ViewController7.h
//  vistara
//
//  Created by Amrit Ghose on 19/11/18.
//  Copyright © 2018 Akanksha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController7 : UIViewController
@property (nonatomic, retain) NSString* SequenceNumber;
@property (nonatomic, retain) NSString* SecurityToken;
@property (nonatomic, retain) NSString* SessionId;
@property (weak, nonatomic) IBOutlet UILabel *_departureLbl;
@property (weak, nonatomic) IBOutlet UILabel *_arrivalLbl;
@property (weak, nonatomic) IBOutlet UILabel *_departureTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *_arrivalTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *_departureDate;
@property (weak, nonatomic) IBOutlet UILabel *_arrivalDate;
@property (weak, nonatomic) IBOutlet UILabel *_departureTerminal;
@property (weak, nonatomic) IBOutlet UILabel *_arrivalTerminal;
@property (weak, nonatomic) IBOutlet UILabel *_guestName;
@property (weak, nonatomic) IBOutlet UILabel *_flightPnr;


@end

NS_ASSUME_NONNULL_END
