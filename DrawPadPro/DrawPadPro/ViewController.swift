//
//  ViewController.swift
//  DrawPadPro
//
//  Created by cpsc on 12/15/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!

    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var transparancy: CGFloat = 1.0
    var swiped = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
          let settingsController = navController.topViewController as? SettingsViewController else {
            return
        }
        settingsController.delegate = self
        settingsController.brush = brushWidth
        settingsController.transparacy = transparancy
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        settingsController.red = red
        settingsController.green = green
        settingsController.blue = blue
    }

    @IBAction func resetPressed(_ sender: Any) {
        mainImageView.image = nil
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        guard let image = mainImageView.image else {
              return
            }
            let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activity, animated: true)
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
          return
        }
        tempImageView.image?.draw(in: view.bounds)
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = transparancy
        
        UIGraphicsEndImageContext()
      }
      
      override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }
        swiped = false
        lastPoint = touch.location(in: view)
      }
      
      override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }
        swiped = true
        let currentPoint = touch.location(in: view)
        drawLine(from: lastPoint, to: currentPoint)
        
        lastPoint = currentPoint
      }
      
      override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {

          drawLine(from: lastPoint, to: lastPoint)
        }
        

        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: transparancy)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
      }
    }


    extension ViewController: SettingsViewControllerDelegate {
      func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
        brushWidth = settingsViewController.brush
        transparancy = settingsViewController.transparacy
        color = UIColor(red: settingsViewController.red,
                        green: settingsViewController.green,
                        blue: settingsViewController.blue,
                        alpha: transparancy)
        dismiss(animated: true)
      }
}
