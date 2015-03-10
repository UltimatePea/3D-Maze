//
//  MazeScene.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "MazeScene.h"
#import "CoordinateManager.h"


@interface MazeScene () <SCNPhysicsContactDelegate>

@property (strong, nonatomic) Maze *maze;
@property (strong, nonatomic) NSMutableArray *walls;
@property (strong, nonatomic) CoordinateManager *coordinateManager;
@property (strong, nonatomic) SCNNode *championNode;
@property (strong, nonatomic) SCNNode *cameraNode;
@property ( nonatomic) int directionOfChampion;
@property (strong, nonatomic) Position *championPosition;

@end

@implementation MazeScene

- (void)setDirectionOfChampion:(int)directionOfChampion
{
    _directionOfChampion = directionOfChampion;
    if (directionOfChampion == 0) {
        _directionOfChampion = 4;
    } else if (directionOfChampion == 5){
        _directionOfChampion = 1;
    }
}

- (NSMutableArray *)walls
{
    if (!_walls) {
        _walls = [NSMutableArray array];
    }
    return _walls;
}

- (instancetype)initWithMaze:(Maze *)maze
{
    if (self = [super init]) {
        self.maze = maze;
        [self setup];
    }
    return self;
}

+ (instancetype)mazeSceneWithMaze:(Maze *)maze
{
    return [[self alloc] initWithMaze:maze];
}

#define SIZE_WIDTH 100
#define SIZE_HEIGHT 100
#define GRAVITY -9.8

- (void)setup
{
    self.coordinateManager = [CoordinateManager coordinateManagerWithSize:CGSizeMake(SIZE_WIDTH, SIZE_HEIGHT) withGridWidth:self.maze.grid.width withGridHeight:self.maze.grid.height];
    
    self.directionOfChampion = 4;
    [self setupBoarders];
    [self setupChampion];
    [self setupCamera];
    [self setupLight];
    [self setupFloor];
    
//    self.physicsWorld.gravity = SCNVector3Make(0, 0, GRAVITY);
//    self.physicsWorld.contactDelegate = self;
    
}
#define NODE_HEIGHT 1.0
#define NODE_WIDTH 0.1

- (void)setupBoarders
{
    [self.maze.grid.nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *node = obj;
        [node.boarders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Boarder *boarder = obj;
            SCNNode *scnNode = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:[self.coordinateManager horizontalSectionWidth] height:NODE_WIDTH length:NODE_HEIGHT chamferRadius:0]];
            scnNode.geometry.firstMaterial.diffuse.contents = @"waiting for ads";
            
            CGFloat horizontalOffSet = 0.0, verticalOffset = 0.0;
            
            int relativeX, relativeY;
            
            relativeX = boarder.fromPosition.xCoordinate;
            relativeY = boarder.fromPosition.yCoordinate;
            
            switch (boarder.direction) {
                case BoarderDirectionEast:
                    horizontalOffSet = 0.5;
                    scnNode.eulerAngles = SCNVector3Make(0, 0, M_PI_2);
                    break;
                case BoarderDirectionSouth:
                    verticalOffset = -0.5;
                    break;
                case BoarderDirectionWest:
                    horizontalOffSet = - 0.5;
                    scnNode.eulerAngles = SCNVector3Make(0, 0, M_PI_2);
                    break;
                case BoarderDirectionNorth:
                    verticalOffset = 0.5;
                    break;
                    
                default:
                    break;
            }
            
            scnNode.position = SCNVector3Make([self.coordinateManager absoluteCenterPositionXWithRelativePosition:relativeX withOffset:horizontalOffSet], [self.coordinateManager absoluteCenterPositionYWithRelativePosition:relativeY withOffset:verticalOffset], 0);
//            scnNode.physicsBody = [SCNPhysicsBody staticBody];
            [self.rootNode addChildNode:scnNode];
            [self.walls addObject:scnNode];
            
            
            
        }];
    }];
}

- (void)setupCamera
{
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(0, - NODE_HEIGHT * 4, NODE_HEIGHT * 4);
    cameraNode.eulerAngles = SCNVector3Make(1, 0, 0);//1,0,0
    self.cameraNode = cameraNode;
    [self.championNode addChildNode:cameraNode];
}

- (void)setupLight
{
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeAmbient;
    [self.rootNode addChildNode:lightNode];
}

- (void)setupFloor
{
    SCNNode *floorNode = [SCNNode node];
    floorNode.geometry = [SCNBox boxWithWidth:SIZE_WIDTH height:SIZE_HEIGHT length:NODE_HEIGHT chamferRadius:0.0];
    floorNode.position = SCNVector3Make(SIZE_WIDTH / 2, SIZE_HEIGHT / 2, - NODE_HEIGHT);
    floorNode.geometry.firstMaterial.diffuse.contents = [UIColor colorWithRed:75.0f/255.0f green:141.0f/255.0f blue:22.0f/255.0f alpha:1.0];
//    floorNode.physicsBody = [SCNPhysicsBody staticBody];
//    floorNode.physicsBody.friction = 0.0;
    //floorNode.eulerAngles = SCNVector3Make(0, M_PI_2, 0);
    [self.rootNode addChildNode:floorNode];
}

- (void)setupChampion
{
    SCNNode *champion = [SCNNode node];
    self.championPosition = [Position positionWithX:self.maze.grid.width-1 withY:self.maze.grid.height-1];
    self.championNode = champion;
    champion.geometry = [SCNSphere sphereWithRadius:NODE_HEIGHT];
    champion.geometry.firstMaterial.diffuse.contents = @"Xcode.png";
    [self updateChampionPosition];
    
    
    
    
    [self.rootNode addChildNode:champion];
//    champion.physicsBody = [SCNPhysicsBody dynamicBody];
//    champion.physicsBody.friction = 0.0;
}
#define ANIMATION_DURATION 0.2
- (void)updateChampionPosition
{
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:ANIMATION_DURATION];
    self.championNode.position = SCNVector3Make([self.coordinateManager absoluteCenterPositionXWithRelativePosition:self.championPosition.xCoordinate withOffset:0], [self.coordinateManager absoluteCenterPositionYWithRelativePosition:self.championPosition.yCoordinate withOffset:0], 0);
    [SCNTransaction commit];
}

- (void)swipedLeft:(id)sender
{
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:ANIMATION_DURATION];
    self.championNode.eulerAngles = SCNVector3Make(0, 0, self.championNode.eulerAngles.z - M_PI_2);
    [SCNTransaction commit];
    self.directionOfChampion++;
}
- (void)swipedRight:(id)sender
{
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:ANIMATION_DURATION];
    self.championNode.eulerAngles = SCNVector3Make(0, 0, self.championNode.eulerAngles.z + M_PI_2);
    [SCNTransaction commit];
    self.directionOfChampion--;
}

- (void)tap:(id)sender
{
//    float x,y;
//    switch (self.directionOfChampion) {
//        case 1:
//            x = [self.coordinateManager horizontalSectionWidth];
//            y = 0;
//            break;
//        case 2:
//            x = 0;
//            y = - [self.coordinateManager verticalSectionHeight];
//            break;
//            
//        case 3:
//            x = - [self.coordinateManager horizontalSectionWidth];
//            y = 0;
//            break;
//        case 4:
//            x = 0;
//            y = [self.coordinateManager verticalSectionHeight];
//            break;
//            
//        default:
//            break;
//    }
    
    //[self.championNode.physicsBody applyForce:SCNVector3Make(x * 100, y * 100, 0) impulse:NO];
    //[self.championNode removeAllActions];
    
    //[self.championNode runAction:[SCNAction moveBy:SCNVector3Make(x,y, 0) duration:0.2]];
    
    if ([self.maze.grid isBoarderPresentFromPosition:self.championPosition withDirection:self.directionOfChampion]) {
        return;
    }
    switch (self.directionOfChampion) {
        case 1:
            
            self.championPosition  = [self.championPosition positionEast];
            break;
        case 2:
            self.championPosition  = [self.championPosition positionSouth];
            break;
            
        case 3:
            self.championPosition  = [self.championPosition positionWest];
            
            break;
        case 4:
            self.championPosition  = [self.championPosition positionNorth];
            break;
            
        default:
            break;
    }
    [self updateChampionPosition];
    
}

//- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact
//{
//    [contact.nodeA.physicsBody clearAllForces];
//    [contact.nodeB.physicsBody clearAllForces];
//    [contact.nodeA removeAllActions];
//    [contact.nodeB removeAllActions];
//}

- (void)renderer:(id<SCNSceneRenderer>)aRenderer didSimulatePhysicsAtTime:(NSTimeInterval)time
{
   // self.championNode.eulerAngles = SCNVector3Make(0, 0, self.championNode.eulerAngles.z);
   // [self.championNode.physicsBody resetTransform];
    NSLog(@"CHAMPION  X:%f,  Y:%f,  Z:%f", self.championNode.position.x, self.championNode.position.y, self.championNode.position.z);
	
}

- (void)pinch:(id)sender
{
    if ([sender isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer *recog = sender;
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:ANIMATION_DURATION];
        if (recog.scale>1) {
            self.cameraNode.eulerAngles = SCNVector3Make(M_PI_2, 0, 0);
            self.cameraNode.position = SCNVector3Zero;
        } else {
            self.cameraNode.position = SCNVector3Make(0, - NODE_HEIGHT * 4, NODE_HEIGHT * 4);
            self.cameraNode.eulerAngles = SCNVector3Make(1, 0, 0);
        }
        [SCNTransaction commit];
    }
}

@end
