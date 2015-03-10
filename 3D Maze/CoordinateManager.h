//
//  CoordinateManager.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/24/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

/**
This class is for converting coordinates, esp. between SKScene and The Relative grid coordinate
 */
@interface CoordinateManager : NSObject

/**
 Init method
 @param size The size of the SKScene
 @param gridWidth the width the relative coordinate
 @param gridHeight the height of the virtual grid
*/
- (instancetype)initWithSize:(CGSize)size withGridWidth:(NSInteger)gridWidth withGridHeight:(NSInteger)gridHeight;
/**
 Init method
 @param size The size of the SKScene
 @param gridWidth the width the relative coordinate
 @param gridHeight the height of the virtual grid
 */
+ (instancetype)coordinateManagerWithSize:(CGSize)size withGridWidth:(NSInteger)gridWidth withGridHeight:(NSInteger)gridHeight;

@property (nonatomic) NSInteger gridWidth, gridHeight;
@property (nonatomic) CGSize size;

/**
 the width per box
 */
- (CGFloat)horizontalSectionWidth;

/**
 the height per box
 */
- (CGFloat)verticalSectionHeight;

/**
 the scene position(x) with grid x coordinate
 @param position xCoordinate of the virtual grid
 @param offset the plus or minus of the xCoordinate
 */
- (CGFloat)absoluteCenterPositionXWithRelativePosition:(CGFloat)xCoordinate withOffset:(CGFloat)offset;

/**
 the scene position(y) with grid y coordinate
 @param position yCoordinate of the virtual grid
 @param offset the plus or minus of the xCoordinate
 */
- (CGFloat)absoluteCenterPositionYWithRelativePosition:(CGFloat)yCoordinate withOffset:(CGFloat)offset;

/**
 the standard node size of a box in the virtual grid
 */
- (CGSize)standardNodeSize;

/**
 the scene position with given virtual grid position
 */
- (CGPoint)absoluteCenterPositionOfNodeOfRelativeCoordinate:(CGPoint)position;

/**
 The relative coordinate to the absolute point
 */
- (CGPoint)relatePointWithAbsolutePoint:(CGPoint)absolutePoint;


@end
