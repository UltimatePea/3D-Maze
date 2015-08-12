//
//  ViewController.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "ViewController.h"
#import "MazeScene.h"
#import "UserPanelScene.h"
@import iAd;

@interface ViewController () <ADBannerViewDelegate>

@property (strong, nonatomic) UserPanelScene *skScene;
@property (strong, nonatomic) ADBannerView *adBanner;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Maze *maze = [Maze mazeWithWidth:self.mazeWidth height:self.mazeHeight];
//    SCNView *view = [[SCNView alloc] initWithFrame:self.view.frame];
    SCNView * view = (SCNView *)self.view;
    view.backgroundColor = [UIColor colorWithRed:149.0f/255.0f green:189.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    //view.allowsCameraControl = YES;
    self.view = view;
    MazeScene *scene = [MazeScene mazeSceneWithMaze:maze];
    scene.animationDuration = self.animationDuration;
    view.scene = scene;
    view.delegate = scene;
    //view.showsStatistics = YES;
    scene.presentingVC = self;
    UserPanelScene *userPanel = [UserPanelScene sceneWithSize:self.view.frame.size];
    view.overlaySKScene = userPanel;
    userPanel.Scene3d = scene;
    self.skScene = userPanel;
    
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
    
    UILongPressGestureRecognizer *se = [[UILongPressGestureRecognizer alloc] initWithTarget:scene action:@selector(exit:)];
    [self.view addGestureRecognizer:se];
    if(self.adsEnabled){
        [self setupAd];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)remindUser:(NSString *)remind withDuration:(NSTimeInterval)duration
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
    label.text = remind;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:48];
    [self.view addSubview:label];
    label.textColor = [UIColor whiteColor];
    
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:duration] interval:0 target:self selector:@selector(removeReminder:) userInfo:label repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
}

- (void)removeReminder:(NSTimer *)timer{
    UILabel *label = timer.userInfo;
    [label removeFromSuperview];
}

- (void)setupAd
{
    ADBannerView *banner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    banner.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - banner.bounds.size.height / 2);
    banner.delegate = self;
    banner.hidden = YES;
    self.adBanner = banner;
    [super.view addSubview:banner];
}

- (void)resetADPosition:(Zoom)zoom
{
    switch (zoom) {
        case ZoomedIn:
            self.adBanner.center = CGPointMake(self.view.bounds.size.width / 2, /*self.view.bounds.size.height - */self.adBanner.bounds.size.height / 2);
            break;
            case ZoomedOut:
            self.adBanner.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - self.adBanner.bounds.size.height / 2);
        default:
            break;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    banner.hidden = NO;
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"ADError");
    
}



@end
