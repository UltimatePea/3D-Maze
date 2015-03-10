//
//  ViewController.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "ViewController.h"
#import "MazeScene.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Maze *maze = [Maze mazeWithWidth:40 height:40];
    SCNView *view = [[SCNView alloc] initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor grayColor];
    //view.allowsCameraControl = YES;
    self.view = view;
    MazeScene *scene = [MazeScene mazeSceneWithMaze:maze];
    view.scene = scene;
    view.delegate = scene;
    view.showsStatistics = YES;
    
    UISwipeGestureRecognizer *recogLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:scene action:@selector(swipedLeft:)];
    recogLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recogLeft];
    
    UISwipeGestureRecognizer *recogRight = [[UISwipeGestureRecognizer alloc] initWithTarget:scene action:@selector(swipedRight:)];
    recogRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recogRight];
    
    UITapGestureRecognizer *recogTap = [[UITapGestureRecognizer alloc] initWithTarget:scene action:@selector(tap:)];
    [self.view addGestureRecognizer:recogTap];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:scene action:@selector(pinch:)];
    [self.view addGestureRecognizer:pinch];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
