protocol VectorServiceProtocol{
    var vectors: [VectorItemViewModel] { get }
    
    var vectorCreated: ((VectorItemViewModel) -> Void)? { get set }
    
    func requestRefreshVectors()
    
    func createVector(startX: Double, endX: Double, startY: Double, endY: Double, name: String) -> VectorItemViewModel
}
