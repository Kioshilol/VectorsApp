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
    
    func fetchVectors() -> [Vector] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Vector.self))
        do {
            return try context.fetch(request) as! [Vector]
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func saveVector(
        startX: Double,
        endX: Double,
        startY: Double,
        endY: Double,
        name: String,
        color: UIColor) {
            guard let vectorEntityDescription = NSEntityDescription.entity(forEntityName: "Vector", in: context) else {

                return
            }
            
            let vector = Vector(entity: vectorEntityDescription, insertInto: context)
            vector.startX = startX
            vector.endX = endX
            vector.startY = startY
            vector.endY = endY
            vector.name = name
            vector.color = color
            
            saveContext()
    }
    
    private func saveContext(){
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
