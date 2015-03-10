//
//  Boarder.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "Boarder.h"


@implementation Boarder

- (instancetype)initWithFormPosition:(Position *)fromPosition toPosition:(Position *)toPosition direction:(BoarderDirection)direction
{
    if (self = [super init]) {
        self.fromPosition = fromPosition;
        self.toPosition = toPosition;
        self.direction = direction;
    }
    return self;
}
- (instancetype)initWithFormPosition:(Position *)fromPosition direction:(BoarderDirection)direction
{
    int x = fromPosition.xCoordinate, y = fromPosition.yCoordinate;
    switch (direction) {
        case BoarderDirectionEast:
            x++;
            break;
        case BoarderDirectionSouth:
            y--;
            break;
        case BoarderDirectionWest:
            x--;
            break;
        case BoarderDirectionNorth:
            y++;
            break;
            
        default:
            break;
    }
    Position *toPosition = [Position positionWithX:x withY:y];
    
    
    return [self initWithFormPosition:fromPosition toPosition:toPosition direction:direction];
}

- (instancetype)initWithToPosition:(Position *)toPosition direction:(BoarderDirection)direction
{
    int x=toPosition.xCoordinate, y=toPosition.yCoordinate;
    switch (direction) {
        case BoarderDirectionEast:
            x--;
            break;
        case BoarderDirectionSouth:
            y++;
            break;
        case BoarderDirectionWest:
            x++;
            break;
        case BoarderDirectionNorth:
            y--;
            break;
            
        default:
            break;
    }
    
    Position *fromPosition = [Position positionWithX:x withY:y];
    
    return [self initWithFormPosition:fromPosition toPosition:toPosition direction:direction];
    
}

- (instancetype)initWithFormPosition:(Position *)fromPosition toPosition:(Position *)toPosition
{
    BoarderDirection direction;
    if (fromPosition.xCoordinate > toPosition.xCoordinate) {
        direction = BoarderDirectionWest;
    } else if (fromPosition.xCoordinate < toPosition.xCoordinate) {
        direction = BoarderDirectionEast;
    } else if (fromPosition.yCoordinate > toPosition.yCoordinate){
        direction = BoarderDirectionSouth;
    } else if (fromPosition.yCoordinate < toPosition.yCoordinate){
        direction = BoarderDirectionNorth;
    }
    return [self initWithFormPosition:fromPosition toPosition:toPosition direction:direction];
}

+ (NSMutableArray *)boardersSurroundingPosition:(Position *)position
{
    return [NSMutableArray arrayWithObjects:
            [[Boarder alloc] initWithFormPosition:position direction:BoarderDirectionEast],
            [[Boarder alloc] initWithFormPosition:position direction:BoarderDirectionSouth],
            [[Boarder alloc] initWithFormPosition:position direction:BoarderDirectionWest],
            [[Boarder alloc] initWithFormPosition:position direction:BoarderDirectionNorth]
            , nil];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@ from:%@ to:%@", @"BOARDER", [self.fromPosition debugDescription], [self.toPosition debugDescription]];
}


@end
