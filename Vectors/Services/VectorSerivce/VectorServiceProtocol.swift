//
//  VectorServiceProtocol.swift
//  Vectors
//
//  Created by paintmethecolorofchaos on 20.03.25.
//

protocol VectorServiceProtocol{
    
    var vectors: [VectorItemViewModel] { get }
    
    var vectorCreated: ((VectorItemViewModel) -> Void)? { get set }
    
    func createVector(startX: Double, endX: Double, startY: Double, endY: Double, name: String)
}
