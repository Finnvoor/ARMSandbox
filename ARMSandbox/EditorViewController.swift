//
//  EditorViewController.swift
//  ARMSandbox
//
//  Created by Finn Voorhees on 15/12/2020.
//

import UIKit

class EditorViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lessonInstructionsLabel: UILabel!
    
    weak var mainViewController: MainViewController?
    
    var textChanged = true
    
    var lesson: Lesson?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.lesson?.title
        self.lessonInstructionsLabel.text = self.lesson?.instructions
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.textView.delegate = self
        self.textView.font = .monospacedSystemFont(ofSize: 26.0, weight: .regular)
        
        self.textView.text = ""
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.mainViewController?.dismiss(animated: true)
    }
    
    @IBAction func reset(_ sender: Any) {
        self.mainViewController?.reset()
    }
    
    @IBAction func step(_ sender: Any) {
        if self.textChanged {
            do {
                try self.mainViewController?.assemble(self.textView.text)
            } catch(let error) {
                let alertController = UIAlertController(title: (error as NSError).domain, message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.textChanged = false
        }
        self.mainViewController?.step()
    }
}

extension EditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textChanged = true
    }
}
