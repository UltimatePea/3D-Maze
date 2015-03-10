//
//  Position.h
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject

@property (nonatomic) int xCoordinate, yCoordinate;

- (instancetype)initWithX:(int)x withY:(int)y;
+ (instancetype)positionWithX:(int)x withY:(int)y;
- (BOOL)isEqualToPosition:(Position *)position;

- (Position *)positionEast;
- (Position *)positionWest;
/**
 position that is below current point with y - 1
 */
- (Position *)positionSouth;
- (Position *)positionNorth;



@end
