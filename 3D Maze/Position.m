//
//  Position.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "Position.h"

@implementation Position

- (instancetype)initWithX:(int)x withY:(int)y
{
    if (self = [super init]) {
        self.xCoordinate = x;
        self.yCoordinate = y;
    }
    return self;
}

+ (instancetype)positionWithX:(int)x withY:(int)y
{
    return [[self alloc] initWithX:x withY:y];
}

- (BOOL)isEqualToPosition:(Position *)position
{
    if (self.xCoordinate == position.xCoordinate && self.yCoordinate == position.yCoordinate) {
        return YES;
    } else {
        return NO;
    }
    
}

- (BOOL)isEqual:(id)object
{
    return [object isKindOfClass:[Position class]]?[self isEqualToPosition:object]:[super isEqual:object];
}

#pragma mark - position transform

- (Position *)positionEast
{
    return [Position positionWithX:self.xCoordinate+1 withY:self.yCoordinate];
}


- (Position *)positionWest
{
    return [Position positionWithX:self.xCoordinate-1 withY:self.yCoordinate];
}

- (Position *)positionSouth
{
    return [Position positionWithX:self.xCoordinate withY:self.yCoordinate-1];
}

- (Position *)positionNorth
{
    return [Position positionWithX:self.xCoordinate withY:self.yCoordinate+1];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@ Position X:%d   Y:%d", @"POSITION" , self.xCoordinate, self.yCoordinate];
}

@end
