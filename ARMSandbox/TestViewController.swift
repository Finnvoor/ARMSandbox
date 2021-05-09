//
//  TestViewController.swift
//  ARMSandbox
//
//  Created by Finn Voorhees on 17/12/2020.
//

import UIKit
import SpriteKit

class TestViewController: UIViewController {
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var registersTableView: UITableView!
    @IBOutlet weak var registersTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var registersHandleView: UIVisualEffectView!
    
    var scene: Scene!
    var lesson: Lesson?
    
    struct Register {
        let name: String
        var value: UInt32
    }
    
    var registers: [Register] = [
        "R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7",
        "R8", "R9", "R10", "R11", "R12", "SP", "LR", "PC", "CPSR"
    ].map({ Register(name: $0, value: 0) })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resetScene()
        self.scene.lesson = self.lesson
        
        self.visualEffectView.layer.cornerRadius = 10
        self.visualEffectView.clipsToBounds = true
        
        self.registersHandleView.layer.cornerRadius = self.registersHandleView.frame.height / 2
        self.registersHandleView.clipsToBounds = true
    
        self.registersTableView.delegate = self
        self.registersTableView.dataSource = self
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("registerDidChange"),
            object: nil,
            queue: nil
        ) { (notification) in
            if let register = notification.userInfo?["reg"] as? Int32,
               let newValue = notification.userInfo?["val"] as? UInt32 {
                self.registers[Int(register)].value = newValue
                self.registersTableView.reloadData()
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("pickupInput"), object: nil, queue: nil) { (_) in
            self.scene.movePlayer(to: CGPoint(x: 1, y: 8)) {
                self.scene.pickupNumber()
                NotificationCenter.default.post(name: NSNotification.Name("softwareInterruptShouldContinue"), object: nil)
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("placeMemory"), object: nil, queue: nil) { (_) in
            self.scene.movePlayer(to: CGPoint(x: 3, y: 3)) {
                self.scene.placeNumberAbove()
                NotificationCenter.default.post(name: NSNotification.Name("softwareInterruptShouldContinue"), object: nil)
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("pickupMemory"), object: nil, queue: nil) { (_) in
            self.scene.movePlayer(to: CGPoint(x: 3, y: 3)) {
                self.scene.pickupNumber()
                NotificationCenter.default.post(name: NSNotification.Name("softwareInterruptShouldContinue"), object: nil)
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("placeOutput"), object: nil, queue: nil) { (_) in
            self.scene.movePlayer(to: CGPoint(x: 5, y: 0)) {
                self.scene.placeNumberBelow()
                NotificationCenter.default.post(name: NSNotification.Name("softwareInterruptShouldContinue"), object: nil)
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("movePlayerRight"), object: nil, queue: nil) { (_) in
            self.scene.movePlayerRight {
                NotificationCenter.default.post(name: NSNotification.Name("softwareInterruptShouldContinue"), object: nil)
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("movePlayerLeft"), object: nil, queue: nil) { (_) in
            self.scene.movePlayerLeft {
                NotificationCenter.default.post(name: NSNotification.Name("softwareInterruptShouldContinue"), object: nil)
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("movePlayerUp"), object: nil, queue: nil) { (_) in
            self.scene.movePlayerUp {
                NotificationCenter.default.post(name: NSNotification.Name("softwareInterruptShouldContinue"), object: nil)
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("movePlayerDown"), object: nil, queue: nil) { (_) in
            self.scene.movePlayerDown {
                NotificationCenter.default.post(name: NSNotification.Name("softwareInterruptShouldContinue"), object: nil)
            }
        }
    }
    
    func resetScene() {
        self.scene = Scene(fileNamed: "TestScene")
        self.scene.viewController = self
        self.scene.lesson = self.lesson
        self.scene.backgroundColor = .red
        self.skView.showsFPS = false
        self.skView.showsNodeCount = false
        self.scene.scaleMode = .fill
        self.skView.presentScene(self.scene)
    }
    
    private var initialPanHeight: CGFloat?
    private var initialVisualEffectViewHeight: CGFloat?
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            self.initialPanHeight = sender.location(in: nil).y
            self.initialVisualEffectViewHeight = self.visualEffectView.frame.height
        }
        
        if let initialPanHeight = self.initialPanHeight,
           let initialVisualEffectViewHeight = self.initialVisualEffectViewHeight {
            let delta = initialPanHeight - sender.location(in: nil).y
            self.registersTableViewHeightConstraint.constant = min(max(initialVisualEffectViewHeight - delta, 60), self.registersTableView.contentSize.height)
        }
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.registers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registerTableViewCell", for: indexPath) as! RegisterTableViewCell
        cell.registerNameLabel.font = .monospacedSystemFont(ofSize: 17.0, weight: .regular)
        cell.registerNameLabel.text = self.registers[indexPath.row].name
        cell.registerValueLabel.font = .monospacedSystemFont(ofSize: 17.0, weight: .regular)
        cell.registerValueLabel.text = "\(self.registers[indexPath.row].value)"
        return cell
    }
}
