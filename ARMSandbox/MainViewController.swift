//
//  MainViewController.swift
//  ARMSandbox
//
//  Created by Finn Voorhees on 15/12/2020.
//

import UIKit
import swift_tinyarm
import tinyasm

class MainViewController: UIViewController {
    private var editorViewController: EditorViewController!
    private var testViewController: TestViewController!
    
    var lesson: Lesson?

    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        AppDelegate.cpu.onRegisterChange = { register, value in
            NotificationCenter.default.post(
                name: NSNotification.Name("registerDidChange"),
                object: nil,
                userInfo: ["reg": register, "val": value]
            )
        }
        
        for r in 0..<17 {
            AppDelegate.cpu.onRegisterChange?(Int32(r), AppDelegate.cpu.registerValue(r))
        }
        
        AppDelegate.cpu.afterInstructionExecution = {
            NotificationCenter.default.post(name: NSNotification.Name("afterInstructionExecution"), object: nil)
        }
        
        AppDelegate.cpu.onSoftwareInterrupt = { comment in
            var cont = false
            NotificationCenter.default.addObserver(forName: NSNotification.Name("softwareInterruptShouldContinue"), object: nil, queue: nil) { (_) in
                cont = true
            }
            
            switch comment {
            case 1: NotificationCenter.default.post(name: NSNotification.Name("pickupInput"), object: nil)
            case 2: NotificationCenter.default.post(name: NSNotification.Name("placeMemory"), object: nil)
            case 3: NotificationCenter.default.post(name: NSNotification.Name("pickupMemory"), object: nil)
            case 4: NotificationCenter.default.post(name: NSNotification.Name("placeOutput"), object: nil)
            case 5: NotificationCenter.default.post(name: NSNotification.Name("movePlayerDown"), object: nil)
            default: break
            }
            
            while !cont {
                RunLoop.current.run(until: Date().addingTimeInterval(0.1))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditorSegue" {
            self.editorViewController = (segue.destination as! UINavigationController).visibleViewController as? EditorViewController
            self.editorViewController.mainViewController = self
            self.editorViewController.lesson = self.lesson
        } else if segue.identifier == "TestSegue" {
            self.testViewController = segue.destination as? TestViewController
            self.testViewController.lesson = self.lesson
        }
    }
    
    func assemble(_ program: String) throws {
        if let assembledBytes = try KeystoneAssembler.arm.assemble(source: program) {
            AppDelegate.cpu.loadProgram(assembledBytes + [0, 0, 0, 0])
        }
    }
    
    func reset() {
        AppDelegate.cpu.reset()
        self.testViewController.resetScene()
    }
    
    func step() {
        _ = AppDelegate.cpu.step()
    }
    
    func run() {
        AppDelegate.cpu.run()
    }
}
