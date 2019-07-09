//
//  LocalizableLabelString.swift
//  CityGNSS
//
//  Created by Tiago Maia on 12/06/2019.
//  Copyright © 2019 Tiago Maia. All rights reserved.
//

import Foundation
import UIKit

// protocol that will use to get a localized string from another string used as the key
protocol Localizable {
    var localized: String { get }
}

//protocol that will use to localize controls from an IB file
protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}



//this extension implements this interface in those controls suitable to be localized
extension UILabel {
    
    /// The IBInspectable helps us to set localizable text in IB
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }

    
    /// The IBInspectable helps us to set localizable text in IB
    @IBInspectable var localizableText: String? {
        get { return text }
        set(value) { text = value?.localized() }
    }
    
    /// The IBInspectable helps us to set localizable text in IB
    @IBInspectable var localizableUppercaseText: String? {
        get { return text }
        set(value) { text = value?.localized().uppercased() }
    }
    
}

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
}

extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}
