//
//  ViewController.swift
//  Food Tracker
//
//  Created by Archie on 12/28/19.
//  Copyright © 2019 Archie. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var mealNameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var tapCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealNameTextField.delegate = self
        
        print("viewLoaded")
        
        tapLabel.isUserInteractionEnabled = true
        let gestureLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped))
        tapLabel.addGestureRecognizer(gestureLabel)
    }
    
    @objc func labelTapped() {
        print("Tapped")
        tapLabel.text = "Tap \(tapCount)"
        self.tapCount += 1
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
                mealNameTextField.resignFirstResponder()
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setDefaultLabelText(_ sender: Any) {
        mealNameLabel.text = "Default Text"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setLabelValue(value: textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mealNameLabel.text = textField.text
    }
    
    func setLabelValue(value: String) {
        if (value == "") {
            return
        }
        
        mealNameLabel.text = value
    }
}

