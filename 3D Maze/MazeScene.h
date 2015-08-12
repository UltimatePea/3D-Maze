//
//  MazeScene.h
//  3D Maze
//
//  Created by Chen Zhibo on 3/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//


@import SceneKit;
#import "Maze.h"
#import "ViewController.h"

@interface MazeScene : SCNScene <SCNSceneRendererDelegate>

@property (strong, nonatomic) ViewController *presentingVC;
@property (nonatomic) double animationDuration;

- (instancetype)initWithMaze:(Maze *)maze;
+ (instancetype)mazeSceneWithMaze:(Maze *)maze;

- (void)swipedLeft:(id)sender;
- (void)swipedRight:(id)sender;
- (void)tap:(id)sender;
- (void)pinch:(id)sender;
- (void)exit:(id)sender;



@end
