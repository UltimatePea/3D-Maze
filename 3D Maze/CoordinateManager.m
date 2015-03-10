//
//  CoordinateManager.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/24/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "CoordinateManager.h"

@implementation CoordinateManager

- (instancetype)initWithSize:(CGSize)size withGridWidth:(NSInteger)gridWidth withGridHeight:(NSInteger)gridHeight
{
    self = [super init];
    if (self) {
        self.size = size;
        self.gridWidth = gridWidth;
        self.gridHeight = gridHeight;
    }
    return self;
}

+ (instancetype)coordinateManagerWithSize:(CGSize)size withGridWidth:(NSInteger)gridWidth withGridHeight:(NSInteger)gridHeight
{
    return [[self alloc] initWithSize:size withGridWidth:gridWidth withGridHeight:gridHeight];
}


- (CGFloat)horizontalSectionWidth
{
    return self.size.width / self.gridWidth;
}

- (CGFloat)verticalSectionHeight
{
    return self.size.height / self.gridHeight;
    
}

- (CGFloat)absoluteCenterPositionXWithRelativePosition:(CGFloat)xCoordinate withOffset:(CGFloat)offset
{
    return (xCoordinate + .5 + offset) * [self horizontalSectionWidth];
//    - self.size.width / 2;
}

- (CGFloat)absoluteCenterPositionYWithRelativePosition:(CGFloat)yCoordinate withOffset:(CGFloat)offset
{
    return (yCoordinate + .5 + offset) * [self verticalSectionHeight];
//    - self.size.height / 2;
}


- (CGSize)standardNodeSize
{
    return CGSizeMake([self horizontalSectionWidth], [self verticalSectionHeight]);
}

- (CGPoint)absoluteCenterPositionOfNodeOfRelativeCoordinate:(CGPoint)position
{
    return CGPointMake([self absoluteCenterPositionXWithRelativePosition:position.x withOffset:0], [self absoluteCenterPositionYWithRelativePosition:position.y withOffset:0]);
}

- (CGPoint)relatePointWithAbsolutePoint:(CGPoint)absolutePoint
{
    int x = floor(absolutePoint.x/[self horizontalSectionWidth]);
    int y = floor(absolutePoint.y/[self verticalSectionHeight]);
    return CGPointMake(x, y);
}

@end
