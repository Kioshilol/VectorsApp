//
//  VectorService.swift
//  Vectors
//
//  Created by paintmethecolorofchaos on 15.03.25.
//

final class VectorService: VectorServiceProtocol{
    
    var vectors: [VectorItemViewModel] = []
    
    var vectorCreated: ((VectorItemViewModel) -> Void)?
    
    func createVector(
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double,
        name: String) {
            
        let vector = VectorItemViewModel(
            startX: startX,
            endX: endX,
            startY: startY,
            endY: endY,
            name: name)
            
        vectorCreated?(vector)
    
        vectors.append(vector)
    }
}
