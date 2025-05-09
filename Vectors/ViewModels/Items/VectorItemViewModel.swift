import UIKit

class VectorItemViewModel: ObservableObject, Identifiable{
    var name: String
    var distance: String = "";
    var stickedVector: VectorToStick? = nil
    
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
            setupDistance()
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
            setupDistance()
        }
    
    func setupDistance(){
        distance = String(hypotf(
            Float(self.endX - self.startX),
            Float(self.endY - self.startY)))
    }
}
