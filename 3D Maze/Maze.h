//
//  Maze.h
//  3D Maze
//
//  Created by Chen Zhibo on 3/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//


#import "NodeGrid.h"

@interface Maze : NSObject

@property (strong, nonatomic) NodeGrid *grid;

- (instancetype)initWithWidth:(int)width height:(int)height;
+ (instancetype)mazeWithWidth:(int)width height:(int)height;

@end
