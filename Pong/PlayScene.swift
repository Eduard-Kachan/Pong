//
//  PlayScene.swift
//  Pong
//
//  Created by Edaurd Kachan on 2014-08-31.
//  Copyright (c) 2014 Eduard Kachan. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene {
    let ball = SKSpriteNode(imageNamed: "ball")
    let player = SKSpriteNode(imageNamed: "paddle")
    let player2 = SKSpriteNode(imageNamed: "paddle")
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(hex: 0x000000)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        let borderBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody = borderBody
        physicsBody.friction = 0
        
        addChild(ball)
        ball.name = "ball"
        ball.position = CGPointMake(size.width/2, size.height/2)
//        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody = SKPhysicsBody(rectangleOfSize: ball.size)
        ball.physicsBody.friction = 0
        ball.physicsBody.restitution = 1
        ball.physicsBody.linearDamping = 0
        ball.physicsBody.allowsRotation = false
        ball.physicsBody.applyImpulse(CGVectorMake(1, -1))
        
        addChild(player)
        player.name = "Paddle"
        player.position = CGPointMake(size.width/2, CGRectGetMinX(frame))
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody.restitution = 0.1
        player.physicsBody.friction = 0.4
        player.physicsBody.dynamic = false
        
        addChild(player2)
        player2.name = "Paddle"
        player2.position = CGPointMake(size.width/2, CGRectGetMaxY(frame))
        player2.physicsBody = SKPhysicsBody(rectangleOfSize: player2.size)
        player2.physicsBody.restitution = 0.1
        player2.physicsBody.friction = 0.4
        player2.physicsBody.dynamic = false
        
        
        
    }
    
    func getRotationForPosition(position:CGFloat) -> CGFloat{
        var displacmentFromCenter = CGFloat(0)
        
        if position > size.width/2{
            displacmentFromCenter = position - size.width/2
        }else{
            displacmentFromCenter = size.width/2 - position
        }
        
        displacmentFromCenter = displacmentFromCenter/position*20
        
        print("\(displacmentFromCenter)\n")
        
        
        
        var degreeRotation = CDouble(displacmentFromCenter)*M_PI/180
        
        return CGFloat(degreeRotation)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            if location.y < size.height/2{
                var paddleX = location.x
                
                if paddleX < player.size.width/2{
                    paddleX = player.size.width/2
                }else if paddleX > size.width - player.size.width/2{
                    paddleX = size.width - player.size.width/2
                }
                
                player.position = CGPointMake(paddleX, player.position.y)
                player.zRotation = getRotationForPosition(player.position.x)
//                    getRotationForPosition(player.position.x)
//                print("\(getRotationForPosition(player.position.x))\n")
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        var positionX = player2.position.x
        
        var speed = CGFloat(3.4)
        
        if player2.position.x > ball.position.x{
            if positionX-speed < ball.position.x{
                positionX = ball.position.x
            }else{
                positionX -= speed
            }
        }else if player2.position.x < ball.position.x{
            if positionX+speed > ball.position.x{
                positionX = ball.position.x
            }else{
                positionX += speed
            }
        }
        
        player2.position.x = max(positionX, player2.size.width/2)
        player2.position.x = min(positionX, size.width - player2.size.width/2)
        
        
        player2.position = CGPointMake(positionX, player2.position.y)
        
        
    }
}















