//
//  ViewController.h
//  distance-tracker
//
//  Created by Adam Zikmund on 01.10.14.
//  Copyright (c) 2014 Adam Zikmund. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tracker.h"

@interface ViewController : UIViewController <TrackerProtocol>
@property (nonatomic, strong) Tracker *tracker;
@property (nonatomic, strong) UILabel *distance;
@end

