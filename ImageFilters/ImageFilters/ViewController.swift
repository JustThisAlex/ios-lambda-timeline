//
//  ViewController.swift
//  ImageFilters
//
//  Created by Alexander Supe on 10.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class ViewController: UIViewController {
    
    private var originalImage: UIImage? { didSet {
        guard let originalImage = originalImage else { return }
        var scaledSize = imageView.bounds.size
        let scale = UIScreen.main.scale
        scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
        scaledImage = originalImage.imageByScaling(toSize: scaledSize)
        }}
    
    private var scaledImage: UIImage? { didSet { updateImage() }}
    private let context = CIContext(options: nil)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var exposure: UISlider!
    @IBOutlet weak var hue: UISlider!
    @IBOutlet weak var vibrance: UISlider!
    @IBOutlet weak var posterize: UISlider!
    @IBOutlet weak var inverted: UIButton!
    @IBOutlet weak var stack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stack.isHidden = true
    }

    @IBAction func boxChecked(_ sender: UIButton) {
        sender.isSelected.toggle()
        updateImage()
    }
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = filter(image: scaledImage)
        } else {
            imageView.image = nil
        }
    }
    
    private func filter(image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        var ciImage: CIImage? = CIImage(cgImage: cgImage)
        let filter1 = CIFilter.exposureAdjust()
        filter1.inputImage = ciImage
        filter1.ev = exposure.value
        ciImage = filter1.outputImage
        let filter2 = CIFilter.hueAdjust()
        filter2.inputImage = ciImage
        filter2.angle = hue.value
        ciImage = filter2.outputImage
        let filter3 = CIFilter.vibrance()
        filter3.inputImage = ciImage
        filter3.amount = vibrance.value
        ciImage = filter3.outputImage
        let filter4 = CIFilter.colorPosterize()
        filter4.inputImage = ciImage
        filter4.levels = posterize.value
        ciImage = filter4.outputImage
        if inverted.isSelected {
            let filter5 = CIFilter.colorInvert()
            filter5.inputImage = ciImage
            ciImage = filter5.outputImage
        }
        guard let outputCI = ciImage else { return nil }
        guard let outputCG = context.createCGImage(outputCI, from: CGRect(origin: CGPoint.zero, size: image.size)) else { return nil }
        return UIImage(cgImage: outputCG)
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        updateImage()
    }
    @IBAction func pick(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    @IBAction func save(_ sender: Any) {
        guard let originalImage = originalImage else { return }
        guard let processedImage = self.filter(image: originalImage.flattened) else { return }
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: processedImage)
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("Error saving photo: \(error)")
                    return
                }
            })
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Picked image")
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
            stack.isHidden = false
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled picker")
    }
}
