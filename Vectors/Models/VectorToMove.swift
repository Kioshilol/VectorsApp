import SpriteKit

class VectorToMove{
    
    let node: SKShapeNode
    let position: VectorPosition
    let vector: VectorItemViewModel
    
    init(
        node: SKShapeNode,
        position: VectorPosition,
        vector: VectorItemViewModel){
            self.node = node
            self.position = position
            self.vector = vector
        }
}
