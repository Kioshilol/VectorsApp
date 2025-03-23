import UIKit
import SpriteKit

extension SKShapeNode {
    
    func scaleLineHeight(
        duration: CGFloat,
        startLineHeight: CGFloat,
        endLineHeight: CGFloat,
        increaseLineHeightAnimationDuration: TimeInterval,
        decreaseLineHeightAnimationDuration: TimeInterval)
    {
        let increaseLineWidthInternal = SKAction.customAction(withDuration: increaseLineHeightAnimationDuration) {
            node, elapsedTime in
            
            guard let node = node as? SKShapeNode else {
                return
            }
            
            node.lineWidth = endLineHeight * elapsedTime / increaseLineHeightAnimationDuration
        }
        
        let delay = SKAction.wait(forDuration: duration)
        
        let decreaseLineWidthInternal = SKAction.customAction(withDuration: decreaseLineHeightAnimationDuration) {
            node, elapsedTime in
            
            guard let node = node as? SKShapeNode else {
                return
            }
            
            let time = decreaseLineHeightAnimationDuration - elapsedTime
            let lineWidth = endLineHeight * time / decreaseLineHeightAnimationDuration
            node.lineWidth =  lineWidth <= 0
            ? startLineHeight
            : lineWidth
        }
        
        self.run(SKAction.sequence([increaseLineWidthInternal, delay, decreaseLineWidthInternal]))
    }
}
