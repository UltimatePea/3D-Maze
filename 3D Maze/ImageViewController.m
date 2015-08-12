//
//  ImageViewController.m
//  3D Maze Real
//
//  Created by Chen Zhibo on 6/12/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}

- (void)tap:(UITapGestureRecognizer *)recog
{
    UIViewController *ori = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        [ori presentViewController:self.segueingVC animated:YES completion:nil];
    }];
    
}

@end
