//
//  Extentions.swift
//  AnciarApp
//
//  Created by Lakshminaidu on 29/4/2022.
//

import Foundation
extension NSObject {
    public static var className: String {
        return String(describing: self.self)
    }
}
