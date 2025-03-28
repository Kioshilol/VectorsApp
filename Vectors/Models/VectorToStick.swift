import SpriteKit

final class VectorToStick {
    let stickedVectorPosition: VectorPosition
    let stickPosition: VectorPosition
    let vector: VectorItemViewModel
    
    init(
        stickedVectorPosition: VectorPosition,
        position: VectorPosition,
        vector: VectorItemViewModel) {
            self.stickedVectorPosition = stickedVectorPosition
            self.stickPosition = position
            self.vector = vector
        }
}
