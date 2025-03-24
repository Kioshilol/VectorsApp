import UIKit

protocol VectorHandlerProtocol {
    func tryHandleVectorTouch(pair: VectorNodePair, location: CGPoint) -> Bool
    
    func tryHandleVectorMove(location: CGPoint, previousLocation: CGPoint) -> Bool
    
    func handleMoveEnded()
}
