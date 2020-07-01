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
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var tapCount = 0;
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tap recoginzer for Tap Me! button
        tapLabel.isUserInteractionEnabled = true
        let gestureLabel = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped))
        tapLabel.addGestureRecognizer(gestureLabel)
        
        // Handle the text field's user input through delegate callback.
        mealNameTextField.delegate = self
        
        // Setup up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            mealNameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonSate()
    }
    
    @objc func labelTapped() {
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
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setLabelValue(value: textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
    
    func setLabelValue(value: String) {
        if (value == "") {
            return
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            print("The save button was not presssed, cancelling")
            return
        }
        
        let name = mealNameTextField.text ?? ""
        let photo = photoImageView.image
        let rate = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rate)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            // Close modal
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The ViewController is not inside a navigation controller.")
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonSate()
        navigationItem.title = textField.text
    }
    
    // MARK: Private Methods
    private func updateSaveButtonSate() {
        // Disable the Save button if the text field is empty.
        let text = mealNameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

