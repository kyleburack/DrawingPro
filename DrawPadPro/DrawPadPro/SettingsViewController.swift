//
//  SettingsViewController.swift
//  DrawPadPro
//
//  Created by cpsc on 12/15/20.
//

import Foundation
import UIKit

protocol SettingsViewControllerDelegate: class {
  func settingsViewControllerFinished(_ settingsViewController: SettingsViewController)
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var sliderTransparancy: UISlider!
    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var labelTransparancy: UILabel!
      
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    @IBOutlet weak var labelRed: UILabel!
    @IBOutlet weak var labelGreen: UILabel!
    @IBOutlet weak var labelBlue: UILabel!
      
    @IBOutlet weak var previewImageView: UIImageView!
    
    var brush: CGFloat = 10.0
    var transparacy: CGFloat = 1.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    struct GlobalVariable {
        static var color = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    }
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      sliderBrush.value = Float(brush)
      labelBrush.text = String(format: "%.1f", brush)
      sliderTransparancy.value = Float(transparacy)
      labelTransparancy.text = String(format: "%.1f", transparacy)
      sliderRed.value = Float(red * 255.0)
      labelRed.text = Int(sliderRed.value).description
      sliderGreen.value = Float(green * 255.0)
      labelGreen.text = Int(sliderGreen.value).description
      sliderBlue.value = Float(blue * 255.0)
      labelBlue.text = Int(sliderBlue.value).description
      
      drawPreview()
    }
    
    @IBAction func brushChanged(_ sender: UISlider) {
      brush = CGFloat(sender.value)
      labelBrush.text = String(format: "%.1f", brush)
      drawPreview()
    }
    
    @IBAction func transparacyChanged(_ sender: UISlider) {
      transparacy = CGFloat(sender.value)
      labelTransparancy.text = String(format: "%.1f", transparacy)
      drawPreview()
    }
    
    @IBAction func colorChanged(_ sender: UISlider) {
      red = CGFloat(sliderRed.value / 255.0)
      labelRed.text = Int(sliderRed.value).description
      green = CGFloat(sliderGreen.value / 255.0)
      labelGreen.text = Int(sliderGreen.value).description
      blue = CGFloat(sliderBlue.value / 255.0)
      labelBlue.text = Int(sliderBlue.value).description
      
        GlobalVariable.color = UIColor(red: red, green: green, blue: blue, alpha: transparacy)
      drawPreview()
    }
    
    func drawPreview() {
      UIGraphicsBeginImageContext(previewImageView.frame.size)
      guard let context = UIGraphicsGetCurrentContext() else {
        return
      }
      
      context.setLineCap(.round)
      context.setLineWidth(brush)
      context.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: transparacy).cgColor)
      context.move(to: CGPoint(x: 45, y: 45))
      context.addLine(to: CGPoint(x: 45, y: 45))
      context.strokePath()
      previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    }
}
