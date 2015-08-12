//
//  MazeScene.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "MazeScene.h"
#import "CoordinateManager.h"


@interface MazeScene () <SCNPhysicsContactDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) Maze *maze;
@property (strong, nonatomic) NSMutableArray *walls;
@property (strong, nonatomic) CoordinateManager *coordinateManager;
@property (strong, nonatomic) SCNNode *championNode;
@property (strong, nonatomic) SCNNode *cameraNode;
@property ( nonatomic) int directionOfChampion;
@property (strong, nonatomic) Position *championPosition;
@property (nonatomic) BOOL isZoomedIn;

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
#define SECTION_WIDTH 2.5
#define SECTION_HEIHT 2.5

- (float)sizeWidth{
    return self.maze.grid.width * SECTION_WIDTH;
}

- (float)sizeHeight{
    return self.maze.grid.height * SECTION_HEIHT;
}


#define GRAVITY -9.8

- (void)setup
{
    self.coordinateManager = [CoordinateManager coordinateManagerWithSize:CGSizeMake([self sizeWidth], [self sizeHeight]) withGridWidth:self.maze.grid.width withGridHeight:self.maze.grid.height];
    
    self.directionOfChampion = 4;
    
    [self setupBoarders];
    [self setupChampion];
    [self setupCamera];
    [self setupLight];
    [self setupFloor];
    
//    self.physicsWorld.gravity = SCNVector3Make(0, 0, GRAVITY);
//    self.physicsWorld.contactDelegate = self;
    
}
#define NODE_HEIGHT 2.5
#define NODE_WIDTH 0.1

- (void)setupBoarders
{
    SCNNode *nodePrototype = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:[self.coordinateManager horizontalSectionWidth] height:NODE_WIDTH length:NODE_HEIGHT chamferRadius:0]];
    nodePrototype.geometry.firstMaterial.diffuse.contents = @"william_wall_01_D";
    nodePrototype.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    
    
    [self.maze.grid.nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *node = obj;
        [node.boarders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Boarder *boarder = obj;
            SCNNode *scnNode;
            if ([boarder.fromPosition isEqualToPosition:[Position positionWithX:0 withY:0]]&&(boarder.direction==BoarderDirectionSouth||boarder.direction==BoarderDirectionWest)) {
                scnNode = [SCNNode nodeWithGeometry:[SCNBox boxWithWidth:[self.coordinateManager horizontalSectionWidth] height:NODE_WIDTH length:NODE_HEIGHT*4 chamferRadius:0]];
                scnNode.geometry.firstMaterial.diffuse.contents = @"william_wall_01_D";
                scnNode.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
            } else {
                scnNode = [nodePrototype copy];
            }
            
            
//            float colorConstant = (float)boarder.fromPosition.xCoordinate / (float)self.maze.grid.width * 0.4 + (float)boarder.fromPosition.yCoordinate / (float)self.maze.grid.height * 0.4 + 0.1;
//            NSLog(@"Color constant %f", colorConstant);
//            scnNode.geometry.firstMaterial.ambient.contents = [UIColor colorWithRed:colorConstant green:colorConstant blue:colorConstant alpha:1.0];
            
            
            
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
            [self addWallNode:scnNode];
            
            
            
        }];
    }];
}

- (void)addWallNode:(SCNNode *)scnNode
{
    float accuracy = 0.001;
    [self.walls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SCNNode *node = obj;
        if (
            node.position.x - scnNode.position.x < accuracy&&
            node.position.y - scnNode.position.y < accuracy&&
            node.position.z - scnNode.position.z < accuracy&&
            node.eulerAngles.x - scnNode.eulerAngles.x < accuracy&&
            node.eulerAngles.y - scnNode.eulerAngles.y < accuracy&&
            node.eulerAngles.z - scnNode.eulerAngles.z < accuracy
            ) {
            return;
            
        }
    }];
    
    [self.rootNode addChildNode:scnNode];
    [self.walls addObject:scnNode];
}

- (void)setupCamera
{
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.position = SCNVector3Make(-[self sizeWidth], -[self sizeHeight], [self sizeHeight]);
    cameraNode.camera.zNear = 0.1;
    //cameraNode.camera.xFov = 120;
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    self.cameraNode = cameraNode;
    [self.championNode addChildNode:cameraNode];
#define START_ANIMATION_DURATION 5.0
    
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:START_ANIMATION_DURATION];
    
    self.cameraNode.position = SCNVector3Make(0, - NODE_HEIGHT / 2 , NODE_HEIGHT );
    self.cameraNode.eulerAngles = SCNVector3Make(1, 0, 0);
    
    [SCNTransaction commit];
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
    NSString *texture = [NSString stringWithFormat:@"ground_grass_gen_0%d", arc4random()%10];
    [self.maze.grid.nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *node = obj;
        SCNNode *floorNode = [SCNNode node];
        floorNode.geometry = [SCNBox boxWithWidth:[self.coordinateManager horizontalSectionWidth] height:[self.coordinateManager verticalSectionHeight] length:NODE_HEIGHT chamferRadius:0.0];
        floorNode.position = SCNVector3Make([self.coordinateManager absoluteCenterPositionXWithRelativePosition:node.position.xCoordinate withOffset:0], [self.coordinateManager absoluteCenterPositionYWithRelativePosition:node.position.yCoordinate withOffset:0], - NODE_HEIGHT);
        floorNode.geometry.firstMaterial.diffuse.contents = texture;
        floorNode.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
        //[UIColor colorWithRed:75.0f/255.0f green:141.0f/255.0f blue:22.0f/255.0f alpha:1.0];
        //    floorNode.physicsBody = [SCNPhysicsBody staticBody];
        //    floorNode.physicsBody.friction = 0.0;
        //floorNode.eulerAngles = SCNVector3Make(0, M_PI_2, 0);
        [self.rootNode addChildNode:floorNode];
        
//        SCNNode *nodeLight = [SCNNode node];
//        nodeLight.light = [SCNLight light];
//        nodeLight.light.type = SCNLightTypeOmni;
//        nodeLight.position = SCNVector3Make(0, 0, NODE_HEIGHT / 2);
//        [floorNode addChildNode:nodeLight];
    }];
}

- (void)setupChampion
{
    SCNNode *champion = [SCNNode node];
    self.championPosition = [Position positionWithX:self.maze.grid.width-1 withY:self.maze.grid.height-1];
    self.championNode = champion;
    champion.geometry = [SCNSphere sphereWithRadius:NODE_WIDTH];
    champion.geometry.firstMaterial.diffuse.contents = @"ground_grass_gen_01";
    [self updateChampionPosition];
    
    
    
    
    [self.rootNode addChildNode:champion];
//    champion.physicsBody = [SCNPhysicsBody dynamicBody];
//    champion.physicsBody.friction = 0.0;
}

- (void)updateChampionPosition
{
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:self.animationDuration];
    self.championNode.position = SCNVector3Make([self.coordinateManager absoluteCenterPositionXWithRelativePosition:self.championPosition.xCoordinate withOffset:0], [self.coordinateManager absoluteCenterPositionYWithRelativePosition:self.championPosition.yCoordinate withOffset:0], 0);
    [SCNTransaction commit];
}

- (void)swipedLeft:(id)sender
{
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:self.animationDuration];
    self.championNode.eulerAngles = SCNVector3Make(0, 0, self.championNode.eulerAngles.z - M_PI_2);
    [SCNTransaction commit];
    self.directionOfChampion++;
}
- (void)swipedRight:(id)sender
{
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:self.animationDuration];
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
    
    if (!self.isZoomedIn) {
        [self.presentingVC remindUser:@"Please zoom in to move" withDuration:2];
        return;
    }
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
    if ([self.championPosition isEqualToPosition:[Position positionWithX:0 withY:0]]) {
#define ALERT_TITLE_VICTORY @"SUCCESS"
#define OK @"OK"
#define ALERT_TITLE_EXIT @"Exit"
        [[[UIAlertView alloc] initWithTitle:ALERT_TITLE_VICTORY message:[NSString stringWithFormat:@"You have successfully passed a %d by %d maze. Congratulations!!!", self.maze.grid.width, self.maze.grid.height] delegate:self cancelButtonTitle:nil otherButtonTitles:OK, nil] show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:ALERT_TITLE_VICTORY]&&[[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
        [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
    }
    if ([alertView.title isEqualToString:ALERT_TITLE_EXIT]&&[[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
        [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
        //[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
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
    //NSLog(@"CHAMPION  X:%f,  Y:%f,  Z:%f", self.championNode.position.x, self.championNode.position.y, self.championNode.position.z);
	
}

- (void)pinch:(id)sender
{
    if ([sender isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer *recog = sender;
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:self.animationDuration];
        if (recog.scale>1) {
            self.isZoomedIn = YES;
            self.cameraNode.eulerAngles = SCNVector3Make(M_PI_2, 0, 0);
            self.cameraNode.position = SCNVector3Make(0, 0, NODE_HEIGHT / 4);
            self.cameraNode.camera.zFar = NODE_HEIGHT * 10;
            [self.presentingVC resetADPosition:ZoomedIn];
        } else {
            self.isZoomedIn = NO;
            self.cameraNode.position = SCNVector3Make(0, - NODE_HEIGHT / 2 , NODE_HEIGHT );
            self.cameraNode.eulerAngles = SCNVector3Make(1, 0, 0);
            self.cameraNode.camera.automaticallyAdjustsZRange = YES;
            [self.presentingVC resetADPosition:ZoomedOut];
        }
        [SCNTransaction commit];
    }
}

- (void)exit:(UILongPressGestureRecognizer *)sender
{
    [self saveScene];
    if (sender.state != UIGestureRecognizerStateBegan) {
        return;
    }
    [[[UIAlertView alloc] initWithTitle:ALERT_TITLE_EXIT message:[NSString stringWithFormat:@"Are you sure to exit?"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:OK, nil] show];
}

- (void)saveScene
{
    NSURL *path = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *url = [path URLByAppendingPathComponent:@"Scene.dae"];
    if ([[NSFileManager defaultManager] createFileAtPath:[url path] contents:[NSKeyedArchiver archivedDataWithRootObject:self] attributes:nil]) {
        NSLog(@"Saved successful");
    }
}

@end
