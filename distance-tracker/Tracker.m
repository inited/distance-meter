//
//  Tracker.m
//  distance-tracker
//
//  Created by Adam Zikmund on 01.10.14.
//  Copyright (c) 2014 Adam Zikmund. All rights reserved.
//

#import "Tracker.h"

// Pro zjištování GPS pozic používám tento nástroj http://itouchmap.com/latlong.html

// GPS lokace
#define GPS_1_LATITUDE              50.074433
#define GPS_1_LONGITUDE             14.419652

#define GPS_2_LATITUDE              50.074341
#define GPS_2_LONGITUDE             14.415998

#define GPS_3_LATITUDE              50.074607
#define GPS_3_LONGITUDE             14.415009


// Omezení
#define DISTANCE_CAP                    20.0          // V metrech
#define REGION_DISTANCE_RAIDUS          25.0          // V metrech

#define SOUNDS_EXTENSION                @"mp3"

@implementation Tracker {
    NSArray *_locations;
    NSArray *_regions;
    CLLocationManager *_locationManager;
    CLLocation *_userLocation;
    AVAudioPlayer *_audioPlayer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locations = [NSArray arrayWithObjects:
                     [[CLLocation alloc] initWithLatitude:GPS_1_LATITUDE longitude:GPS_1_LONGITUDE],
//                     [[CLLocation alloc] initWithLatitude:GPS_2_LATITUDE longitude:GPS_2_LONGITUDE],
//                     [[CLLocation alloc] initWithLatitude:GPS_3_LATITUDE longitude:GPS_3_LONGITUDE],
                      nil];
        
        _regions = [NSArray arrayWithObjects:
                    [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(GPS_1_LATITUDE, GPS_1_LONGITUDE) radius:REGION_DISTANCE_RAIDUS identifier:@"Region 1"],
//                    [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(GPS_2_LATITUDE, GPS_2_LONGITUDE) radius:REGION_DISTANCE_RAIDUS identifier:@"Region 2"],
//                    [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(GPS_3_LATITUDE, GPS_3_LONGITUDE) radius:REGION_DISTANCE_RAIDUS identifier:@"Region 3"],
                    nil];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        _audioPlayer = [[AVAudioPlayer alloc] init];
        
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_locationManager allowDeferredLocationUpdatesUntilTraveled:0.0 timeout:0.0];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _userLocation = [locations lastObject];
    
    CLLocationDistance nearestDistance = CLLocationDistanceMax;
    for (CLLocation *location in _locations) {
        CLLocationDistance distance = [_userLocation distanceFromLocation:location];
        if (distance < nearestDistance) {
            nearestDistance = distance;
        }
    }
    
    [self distanceMeasured:nearestDistance];
    [self playSoundEffect:nearestDistance];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    [self didEnterRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    [self didExitRegion:region];
}

- (void)playSoundEffect:(double)distance{
    int roundedDistance = (int)round(distance);
    
    
    if (roundedDistance <= DISTANCE_CAP) {
        NSError *error = nil;

        // zaporne hodnoty pouzivam pro prenos udalosti - vstoupil, opustil
        if (roundedDistance <= 0) {
            roundedDistance = - roundedDistance;
        }
        
        NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%i", roundedDistance] withExtension:SOUNDS_EXTENSION];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
        
        if (error != nil) {
            NSLog(@"%@", error);
        }else{
            _audioPlayer.volume = 1.0;
            [_audioPlayer prepareToPlay];
            [_audioPlayer play];
   
        }
    }
}

- (void)startTracking{
    if (_locationManager != nil) {
        [_locationManager startUpdatingLocation];
        
        for (CLRegion *region in _regions) {
            [_locationManager startMonitoringForRegion:region];
        }
        
        [self trackingStarted];
    }
}

- (void)trackingStarted{
    if (_delegate != nil) {
        [_delegate trackingStarted];
    }
}
- (void)distanceMeasured:(double)distance{
    if (_delegate != nil) {
        [_delegate distanceMeasured:distance];
    }
    NSLog(@"%f", distance);
}

- (void)didEnterRegion:(CLRegion *)region{
    [self playSoundEffect:-100];
    if (_delegate != nil) {
        [_delegate didEnterRegion:region];
    }
}

- (void)didExitRegion:(CLRegion *)region{
    [self playSoundEffect:-101];
    if (_delegate != nil) {
        [_delegate didExitRegion:region];
    }
}
@end
