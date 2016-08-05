//
//  DefaultContextViewController.swift
//  Lady
//
//  Created by Limon on 8/3/16.
//  Copyright © 2016 Lady. All rights reserved.
//

import UIKit
import Lady

class DefaultRenderContextViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let context = CIContext(options: [kCIContextWorkingColorSpace: CGColorSpaceCreateDeviceRGB()!])
    let filter = HighPassSkinSmoothingFilter()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var amountSlider: UISlider!

    var sourceImage: UIImage! {
        didSet {
            self.inputCIImage = CIImage(CGImage: self.sourceImage.CGImage!)
        }
    }
    var processedImage: UIImage?
    
    var inputCIImage: CIImage!
    
    @IBAction func chooseImageBarButtonItemTapped(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.view.backgroundColor = UIColor.whiteColor()
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sourceImage = image
        self.processImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sourceImage = UIImage(named: "SampleImage")!
        self.processImage()
    }
    
    @IBAction func amountSliderTouchUp(sender: AnyObject) {
        self.processImage()
    }

    func processImage() {


        let filter = CIFilter(name: "YUCIHighPassSkinSmoothing")!
        filter.setValue(inputCIImage, forKey: kCIInputImageKey)
        filter.setValue(self.amountSlider.value, forKey: "inputAmount")
        filter.setValue(7.0 * inputCIImage.extent.width/750.0, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!

//        self.filter.inputImage = self.inputCIImage
//        self.filter.inputAmount = self.amountSlider.value
//        self.filter.inputRadius = 7.0 * self.inputCIImage.extent.width/750.0

//        let outputCIImage = filter.outputImage!

        let outputCGImage = self.context.createCGImage(outputCIImage, fromRect: outputCIImage.extent)
        let outputUIImage = UIImage(CGImage: outputCGImage, scale: self.sourceImage.scale, orientation: self.sourceImage.imageOrientation)
        
        self.processedImage = outputUIImage
        self.imageView.image = self.processedImage
    }
    
    @IBAction func handleImageViewLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            self.imageView.image = self.sourceImage
        } else if (sender.state == .Ended || sender.state == .Cancelled) {
            self.imageView.image = self.processedImage
        }
    }
}
