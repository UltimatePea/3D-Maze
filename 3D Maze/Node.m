//
//  Node.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "Node.h"
#import "Boarder.h"

@implementation Node

#pragma mark - init and setup

- (instancetype)initWithPosition:(Position *)position withBoarders:(NSMutableArray *)boarders
{
    if (self = [super init]) {
        self.boarders = boarders;
        self.position = position;
    }
    return self;
}

+ (instancetype)nodeWithPosition:(Position *)position withBoarders:(NSMutableArray *)boarders
{
    return [[self alloc] initWithPosition:position withBoarders:boarders];
}

- (instancetype)initWithX:(int)x withY:(int)y
{
    return [self initWithPosition:[[Position alloc] initWithX:x withY:y] withBoarders:nil];
}

+ (instancetype)nodeWithX:(int)x withY:(int)y
{
    return [[self alloc] initWithX:x withY:y];
}

- (instancetype)initWithX:(int)x withY:(int)y withBoardersSurrounded:(BOOL)boardersAreSurrounded
{
    self = [self initWithX:x withY:y];
    if (self&&boardersAreSurrounded) {
        self.boarders = [Boarder boardersSurroundingPosition:self.position];
    }
    return self;
}

+ (instancetype)nodeWithX:(int)x withY:(int)y withBoardersSurrounded:(BOOL)boardersAreSurrounded
{
    return [[self alloc] initWithX:x withY:y withBoardersSurrounded:boardersAreSurrounded];
}

- (void)removeBoarderToNode:(Node *)node
{
    [self.boarders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Boarder *boarder = obj;
        if ([boarder.toPosition isEqualToPosition:node.position]) {
            [self.boarders removeObject:boarder];
        }
    }];
}

- (NSString *)debugDescription
{
    __block NSString *result = [NSString stringWithFormat:@"%@%@",@"NODE", [self.position debugDescription]];
    [self.boarders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = [result stringByAppendingString:[((Boarder *)obj) debugDescription] ];
    }];
    return result;
}

@end
