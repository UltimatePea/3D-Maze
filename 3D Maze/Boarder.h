//
//  Boarder.h
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Position.h"

typedef enum : NSUInteger {
    BoarderDirectionEast = 1,
    BoarderDirectionSouth = 2,
    BoarderDirectionWest = 3,
    BoarderDirectionNorth = 4
} BoarderDirection;

@interface Boarder : NSObject

@property (strong, nonatomic) Position *fromPosition, *toPosition;
@property (nonatomic) BoarderDirection direction;

- (instancetype)initWithFormPosition:(Position *)fromPosition toPosition:(Position *)toPosition direction:(BoarderDirection)direction;
- (instancetype)initWithFormPosition:(Position *)fromPosition direction:(BoarderDirection)direction;
- (instancetype)initWithFormPosition:(Position *)fromPosition toPosition:(Position *)toPosition;
- (instancetype)initWithToPosition:(Position *)toPosition direction:(BoarderDirection)direction;
+ (NSMutableArray *)boardersSurroundingPosition:(Position *)position;

@end
