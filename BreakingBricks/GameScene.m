//
//  GameScene.m
//  BreakingBricks
//
//  Created by Fernando Rocha on 8/4/15.
//  Copyright (c) 2015 Fernando Rocha. All rights reserved.
//

#import "GameScene.h"


@interface GameScene ()

@property (nonatomic) SKSpriteNode *paddle;
@property (nonatomic) SKAction     *brickSFX;
@property (nonatomic) SKAction     *paddleSFX;

@end

static const uint32_t ballCategory   = 1; // 00000000000000000000000000000001
static const uint32_t brickCategory  = 2; // 00000000000000000000000000000010
static const uint32_t paddleCategory = 4; // 00000000000000000000000000000100
static const uint32_t edgeCategory   = 8; // 00000000000000000000000000001000
static const uint32_t bottomEdgeCategory   = 16; // 00000000000000000000000000010000

@implementation GameScene

-(void) addBottomEdge {
    SKNode *bottomEdge = [SKNode node];
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(self.frame.size.width, 1)];
    bottomEdge.physicsBody.categoryBitMask = bottomEdgeCategory;
    [self addChild:bottomEdge];
    
}

- (void)addBall {
    // create a new sprite node from an image
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    // create a CGPoint for position
    CGPoint myPoint = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
    ball.position = myPoint;
    
    // add a physics body
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.friction = 0;
    ball.physicsBody.linearDamping = 0;
    ball.physicsBody.restitution = 1.0f;
    ball.physicsBody.categoryBitMask = ballCategory;
    
    //add notification for when it contacts bricks
    ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | bottomEdgeCategory;
    
    // add the sprite node to the scene
    [self addChild:ball];
    
    // create the vector
    CGVector myVector = CGVectorMake(10, 10);
    // apply the vector
    [ball.physicsBody applyImpulse:myVector];
}

- (void)addPlayer {
    //create paddle node
    self.paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    //position it
    self.paddle.position = CGPointMake(self.frame.size.width/2, 100);
    //add a physics body
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    //make it static
    self.paddle.physicsBody.dynamic = NO;
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
    
    [self addChild:self.paddle];
}

- (void)addBricks{
    for (int i = 0; i < 4; i++){
        SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        
        //add static physics to the body
        brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
        brick.physicsBody.dynamic = NO;
        brick.physicsBody.categoryBitMask = brickCategory;
        
        int xPos = self.frame.size.width/5 * (i+1);
        int yPos = self.frame.size.height - 50;
        brick.position = CGPointMake(xPos, yPos);
        
        [self addChild:brick];
    }
}

#pragma mark SKSceneContactDelegate

-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *notTheBall;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        notTheBall = contact.bodyB;
    }else{
        notTheBall = contact.bodyA;
    }
    
    if (notTheBall.categoryBitMask == brickCategory){
        [self runAction:self.brickSFX];
        [notTheBall.node removeFromParent];
    }else if (notTheBall.categoryBitMask == paddleCategory){
        [self runAction:self.paddleSFX];
    }else if (notTheBall.categoryBitMask == bottomEdgeCategory) {
        EndScene * scene = [EndScene sceneWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.view presentScene:scene transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
    }}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.backgroundColor = [SKColor whiteColor];
    
    // add a physics body to the scene
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = edgeCategory;
    
    // change gravity settings of the physics world
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    [self addBall];
    [self addPlayer];
    [self addBricks];
    [self addBottomEdge];
    
    //create SFX
    self.brickSFX = [SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
    self.paddleSFX = [SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInNode:self];
        CGPoint newPosition = CGPointMake(location.x , 100);
        
        if (newPosition.x < self.paddle.frame.size.width / 2){
            newPosition.x = self.paddle.frame.size.width / 2;
        }else if (newPosition.x > self.frame.size.width - (self.paddle.frame.size.width / 2)){
            newPosition.x = self.frame.size.width - (self.paddle.frame.size.width / 2);
        }
        
        self.paddle.position = newPosition;
        
    }
}
@end
