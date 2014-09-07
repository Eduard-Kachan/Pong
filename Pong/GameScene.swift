//
//  GameScene.swift
//  Pong
//
//  Created by Edaurd Kachan on 2014-08-29.
//  Copyright (c) 2014 Eduard Kachan. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let playBtn = SKSpriteNode(imageNamed: "play")
    let ball = SKSpriteNode(imageNamed: "ball")
    let paddle = SKSpriteNode(imageNamed: "paddle")
    let paddle2 = SKSpriteNode(imageNamed: "paddle")
    let scoreText = SKLabelNode()
    let top = SKNode()
    let bottom = SKNode()
    
    var lastPosition = CGPoint()
    
    var gameRunning = false
    
    var score = 0
    
    enum ColliderType:UInt32{
        case ball = 0
        case wall = 1
        case paddle = 2
    }
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        
        backgroundColor = UIColor(hex: 0x000000)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody = borderBody
        physicsBody.friction = 0
        
        addChild(scoreText)
        
        scoreText.fontColor = UIColor(hex: 0xFFFFFF)
        scoreText.fontSize = 170
        scoreText.position = CGPointMake(size.width/2, size.height/2 - 60)
        scoreText.text = toString(score)
        scoreText.alpha = 0.3
        
        addChild(ball)
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody.friction = 0
        ball.physicsBody.restitution = 1
        ball.physicsBody.linearDamping = 0
        ball.physicsBody.allowsRotation = false
        ball.alpha = 0
        
        addChild(paddle)
        paddle.name = "Paddle"
        paddle.position = CGPointMake(size.width/2, CGRectGetMinX(frame))
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.size)
        paddle.physicsBody.restitution = 0
        paddle.physicsBody.friction = 0
        paddle.physicsBody.dynamic = false
        
        paddle.addChild(paddle2)
        paddle2.name = "Paddle"
        paddle2.position = CGPointMake(0, CGRectGetMaxY(frame))
        paddle2.physicsBody = SKPhysicsBody(rectangleOfSize: paddle2.size)
        paddle2.physicsBody.restitution = 0
        paddle2.physicsBody.friction = 0
        paddle2.physicsBody.dynamic = false
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0.2)
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let topRect = CGRectMake(frame.origin.x, frame.size.height, frame.size.width, -0.2)
        top.physicsBody = SKPhysicsBody(edgeLoopFromRect: topRect)
        addChild(top)
        
        playBtn.position = CGPointMake(size.width/2, size.height/2)
        addChild(playBtn)
        
        ball.physicsBody.categoryBitMask = ColliderType.ball.toRaw()
        paddle.physicsBody.categoryBitMask = ColliderType.paddle.toRaw()
        paddle2.physicsBody.categoryBitMask = ColliderType.paddle.toRaw()
        top.physicsBody.categoryBitMask = ColliderType.wall.toRaw()
        bottom.physicsBody.categoryBitMask = ColliderType.wall.toRaw()
        
        ball.physicsBody.contactTestBitMask = ColliderType.paddle.toRaw() | ColliderType.wall.toRaw()
        
    }
    
    func didBeginContact (contact:SKPhysicsContact){
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if secondBody.categoryBitMask == ColliderType.paddle.toRaw(){
            
            var dx = ball.physicsBody.velocity.dx
            var dy = ball.physicsBody.velocity.dy
            
            if dx > 0 {
                dx+=20
            }else{
                dx-=20
            }
            
            if dy > 0{
                dy+=20
            }else{
                dy-=20
            }
            
            ball.physicsBody.velocity = CGVectorMake(dx, dy)
            
            if gameRunning{
             scoreText.text = toString(++score)
            }
            
        }
        
        if secondBody.categoryBitMask == ColliderType.wall.toRaw(){
            if gameRunning  {
                lastPosition = ball.position
            }
            gameRunning = false
            ball.physicsBody.velocity = CGVectorMake(0,0)
            ball.position = lastPosition
            
            playBtn.hidden = false
        }
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if nodeAtPoint(location) == playBtn{
                playBtn.hidden = true
                ball.alpha = 1
                ball.position = CGPointMake(size.width/2, size.height/2)
                ball.physicsBody.applyImpulse(CGVectorMake(1, -1))
                score = 0
                scoreText.text = toString(score)
                gameRunning = true
                
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            var paddleX = location.x
            
            if paddleX < paddle.size.width/2{
                paddleX = paddle.size.width/2
            }else if paddleX > size.width - paddle.size.width/2{
                paddleX = size.width - paddle.size.width/2
            }
            
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    
    
   
    override func update(currentTime: CFTimeInterval) {

    }
}
