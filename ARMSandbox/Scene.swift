//
//  Scene.swift
//  ARMSandbox
//
//  Created by Finn Voorhees on 10/02/2021.
//

import SpriteKit
import JavaScriptCore

class Scene: SKScene {
    weak var viewController: UIViewController?
    
    let jsContext = JSContext()!
    
    var numberInMemoryPort = false {
        didSet {
            guard let numberNode = self.childNode(withName: "number"),
                  let labelNode = numberNode.children.first as? SKLabelNode,
                  let text = labelNode.text,
                  let number = UInt32(text) else { return }
            if self.numberInMemoryPort {
                DispatchQueue.global().async {
                    AppDelegate.cpu.writeMMUI32LittleEndian(at: 0x2000, value: number.littleEndian)
                }
            }
        }
    }
    
    let tileSize: CGFloat = 128
    let playerSpeed = 0.3
    
    var inputNumber: UInt8 = 0
    
    var lesson: Lesson?
    
    var numberOfCorrectOutputs = 0
    
    lazy var player: SKSpriteNode = {
        return self.childNode(withName: "player") as! SKSpriteNode
    }()
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("afterInstructionExecution"), object: nil, queue: nil) { (_) in
            if let numberNode = self.childNode(withName: "number"),
               round(numberNode.position.x) == round(self.tileSize * 4),
               round(numberNode.position.y) == round(self.tileSize * 5),
               let labelNode = numberNode.children.first as? SKLabelNode {
                DispatchQueue.global().async {
                    labelNode.text = "\(AppDelegate.cpu.readMMUI32LittleEndian(at: 0x2000).littleEndian)"
                }
            }
        }
        
        self.createNumber()
    }
    
    func createNumber(completion: @escaping (() -> Void) = {}) {
        let numberNode = SKSpriteNode(imageNamed: "crate_44")
        numberNode.name = "number"
        numberNode.anchorPoint = .zero
        numberNode.position = CGPoint(x: self.tileSize * 2, y: self.tileSize * 11)
        self.inputNumber = UInt8.random(in: 0...UInt8.max)
        let labelNode = SKLabelNode(text: "\(self.inputNumber)")
        labelNode.position = CGPoint(x: self.tileSize / 2, y: self.tileSize / 2)
        labelNode.fontSize = 40
        labelNode.verticalAlignmentMode = .center
        numberNode.addChild(labelNode)
        self.addChild(numberNode)
        numberNode.run(SKAction.move(by: CGVector(dx: 0, dy: -self.tileSize), duration: 0.5), completion: completion)
    }
    
    func pickupNumber() {
        if let numberNode = self.childNode(withName: "number"),
           round(numberNode.position.x) == round(self.player.position.x),
           round(numberNode.position.y) == round(self.player.position.y + self.tileSize) {
            numberNode.removeFromParent()
            numberNode.position = CGPoint(x: 0, y: self.tileSize / 2)
            numberNode.setScale(0.5)
            self.player.addChild(numberNode)
            self.numberInMemoryPort = false
        }
    }
    
    func placeNumberAbove() {
        if let numberNode = self.player.childNode(withName: "number") {
            numberNode.removeFromParent()
            self.addChild(numberNode)
            numberNode.setScale(1)
            numberNode.position = CGPoint(x: self.player.position.x, y: self.player.position.y + self.tileSize)
            
            self.checkNumberPosition()
        }
    }
    
    func placeNumberBelow() {
        if let numberNode = self.player.childNode(withName: "number") {
            numberNode.removeFromParent()
            self.addChild(numberNode)
            numberNode.setScale(1)
            numberNode.position = CGPoint(x: self.player.position.x, y: self.player.position.y - self.tileSize)
            
            self.checkNumberPosition()
        }
    }
    
    func checkNumberPosition() {
        if let numberNode = self.childNode(withName: "number") {
            if round(numberNode.position.x) == round(self.tileSize * 4),
               round(numberNode.position.y) == round(self.tileSize * 5) {
                self.numberInMemoryPort = true
            } else if round(numberNode.position.x) == round(self.tileSize * 6),
                      round(numberNode.position.y) == 0 {
                self.validateOutput()
            }
        }
    }
    
    func validateOutput() {
        if let numberNode = self.childNode(withName: "number"),
           let labelNode = numberNode.children.first as? SKLabelNode,
           let text = labelNode.text,
           let outputNumber = UInt32(text),
           let lesson = self.lesson {
            let inputNumber = self.inputNumber
            numberNode.run(SKAction.move(by: CGVector(dx: 0, dy: -self.tileSize), duration: 0.5)) {
                numberNode.removeFromParent()
                
                self.jsContext.evaluateScript(lesson.outputVerifier)
                
                if self.jsContext.evaluateScript("verify(\(inputNumber), \(outputNumber))")?.toBool() ?? false {
                    self.numberOfCorrectOutputs += 1
                    self.showSuccess()
                    if self.numberOfCorrectOutputs == self.lesson?.numberCount {
                        let alertController = UIAlertController(title: "Lesson Complete!", message: nil, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            self.viewController?.dismiss(animated: true, completion: nil)
                        }))
                        self.viewController?.present(alertController, animated: true)
                    }
                } else {
                    self.numberOfCorrectOutputs = 0
                    self.showFailure()
                }
                self.createNumber()
            }
        }
    }
    
    func showSuccess() {
        let successNode = SKSpriteNode(imageNamed: "Success")
        successNode.setScale(0)
        successNode.position = CGPoint(x: 4.5 * self.tileSize, y: self.tileSize * 5.5)
        self.addChild(successNode)
        
        let action = SKAction.scale(to: 1.0, duration: 0.5)
        action.timingMode = .easeIn
        successNode.run(action) {
            successNode.run(SKAction.fadeAlpha(to: 0, duration: 0.2)) {
                successNode.removeFromParent()
            }
        }
    }
    
    func showFailure() {
        let failureNode = SKSpriteNode(imageNamed: "Failure")
        failureNode.setScale(0)
        failureNode.position = CGPoint(x: 4.5 * self.tileSize, y: self.tileSize * 5.5)
        self.addChild(failureNode)
        
        let action = SKAction.scale(to: 1.0, duration: 0.5)
        action.timingMode = .easeIn
        failureNode.run(action) {
            failureNode.run(SKAction.fadeAlpha(to: 0, duration: 0.2)) {
                failureNode.removeFromParent()
            }
        }
    }
    
    func movePlayer(to location: CGPoint, duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        let xDuration = (duration ?? self.playerSpeed) * TimeInterval(abs((Int(self.player.position.x / self.tileSize) - 1) - Int(location.x)))
        let yDuration = (duration ?? self.playerSpeed) * TimeInterval(abs((Int(self.player.position.y / self.tileSize) - 1) - Int(location.y)))
        self.player.run(SKAction.move(to: CGPoint(x: self.tileSize * (location.x + 1), y: self.player.position.y), duration: xDuration)) {
            self.player.run(SKAction.move(to: CGPoint(x: self.player.position.x, y: self.tileSize * (location.y + 1)), duration: yDuration), completion: completion ?? {})
        }
    }
    
    func movePlayerLeft(_ duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        self.player.run(SKAction.move(by: CGVector(dx: -self.tileSize, dy: 0), duration: duration ?? self.playerSpeed), completion: completion ?? {})
    }
    
    func movePlayerRight(_ duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        self.player.run(SKAction.move(by: CGVector(dx: self.tileSize, dy: 0), duration: duration ?? self.playerSpeed), completion: completion ?? {})
    }
    
    func movePlayerUp(_ duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        self.player.run(SKAction.move(by: CGVector(dx: 0, dy: self.tileSize), duration: duration ?? self.playerSpeed), completion: completion ?? {})
    }
    
    func movePlayerDown(_ duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        self.player.run(SKAction.move(by: CGVector(dx: 0, dy: -self.tileSize), duration: duration ?? self.playerSpeed), completion: completion ?? {})
    }
}
