//
//  Storage.swift
//  CoreDataMariyaHW
//
//  Created by Мария  on 6.12.22.
//


import CoreData
class Storage {
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataMariyaHW")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createUser(_ name: String,_ surname : String, _ birthday: Date){
        let person = Person(context: persistentContainer.viewContext)
        //        user.managedObjectContext
        person.name = name
        person.birthday = birthday
        person.surname =  surname
        
        do {
            try persistentContainer.viewContext.save()
        }catch {
            persistentContainer.viewContext.rollback()
            print("viewContext didnt save")
        }
    }
    func readUser()->[Person] {
        let fetchRequest =  Person.fetchRequest()
        do {
            return try  persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            persistentContainer.viewContext.rollback()
            print("viewContext didnt save")
            return []
        }
    }
    func updateUser(){
        do {
            try  persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("viewContext didnt save")
        }
    }
    func deleteUser(_ person : Person){
        persistentContainer.viewContext.delete(person)
        do {
            try  persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("viewContext didnt save")
        }
    }
    func frc()-> NSFetchedResultsController<Person>{
        let context = persistentContainer.viewContext
        let fetchRequest = Person.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Person.name, ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return controller
    }
    
    
}
