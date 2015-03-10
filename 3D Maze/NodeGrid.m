//
//  NodeGrid.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "NodeGrid.h"

@interface NodeGrid ()



@end

@implementation NodeGrid

#pragma mark - lazy instantiation

- (NSMutableArray *)nodes
{
    if (!_nodes) {
        _nodes = [NSMutableArray array];
    }
    return _nodes;
}

#pragma mark - init and setup

- (instancetype)initWithWidth:(int)width withHeight:(int)height
{
    if (self = [super init]) {
        self.width = width;
        self.height = height;
        for (int i = 0; i < width; i ++ ) {
            for (int j = 0; j < height; j ++ ) {
                Node *node = [Node nodeWithX:i withY:j withBoardersSurrounded:YES];
                [self.nodes addObject:node];
            }
        }
    }
    return self;
}

+ (instancetype)gridWithWidth:(int)width withHeight:(int)height
{
    return [[self alloc] initWithWidth:width withHeight:height];
}

#pragma mark - data source

- (Node *)nodeAtPosition:(Position *)position
{
    __block Node *result;
    [self.nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *node = obj;
        if ([node.position isEqualToPosition:position]) {
            result = node;
        }
    }];
    return result;
}

- (Node *)nodeAtX:(int)x nodeAtY:(int)y
{
    return [self nodeAtPosition:[Position positionWithX:x withY:y]];
}

- (NSArray *)getSiblingForNode:(Node *)node
{
    __block NSMutableArray *result = [NSMutableArray array];
    [node.boarders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Boarder *boarder = obj;
        Node *resultNode = [self nodeAtPosition:boarder.toPosition];
        if (resultNode) {
            [result addObject:resultNode];
        }
    }];
    return result;
   // Node *result1 = [self nodeAtPosition:[node.position positionEast]];
}


+ (instancetype)sharedGrid
{
    static NodeGrid *sharedGrid;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGrid = [[self alloc] init];
    });
    return sharedGrid;
}

- (BOOL)isBoarderPresentFromPosition:(Position *)pos withDirection:(BoarderDirection)direction
{
    __block BOOL result = NO;
    [self.nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *node = obj;
        [node.boarders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Boarder *boarder = obj;
            if ([boarder.fromPosition isEqualToPosition:pos]&&boarder.direction == direction) {
                result = YES;
            }
        }];
    }];
    return result;
}

@end
