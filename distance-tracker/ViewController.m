//
//  ViewController.m
//  distance-tracker
//
//  Created by Adam Zikmund on 01.10.14.
//  Copyright (c) 2014 Adam Zikmund. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _tracker = [[Tracker alloc] init];
    [_tracker setDelegate:self];
    [_tracker startTracking];
    
    _distance = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _distance.text = @"Unknown distance";
    _distance.textColor = [UIColor whiteColor];
    _distance.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_distance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)trackingStarted{
    _distance.text = @"Tracking started";
}
- (void)distanceMeasured:(double)distance{
    _distance.text = [NSString stringWithFormat:@"%i meters", (int)round(distance)];
}

- (void)didEnterRegion:(CLRegion *)region{
    NSLog(@"You entered region: %@", region.identifier);
}

- (void)didExitRegion:(CLRegion *)region{
    NSLog(@"You exited region: %@", region.identifier);
}

@end
