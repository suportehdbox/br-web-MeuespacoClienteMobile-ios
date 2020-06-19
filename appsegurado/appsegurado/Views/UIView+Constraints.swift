//
//  UIView+Constraints.swift
//  appsegurado
//
//  Created by Luiz Zenha on 17/06/20.
//  Copyright © 2020 Liberty Seguros. All rights reserved.
//

import Foundation

public extension UIView{
    
    func setLeadingConstraint(withAnchor:NSLayoutAnchor<NSLayoutXAxisAnchor> , constant: CGFloat){
        self.leadingAnchor.constraint(equalTo: withAnchor, constant: constant).isActive = true
    }
    
    func setTrailingConstraint(withAnchor:NSLayoutAnchor<NSLayoutXAxisAnchor> , constant: CGFloat){
        self.trailingAnchor.constraint(equalTo: withAnchor, constant: constant).isActive = true
    }
    
    func setHeightConstraint(constant: CGFloat){
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func setWidthConstraint(constant: CGFloat){
         self.widthAnchor.constraint(equalToConstant: constant).isActive = true
     }
    
    func setTopConstraint(withAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor> , constant: CGFloat){
        self.topAnchor.constraint(equalTo: withAnchor, constant: constant).isActive = true
    }
    
    func setBottomConstraint(withAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor> , constant: CGFloat){
        self.bottomAnchor.constraint(equalTo: withAnchor, constant: constant).isActive = true
    }
    
    func setCenterYConstraint(withAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat){
        self.centerYAnchor.constraint(equalTo: withAnchor, constant: constant).isActive = true
    }
    
}

extension UILabel {

    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(spacingValue: CGFloat = 2) {

        // MARK: - Check if there's any text
        guard let textString = text else { return }

        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacingValue
        paragraphStyle.alignment = textAlignment
        
        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))
        
        if (textColor != nil){
            attributedString.addAttribute(
                .foregroundColor,
                value: textColor!,
                range: NSRange(location: 0, length: attributedString.length
            ))
        }
        
        attributedText = attributedString
    }

}
