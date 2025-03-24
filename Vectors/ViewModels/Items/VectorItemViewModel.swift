import UIKit

class VectorItemViewModel: ObservableObject, Identifiable{
    @Published var name: String
    
    private(set) var uuid: UUID;
    private(set) var startX: Double;
    private(set) var endX: Double;
    private(set) var startY: Double;
    private(set) var endY: Double;
    private(set) var color: UIColor;
    
    
    init(
        uuid: UUID,
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double,
        name: String,
        color: UIColor = UIColor.yolo()) {
            self.uuid = uuid
            self.startX = startX
            self.endX = endX
            self.startY = startY
            self.endY = endY
            self.color = color
            self.name = name;
    }
    
    func changeCoordinates(
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double) {
            self.startX = startX
            self.endX = endX
            self.startY = startY
            self.endY = endY
        }
}
