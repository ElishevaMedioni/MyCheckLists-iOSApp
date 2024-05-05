
import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    //Results is from realm library
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
        super.prepareNoDataYetLabel(withMessage: "No Categories Added Yet")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller doesn't exists")
        }
        let navBarAppearance = UINavigationBarAppearance()
        
        
        navBarAppearance.backgroundColor = FlatWhite()
        
        navBar.standardAppearance = navBarAppearance
        navBar.scrollEdgeAppearance = navBarAppearance
        
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return super.verifyRows(for: categories)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //if there is no categories in my list - i return 1 cell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added yet"
        
        if let colorHexString = categories?[indexPath.row].color  {
            
                cell.backgroundColor = UIColor(hexString: colorHexString)
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: colorHexString)!, returnFlat: true)
            }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    //delegate when we click on a cell 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch{
            print("error saving context \(error)")
        }
       
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categorySelected = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categorySelected)
            
                }
            } catch {
                print("error deleting category, \(error)")
            }
        }
    }
    
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen when the user clicks the Add button on our UIAlert
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            let colorArray = [FlatSand(), FlatPowderBlue().lighten(byPercentage: 0.1)!, FlatWatermelon().lighten(byPercentage: 0.2)!, FlatSkyBlue().lighten(byPercentage: 0.3)!, FlatLime().lighten(byPercentage: 0.4)!,FlatMint().lighten(byPercentage: 0.5)!, FlatGreen().lighten(byPercentage: 0.6)!, FlatMagenta().lighten(byPercentage: 0.7)!,FlatPurple().lighten(byPercentage: 0.8)!, FlatRed().lighten(byPercentage: 0.9)!]
            
            newCategory.color = (UIColor(randomColorIn: colorArray)?.hexValue())!
        
            
            self.save(category: newCategory)
        }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "create new category"
                textField = alertTextField
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        
    }
   
}
