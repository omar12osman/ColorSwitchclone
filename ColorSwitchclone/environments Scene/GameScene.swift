//
//  GameScene.swift
//  ColorSwitchclone
//
//  Created by Majid Osman on 2018-12-13.
//  Copyright © 2018 Majid Osman. All rights reserved.
//

import SpriteKit

enum PlayerColors {
   static let colors = [
    
    UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
     UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
      UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
       UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState : Int {
    case red, yellow , green , blue
}

class GameScene: SKScene {
    
    
    var colorSwitch : SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorindex : Int?
    
    
    override func didMove(to view: SKView) {
        Setupphysics()
        LayoutScene()
        
        }
    
    func Setupphysics() {
        physicsWorld.gravity = CGVector(dx: 0.0 , dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    func  LayoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "ColorSwitch")
        colorSwitch.size = CGSize(width: frame.size.width / 3  , height: frame.size.width / 3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width / 2)
        colorSwitch.physicsBody?.categoryBitMask = physicsDivisions.Switchrotation
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        BallrotationViewsetup()
    }
    
    func wheelrotation(){
        
        if let Newstate = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = Newstate
        } else {
            switchState = .red
        }
       
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func GameOver() {
        print("Game Over")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wheelrotation()
    }
    
    func BallrotationViewsetup(){
        currentColorindex = Int(arc4random_uniform(UInt32(4)))
        let Ball = SKSpriteNode(texture: SKTexture(imageNamed: "Image-1"), color: PlayerColors.colors[currentColorindex!], size: CGSize(width: 44.0 , height:  44.0))
         Ball.colorBlendFactor = 1.0
         Ball.name = "Ball"
         Ball.position = CGPoint(x: frame.midX, y: frame.maxY)
         Ball.physicsBody = SKPhysicsBody(circleOfRadius: Ball.size.width / 2)
         Ball.physicsBody?.categoryBitMask = physicsDivisions.ballDivisions
         Ball.physicsBody?.contactTestBitMask = physicsDivisions.Switchrotation
         Ball.physicsBody?.collisionBitMask = physicsDivisions.None
        addChild(Ball)
    }
    
      
}


extension GameScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == physicsDivisions.ballDivisions | physicsDivisions.Switchrotation {
            if let Ball = contact.bodyA.node?.name == "Ball" ? contact.bodyB.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColorindex == switchState.rawValue {
                    
                    Ball.run(SKAction.fadeOut(withDuration: 0.25)) {
                        Ball.removeFromParent()
                        self.BallrotationViewsetup()
                    }
                } else {
                    GameOver()
                    
                }
            }
        }
    }
}
