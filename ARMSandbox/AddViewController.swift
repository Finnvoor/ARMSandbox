//
//  AddViewController.swift
//  ARMSandbox
//
//  Created by Finn Voorhees on 05/04/2021.
//

import UIKit

class AddViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var instructionTextField: UITextField!
    @IBOutlet weak var outputVerifierTextView: UITextView!
    private var image = UIImage()
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        return picker
    }()
    
    weak var lessonsVC: LessonsCollectionViewController?
    
    @IBAction func photoAction(_ sender: Any) {
        self.present(self.imagePicker, animated: true)
    }
    
    @IBAction func addAction(_ sender: Any) {
        self.lessonsVC?.lessons.append(Lesson(
            title: self.titleTextField.text ?? "",
            image: self.image,
            instructions: self.instructionTextField.text ?? "",
            numberCount: 1,
            outputVerifier: self.outputVerifierTextView.text
        ))
        self.lessonsVC?.collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.image = info[.originalImage] as! UIImage
        self.dismiss(animated: true)
    }
}
