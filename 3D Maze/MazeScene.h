//
//  MazeScene.h
//  3D Maze
//
//  Created by Chen Zhibo on 3/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//


@import SceneKit;
#import "Maze.h"

@interface MazeScene : SCNScene <SCNSceneRendererDelegate>


- (instancetype)initWithMaze:(Maze *)maze;
+ (instancetype)mazeSceneWithMaze:(Maze *)maze;

- (void)swipedLeft:(id)sender;
- (void)swipedRight:(id)sender;
- (void)tap:(id)sender;
- (void)pinch:(id)sender;

@end
