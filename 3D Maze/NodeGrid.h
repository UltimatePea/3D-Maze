//
//  NodeGrid.h
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface NodeGrid : NSObject

@property (nonatomic) int width, height;

@property (strong, nonatomic) NSMutableArray *nodes;

- (instancetype)initWithWidth:(int)width withHeight:(int)height;
+ (instancetype)gridWithWidth:(int)width withHeight:(int)height;
- (Node *)nodeAtPosition:(Position *)position;
- (Node *)nodeAtX:(int)x nodeAtY:(int)y;
- (NSArray *)getSiblingForNode:(Node *)node;

+ (instancetype)sharedGrid;

- (BOOL)isBoarderPresentFromPosition:(Position *)pos withDirection:(BoarderDirection)direction;

@end
