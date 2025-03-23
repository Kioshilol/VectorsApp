//
//  Color.swift
//  Vectors
//
//  Created by paintmethecolorofchaos on 15.03.25.
//

import UIKit

extension UIColor {

    //yolo means you only live once = random hehe :)
    static func yolo() -> UIColor {
        UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }
}
