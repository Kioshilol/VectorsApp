import Foundation

final class AddVectorViewModel: BaseViewModel {
    private let vectorService: VectorServiceProtocol = CompositionRoot.shared.resolve(VectorServiceProtocol.self)
    
    @Published var startX: String = "";
    @Published var endX: String = "";
    @Published var startY: String = "";
    @Published var endY: String = "";
    @Published var name: String = "";
    @Published var errorText: String = "";
    
    override func initialize() {
        name = vectorService.vectors.count == 0
        ? "Unknown"
        : "Unknown \(vectorService.vectors.count)"
    }
    
    func tryCreateVector() -> Bool {
        errorText = ""
        
        guard let startXValue = Double(startX) else {
            errorText = "Wrong startX"
            return false
        }
        
        guard let endXValue = Double(endX) else {
            errorText = "Wrong endX"
            return false
        }
        
        guard let startYValue = Double(startY) else {
            errorText = "Wrong startY"
            return false
        }
        
        guard let endYValue = Double(endY) else {
            errorText = "Wrong endY"
            return false
        }
        
         _ = vectorService.createVector(
            startX: startXValue,
            endX: endXValue,
            startY: startYValue,
            endY: endYValue,
            name: name)
        
        return true
    }
}
