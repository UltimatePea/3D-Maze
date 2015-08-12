//
//  HelpIcon.m
//  3D Maze Real
//
//  Created by Chen Zhibo on 6/12/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "HelpIcon.h"

@interface HelpIcon ()

//@property (nonatomic, getter=isOn) BOOL on;
@property (strong, nonatomic) SKSpriteNode *spNode;

@end

@implementation HelpIcon

- (SKSpriteNode *)spNode
{
    if (!_spNode) {
        _spNode = [SKSpriteNode spriteNodeWithImageNamed:@"tutor"];
        _spNode.size = CGSizeMake(self.scene.size.width, self.scene.size.height);
        _spNode.position = CGPointZero;
        _spNode.anchorPoint = CGPointZero;
    }
    return _spNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.spNode.parent == nil) {
        [self.scene addChild:self.spNode];
    } else {
        [self.spNode removeFromParent];
    }
}




@end
