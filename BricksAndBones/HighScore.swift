//
//  HighScore.swift
//  BricksAndBones
//
//  Created by Justin on 2021-04-20.
//

import Foundation
import UIKit

class HighScoreView: UIView {
    
    let hsView = UIView(frame: CGRect.zero)
    let hsTitle = UILabel(frame: CGRect.zero)
    let hsText = UILabel(frame: CGRect.zero)
    let hsButton = UIButton(frame: CGRect.zero)
    
    let BorderWidth: CGFloat = 2.0
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Popup Background
        hsView.backgroundColor = UIColor.blue
        hsView.layer.borderWidth = BorderWidth
        hsView.layer.masksToBounds = true
        hsView.layer.borderColor = UIColor.white.cgColor
                
        // Popup Title
        hsTitle.textColor = UIColor.white
        hsTitle.backgroundColor = UIColor.yellow
        hsTitle.layer.masksToBounds = true
        hsTitle.adjustsFontSizeToFitWidth = true
        hsTitle.clipsToBounds = true
        hsTitle.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        hsTitle.numberOfLines = 1
        hsTitle.textAlignment = .center
                
        // Popup Text
        hsText.textColor = UIColor.white
        hsText.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        hsText.numberOfLines = 0
        hsText.textAlignment = .center
                
        // Popup Button
        hsButton.setTitleColor(UIColor.white, for: .normal)
        hsButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        hsButton.backgroundColor = UIColor.yellow
                
        hsView.addSubview(hsTitle)
        hsView.addSubview(hsText)
        hsView.addSubview(hsButton)
                
        addSubview(hsView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
