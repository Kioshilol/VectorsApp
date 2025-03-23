//
//  Vector.swift
//  Vectors
//
//  Created by paintmethecolorofchaos on 20.03.25.
//

import UIKit

class VectorItemViewModel: ObservableObject, Identifiable{
    
    @Published var name: String
    
    private(set) var startX: Double;
    private(set) var endX: Double;
    private(set) var startY: Double;
    private(set) var endY: Double;
    let color: UIColor;
    
    init(
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double,
        name: String) {
            self.startX = startX
            self.endX = endX
            self.startY = startY
            self.endY = endY
            color = UIColor.yolo()
            self.name = name;
    }
    
    func changeCoordinates(
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double){
            self.startX = startX
            self.endX = endX
            self.startY = startY
            self.endY = endY
        }
}
