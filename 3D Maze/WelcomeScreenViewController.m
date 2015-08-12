//
//  WelcomeScreenViewController.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "ViewController.h"
#import "ImageViewController.h"

@interface WelcomeScreenViewController ()
@property (weak, nonatomic) IBOutlet UISlider *sliderUp;
@property (weak, nonatomic) IBOutlet UISlider *sliderDown;
@property (weak, nonatomic) IBOutlet UILabel *indicator;
@property (weak, nonatomic) IBOutlet UISwitch *adSwitch;
@property (weak, nonatomic) IBOutlet UISlider *responseSlider;

@end

@implementation WelcomeScreenViewController
- (IBAction)valueChanged:(UISlider *)sender {
    self.indicator.text = [NSString stringWithFormat:@"Maze %d by %d", (int)self.sliderUp.value, (int)self.sliderDown.value];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.indicator.text = [NSString stringWithFormat:@"Maze %d by %d", (int)self.sliderUp.value, (int)self.sliderDown.value];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startGame:(id)sender {
    self.indicator.text = @"Loading, please wait......";
    
    
    dispatch_async(dispatch_queue_create("create maze", NULL), ^{
        ViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"game vc"];
        vc.mazeWidth = (int)self.sliderUp.value;
        vc.mazeHeight = (int)self.sliderDown.value;
        vc.adsEnabled = self.adSwitch.on;
        vc.animationDuration = self.responseSlider.value;
        ImageViewController *ivc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageViewController"];
        ivc.segueingVC = vc;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:ivc animated:YES completion:nil];
        });
    });
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"start game"]) {
        if ([segue.destinationViewController isKindOfClass:[ViewController class]]) {
            
            ViewController *vc = segue.destinationViewController;
            
        }
    }
}


@end
