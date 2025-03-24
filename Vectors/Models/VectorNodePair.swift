import SpriteKit

final class VectorNodePair{
    let vector: VectorItemViewModel
    let node: SKShapeNode
    
    init(
        vector: VectorItemViewModel,
        node: SKShapeNode){
            
        self.vector = vector
        self.node = node
    }
}

