//
//  VectorEntity+CoreDataProperties.swift
//  Vectors
//
//  Created by paintmethecolorofchaos on 24.03.25.
//
//

import Foundation
import CoreData
import UIKit


extension VectorEntity {
    @NSManaged var uuid: UUID
    @NSManaged var startX: Double
    @NSManaged var endX: Double
    @NSManaged var startY: Double
    @NSManaged var endY: Double
    @NSManaged var name: String
    @NSManaged var color: UIColor
}

extension VectorEntity : Identifiable {

}
