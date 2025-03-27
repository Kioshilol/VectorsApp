import SpriteKit

final class VectorToStick {
    let node: SKShapeNode
    let stickPosition: VectorPosition
    let vector: VectorItemViewModel
    
    init(
        node: SKShapeNode,
        position: VectorPosition,
        vector: VectorItemViewModel){
            self.node = node
            self.stickPosition = position
            self.vector = vector
        }
}
