//
//  ViewController.swift
//  CoreDataMariyaHW
//
//  Created by Мария  on 6.12.22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var storage =  Storage()
    var person :[Person] = []
    var fetchVC : NSFetchedResultsController<Person>? = nil
    let tableViewData =  UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewData.frame = self.view.bounds
        view.addSubview(tableViewData)
        
        tableViewData.delegate =  self
        tableViewData.dataSource =  self
        
        storage.createUser("Ivan", "Ivanov", Date(timeIntervalSince1970: 10000000))
        storage.createUser("Vasiliy", "Abramov", Date())
        storage.createUser("Olga", "Kuznetsova", Date(timeIntervalSinceNow: 10000000))
        storage.createUser("Tolya", "Popov", Date(timeIntervalSinceNow: 5000000))
        storage.createUser("Oleg", "Bobrov", Date())
        storage.createUser("Larisa", "Guzeeva", Date(timeIntervalSince1970: 33333333))
        storage.createUser("Timur", "Antonov", Date())
        storage.createUser("Boris", "Ignatov", Date(timeIntervalSince1970: 1234456))
        storage.createUser("Omar", "Krabov", Date(timeIntervalSinceNow: 1233333234))
        storage.createUser("Krab", "Omarov", Date())
//
        
        person = storage.readUser()
//        for i in person {
//            storage.deleteUser(i)
//        }

        fetchVC = storage.frc()
    }
    func configureCell(cell: UITableViewCell, withObject person: Person) {
        cell.textLabel?.text = (person.name ?? "")  + " " + (person.surname ?? "") 
        cell.detailTextLabel?.text = "\(person.birthday ?? Date())"
        }
}
extension  ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchVC?.sections else { return 0 }
                return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let persons = fetchVC?.object(at: indexPath) as! Person
        let cell = tableView.dequeueReusableCell(withIdentifier: "123") ?? UITableViewCell()
        configureCell(cell: cell, withObject: persons)
           return cell
        }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            storage.deleteUser(person[indexPath.row])
            }
        tableView.deleteRows(at: [indexPath], with: .middle)
        person.remove(at: indexPath.row)
            tableView.endUpdates()
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        }
    }

    
    


