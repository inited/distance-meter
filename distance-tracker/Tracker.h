//
//  Tracker.h
//  distance-tracker
//
//  Created by Adam Zikmund on 01.10.14.
//  Copyright (c) 2014 Adam Zikmund. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@protocol TrackerProtocol <NSObject>
@required
- (void)trackingStarted;
- (void)distanceMeasured:(double)distance;
- (void)didEnterRegion:(CLRegion *)region;
- (void)didExitRegion:(CLRegion *)region;
@end

@interface Tracker : NSObject <CLLocationManagerDelegate, TrackerProtocol>;
@property (nonatomic, weak) id<TrackerProtocol> delegate;

- (instancetype)init;
- (void)startTracking;
@end
