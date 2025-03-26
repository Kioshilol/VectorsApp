import UIKit

protocol VectorHelperProtocol {
    var vectorToMove: VectorToMove? { get }
    
    func tryHandleVectorTouch(pair: VectorNodePair, location: CGPoint) -> Bool
    
    func tryHandleVectorMove(location: CGPoint, previousLocation: CGPoint) -> Bool
    
    func handleMoveEnded()
    
    func requestUpdateVectorSettings()
}
