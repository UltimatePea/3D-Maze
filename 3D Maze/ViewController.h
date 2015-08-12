//
//  ViewController.h
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZoomedIn,
    ZoomedOut,
} Zoom;

@interface ViewController : UIViewController

@property (nonatomic) int mazeWidth, mazeHeight;
@property (nonatomic) BOOL adsEnabled;
@property (nonatomic) double animationDuration;

- (void)remindUser:(NSString *)remind  withDuration:(NSTimeInterval)duration;

- (void)resetADPosition:(Zoom)zoom;

@end

