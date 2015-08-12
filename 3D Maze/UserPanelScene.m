//
//  UserPanelScene.m
//  3D Maze
//
//  Created by Chen Zhibo on 3/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "UserPanelScene.h"
#import "HelpIcon.h"

@interface UserPanelScene ()

@property (strong, nonatomic) SKSpriteNode *overViewLoadIcon;

@end

@implementation UserPanelScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
//        [self setup];
    }
    return self;
}

- (void)setup
{
    self.overViewLoadIcon  = [HelpIcon spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"eye"] size:CGSizeMake(30, 30)];
    self.overViewLoadIcon.userInteractionEnabled = YES;
    self.overViewLoadIcon.position = CGPointMake(self.size.width, self.size.height);
    self.overViewLoadIcon.anchorPoint = CGPointMake(1, 1);
    [self addChild:self.overViewLoadIcon];
}



@end
