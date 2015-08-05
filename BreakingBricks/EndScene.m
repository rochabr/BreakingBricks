//
//  EndScene.m
//  BreakingBricks
//
//  Created by Simon Allardice on 2/19/14.
//  Copyright (c) 2014 Simon Allardice. All rights reserved.
//

#import "EndScene.h"

@implementation EndScene

-(void)didMoveToView:(SKView *)view {
    
    SKAction *playSFX = [SKAction playSoundFileNamed:@"gameover.caf" waitForCompletion:NO];
    [self runAction:playSFX];
    
    self.backgroundColor = [SKColor blackColor];
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    label.text = @"GAME OVER";
    label.fontColor = [SKColor whiteColor];
    label.fontSize = 44;
    label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:label];
    
    SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    tryAgain.text = @"tap the screen to try again";
    tryAgain.fontColor = [SKColor whiteColor];
    tryAgain.fontSize = 24;
    tryAgain.position = CGPointMake(CGRectGetMidX(self.frame), -50);
    
    SKAction *moveLabel = [SKAction moveToY:CGRectGetMidY(self.frame) - 40 duration:2.0];
    [tryAgain runAction:moveLabel];
    
    [self addChild:tryAgain];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    GameScene *scene = [GameScene sceneWithSize:self.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];
}

@end
