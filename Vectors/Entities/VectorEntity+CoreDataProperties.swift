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
    
    //TODO: for sitcked vector create entity
    @NSManaged var stickedPosition: Int16
    @NSManaged var stickedVectorUuid: UUID?
    @NSManaged var stickedVectorPosition: Int16
}

extension VectorEntity : Identifiable {

}
