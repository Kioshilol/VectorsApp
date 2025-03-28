import Foundation
import UIKit
import CoreData

final class VectorManager: VectorManagerProtocol {
    
    private var context: NSManagedObjectContext
    
    init(){
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { description, error in
            if let error {
                print(error.localizedDescription)
            } else {
                print("Database url - ", description.url?.absoluteString ?? "")
            }
        }
        
        context = container.viewContext
    }
    
    func fetchVectors() -> [VectorEntity] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: VectorEntity.self))
        do {
            return try context.fetch(request) as! [VectorEntity]
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func createVector(
        uuid: UUID,
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double,
        name: String,
        color: UIColor) {
            guard let vectorEntityDescription = NSEntityDescription.entity(forEntityName: String(describing: VectorEntity.self), in: context) else {
                return
            }
            
            let vector = VectorEntity(entity: vectorEntityDescription, insertInto: context)
            vector.uuid = uuid
            vector.startX = startX
            vector.endX = endX
            vector.startY = startY
            vector.endY = endY
            vector.name = name
            vector.color = color
            
            saveContext()
    }
    
    func updateVector(
        uuid: UUID,
        updateAction: ((VectorEntity) -> Void)?) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: VectorEntity.self))
            do {
                guard let vectors = try? context.fetch(fetchRequest) as? [VectorEntity],
                      let vector = vectors.first(where: {$0.uuid == uuid}) else {
                    return
                }
                
                updateAction?(vector)
            }
    
            
            saveContext()
    }
    
    func deleteVector(uuid: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: VectorEntity.self))
        do {
            guard let vectors = try? context.fetch(fetchRequest) as? [VectorEntity],
                  let vector = vectors.first(where: {$0.uuid == uuid}) else {
                return
            }
            
            context.delete(vector)
        }
        
        saveContext()
    }
    
    private func saveContext() {
        let context = context
        if (context.hasChanges) {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError(error.localizedDescription)
            }
        }
    }
}
