//
//  JDGamePaddle.swift
//  JDGamePaddle
//
//  Created by JamesDouble on 2017/1/6.
//  Copyright © 2017年 jamesdouble. All rights reserved.
//

import Foundation
import SpriteKit


class JDGamePaddle
{
    var rootuiview:UIView?
    var rootskview:SKView?
    var size:CGSize?
    var paddle:JDPaddle!
    var delegate:JDPaddleVectorDelegate?
    {
        didSet{
            paddle.delegate = delegate
        }
    }
    
    init(forUIView view:UIView,size:CGSize) {
        rootuiview = view
        
        let x:CGFloat = view.frame.width / 2 - size.width / 2
        let y:CGFloat = view.frame.height / 2 - size.height / 2
        let skframe:CGRect = CGRect(x: x, y: y, width: size.width, height: size.height)
        rootskview = SKView(frame: skframe)
        rootskview?.isUserInteractionEnabled = true
        paddle = JDPaddle(size: size)
    
        let scene:SKScene = SKScene(size: size)
        scene.backgroundColor = UIColor.white
        scene.isUserInteractionEnabled = true
        scene.addChild(paddle)
        rootskview?.presentScene(scene)
        rootuiview!.addSubview(rootskview!)
    }
    
    init(forSKView view:SKView,size:CGSize)
    {
        rootskview = view
        paddle = JDPaddle(size: size)
        
        let scene:SKScene = SKScene(size: size)
        scene.backgroundColor = UIColor.white
        scene.isUserInteractionEnabled = true
        scene.addChild(paddle)
        rootskview?.presentScene(scene)
    }
    
    init(forScene scene:SKScene,size:CGSize,position:CGPoint)
    {
        paddle = JDPaddle(size: size)
        paddle.position = position
        scene.addChild(paddle)
    }
    
}


protocol JDPaddleVectorDelegate {
    func getVector(vector:CGVector)
}

class JDPaddle:SKSpriteNode
{
    let MovingPing:SKShapeNode?
    let PaddleBorder:SKShapeNode?
    var touching:Bool =  false
    var delegate:JDPaddleVectorDelegate?
   
    init(size:CGSize) {
        
        let paddleSize:CGSize = CGSize(width: size.height * 0.7 , height: size.height * 0.7)
        MovingPing = SKShapeNode(circleOfRadius: paddleSize.width * 0.18)
        MovingPing?.fillColor = UIColor.black
        PaddleBorder = SKShapeNode(circleOfRadius: paddleSize.width * 0.5 )
        PaddleBorder?.fillColor = UIColor.clear
        PaddleBorder?.strokeColor = UIColor.black
        super.init(texture: nil, color: UIColor.clear, size: paddleSize)
        self.zPosition = 1
        self.isUserInteractionEnabled = true
        self.position = CGPoint(x: size.width * 0.5 , y: size.height * 0.5 )
        self.addChild(PaddleBorder!)
        self.addChild(MovingPing!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        touching = true
        let position = touch.location(in: self)
        if((PaddleBorder!.contains(position)))
        {
            MovingPing?.position = touch.location(in: self)
        }
        didMove()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let postion = touch.location(in: self)
        if((PaddleBorder!.contains(postion)))
        {
            MovingPing?.position = postion
        }
        else{
            movingpaddleSmoothly(position: postion)
        }
        didMove()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touching = false
        self.MovingPing?.position = PaddleBorder!.position
        
        if(delegate != nil)
        {
        let zero:CGVector = CGVector.zero
        delegate?.getVector(vector: zero)
        }
    }
    
    
    
    func movingpaddleSmoothly(position:CGPoint)
    {
        let centerPoint = PaddleBorder!.position
        let radius = self.frame.width * 0.5
        var distance:CGFloat = 0
        let diffx:CGFloat = (centerPoint.x - position.x) * (centerPoint.x - position.x)
        let diffy:CGFloat = (centerPoint.y - position.y) * (centerPoint.y - position.y)
        distance = sqrt(diffx + diffy)
        let ratio:CGFloat = radius/distance
        let newPostition:CGPoint = CGPoint(x: position.x * ratio, y: position.y * ratio)
        MovingPing?.position = newPostition
        
    }
    
    func didMove()
    {
        if(delegate == nil)
        {
            return
        }
        
        let nowX:CGFloat = (MovingPing?.position.x)!
        let nowY:CGFloat = (MovingPing?.position.y)!
        let length:CGFloat = sqrt( (nowX * nowX) + (nowY * nowY) )
        let nowVector:CGVector = CGVector(dx: nowX/length, dy: nowY/length)
        delegate?.getVector(vector: nowVector)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



