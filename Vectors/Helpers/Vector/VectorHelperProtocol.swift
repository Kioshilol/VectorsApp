import UIKit

protocol VectorHelperProtocol {
    var vectorToMove: VectorToMove? { get }
    
    func tryHandleVectorTouch(pair: VectorNodePair, location: CGPoint) -> Bool
    
    func tryHandleVectorMove(location: CGPoint, previousLocation: CGPoint, vectorToStick: VectorToStick?) -> Bool
    
    func handleMoveEnded()
    
    func requestUpdateVectorSettings()
    
    func tryToStick(pair: VectorNodePair, location: CGPoint) -> VectorPosition
}
