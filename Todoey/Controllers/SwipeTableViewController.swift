import UIKit
import SwipeCellKit
import RealmSwift

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var noDataYetLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        

    }
    
    //TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("delete cell")
            
            self.updateModel(at: indexPath)
            
            
            //tableView.reloadData()
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

    func updateModel(at indexPath: IndexPath){
        //update our data model
    }
    
    func prepareNoDataYetLabel(withMessage message: String) {
        var labelVPosition : CGFloat = tableView.rowHeight
        if let searchBarHeight = tableView.viewWithTag(1)?.frame.height {
    // If there is a search bar, take its height into account when calculating the UILabel y position.
        labelVPosition += searchBarHeight
        }
        noDataYetLabel = UILabel(frame: CGRect(x: 0, y: labelVPosition, width: tableView.frame.width, height: tableView.rowHeight))
        noDataYetLabel.text = message
        noDataYetLabel.textAlignment = .center
        noDataYetLabel.textColor = .gray
        noDataYetLabel.isHidden = true
        tableView.addSubview(noDataYetLabel)
    }
    func verifyRows(for list: Results<Category>?) -> Int {
        return verifyRows(withCount: list?.count)
    }
    func verifyRows(for list: Results<Item>?) -> Int {
        return verifyRows(withCount: list?.count)
    }
    private func verifyRows(withCount count: Int?) -> Int {
        if (count ?? 0 > 0) {
            noDataYetLabel.isHidden = true
            return count!
        }
        else {
            noDataYetLabel.isHidden = false
            return 0
        }
    }
}

