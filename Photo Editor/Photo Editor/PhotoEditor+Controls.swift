//
//  PhotoEditor+Controls.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

// MARK: - Control
public enum control: String {
    case circle
    case square
    case arrow
    case text
    case save
    case share
    case clear
    
    public func string() -> String {
        return self.rawValue
    }
}

extension PhotoEditorViewController {
    
    //MARK: Top Toolbar
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        photoEditorDelegate?.canceledEditing()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func circleButtonTapped(_ sender: UIButton) {
        self.didSelectImage(image: UIImage(named: "circle")!)
    }
    
    @IBAction func squareButtonTapped(_ sender: Any) {
        self.didSelectImage(image: UIImage(named: "square")!)
    }
    
    @IBAction func arrowButtonTapped(_ sender: Any) {
        self.didSelectImage(image: UIImage(named: "arrow")!)
    }
    
    @IBAction func textButtonTapped(_ sender: Any) {
        isTyping = true
        let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y,
                                                width: UIScreen.main.bounds.width, height: 30))
        
        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 30)
        textView.textColor = textColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowRadius = 1.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        self.canvasImageView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        view.endEditing(true)
        doneButton.isHidden = true
        colorPickerView.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        hideToolbar(hide: false)
        isDrawing = false
    }
    
    //MARK: Bottom Toolbar
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(canvasView.toImage(),self, #selector(PhotoEditorViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let activity = UIActivityViewController(activityItems: [canvasView.toImage()], applicationActivities: nil)
        if let popoverController = activity.popoverPresentationController {
            popoverController.barButtonItem = UIBarButtonItem(customView: sender)
        }
        
        present(activity, animated: true, completion: nil)
        
    }
    
    @IBAction func clearButtonTapped(_ sender: AnyObject) {
        //clear drawing
        canvasImageView.image = nil
        //clear stickers and textviews
        for subview in canvasImageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let image = self.canvasView.toImage()
        photoEditorDelegate?.doneEditing(image: image)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MAKR: helper methods
    
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideControls() {
        var controls = hiddenControls
        
        for control in controls {
            if (control == "clear") {
                clearButton.isHidden = true
            } else if (control == "circle") {
                circleButton.isHidden = true
            } else if (control == "arrow") {
                arrowButton.isHidden = true
            } else if (control == "save") {
                saveButton.isHidden = true
            } else if (control == "share") {
                shareButton.isHidden = true
            } else if (control == "square") {
                squareButton.isHidden = true
            } else if (control == "text") {
                textButton.isHidden = true
            }
        }
    }
}
