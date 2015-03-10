//
//  Node.h
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Position.h"
#import "Boarder.h"

@interface Node : NSObject

@property (strong, nonatomic) Position *position;
@property (strong, nonatomic) NSMutableArray *boarders;

- (instancetype)initWithPosition:(Position *)position withBoarders:(NSMutableArray *)boarders;
+ (instancetype)nodeWithPosition:(Position *)position withBoarders:(NSMutableArray *)boarders;;
- (instancetype)initWithX:(int)x withY:(int)y;
+ (instancetype)nodeWithX:(int)x withY:(int)y;
- (instancetype)initWithX:(int)x withY:(int)y withBoardersSurrounded:(BOOL)boardersAreSurrounded;
+ (instancetype)nodeWithX:(int)x withY:(int)y withBoardersSurrounded:(BOOL)boardersAreSurrounded;

- (void)removeBoarderToNode:(Node *)node;

@end
