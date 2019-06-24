//
//  ListTableViewController.swift
//  Assessment2take2
//
//  Created by Drew Seeholzer on 6/23/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        ListController.sharedInstance.fetchedResultsController.delegate = self
        //updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }


    @IBAction func addButtonTapped(_ sender: Any) {
        
            let alertController = UIAlertController(title: "Add item", message: "What do you want to add?", preferredStyle: .alert)
        alertController.addTextField { (_) in

        }
        let addItem = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemName = alertController.textFields?[0].text else { return }
            ListController.sharedInstance.add(itemWithName: itemName)
        }
        let dismissAlert = UIAlertAction(title: "Dismiss", style: .destructive)
        alertController.addAction(addItem)
        alertController.addAction(dismissAlert)

        present(alertController, animated: true)
        //setNeedsStatusBarAppearanceUpdate()
    }
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ListController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ListController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }
        
        let item = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        cell.update(withItem: item)
        cell.delegate = self

        // Configure the cell...

        return cell
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        ListController.sharedInstance.delete(item: item)
        }    
    }
}

extension ListTableViewController: ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        let item = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        
        ListController.sharedInstance.toggleIsCheckedFor(item: item)
        sender.update(withItem: item)
    }
}

extension ListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject:
        Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { break }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .automatic)

        @unknown default:
            fatalError()
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        @unknown default:
            fatalError()
        }
    }
}
