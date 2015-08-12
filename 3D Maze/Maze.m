//
//  Maze.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "Maze.h"


@interface Maze ()


@property (strong, nonatomic) NSMutableDictionary *isWent;
@property (strong, nonatomic) Node *exitNode, *startNode;
@property (strong, nonatomic) NSMutableArray *routeNodes;

@end

@implementation Maze


- (NSMutableDictionary *)isWent
{
    if (!_isWent) {
        _isWent = [NSMutableDictionary dictionary];
    }
    return _isWent;
}

- (NSMutableArray *)routeNodes
{
    if (!_routeNodes) {
        _routeNodes = [NSMutableArray array];
    }
    return _routeNodes;
}


- (instancetype)initWithWidth:(int)width height:(int)height
{
    if (self = [super init]) {
        self.grid = [NodeGrid gridWithWidth:width withHeight:height];
        [self executeMazeGenerationAlgorithmWithNumber:1];
        
    }
    return self;
}

+ (instancetype)mazeWithWidth:(int)width height:(int)height
{
    return [[self alloc] initWithWidth:width height:height];
}

- (void)executeMazeGenerationAlgorithmWithNumber:(int)number
{
    for (int i = 0; i < self.grid.width; i++) {
        for (int j = 0; j < self.grid.height; j ++) {
            [self.isWent setObject:@NO forKey:[NSString stringWithFormat:@"%d||%d", i, j]];
        }
    }
    //let exit be 0,0;
    self.exitNode = [self.grid nodeAtX:self.grid.width/2 nodeAtY:self.grid.height/2];
    [self executeAlgorithmOnNode:self.exitNode];
    
}

- (void)executeAlgorithmOnNode:(Node *)node
{
    [self wentToNode:node];
    
    
    
    
    //going onto the next node
    [self.routeNodes addObject:node];
    NSArray *siblings = [self.grid getSiblingForNode:node];
    if ([self isNodesAllWent:siblings]) {
        [self.routeNodes removeObject:node];
        if ([self.routeNodes count]!=0) {
            [self executeAlgorithmOnNode:[self.routeNodes lastObject]];
        }
        
    } else {
        Node *nextNode;
        BOOL continueIteration = YES;
        while(continueIteration){
            nextNode = [siblings objectAtIndex:arc4random()%[siblings count]];
            if (![self isNodeWent:nextNode]) {
                continueIteration = NO;
            }
        }
        [self removeBoardersBetweenNode:node andNode:nextNode];
        [self executeAlgorithmOnNode:nextNode];
    }
    
}

- (void)removeBoardersBetweenNode:(Node *)nodeA andNode:(Node *)nodeB
{
    [nodeA removeBoarderToNode:nodeB];
    [nodeB removeBoarderToNode:nodeA];
}

- (BOOL)isNodesAllWent:(NSArray *)nodes
{
    __block BOOL result = YES;
    [nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *node = obj;
        if (![self isNodeWent:node]) {
            result = NO;
            //NSLog(@"isnodewent%d", [self isNodeWent:node]);
        }
    }];
    return result;
}

- (BOOL)isNodeWent:(Node *)node
{
    return  [[self.isWent objectForKey:[NSString stringWithFormat:@"%d||%d", node.position.xCoordinate, node.position.yCoordinate]] boolValue];
}

- (void)wentToNode:(Node *)node
{
    [self.isWent setObject:@YES forKey:[NSString stringWithFormat:@"%d||%d", node.position.xCoordinate, node.position.yCoordinate]];
}

@end
