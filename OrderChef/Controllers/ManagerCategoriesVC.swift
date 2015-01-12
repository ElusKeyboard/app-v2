
import UIKit

class ManagerCategoriesVC: UITableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Categories"
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl!.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
		
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "basic")
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FAPlus) + " ", style: UIBarButtonItemStyle.Plain, target: self, action: "addCategory")
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
		
		self.refreshData()
	}
	
	func refreshData() {
		storage.updateCategories({ (err: NSError?) -> Void in
			self.refreshControl!.endRefreshing()
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableView.reloadData()
		})
	}
	
	func addCategory() {
		var vc = ManagerCategoryVC(nibName: "ManagerCategoryVC", bundle: nil)
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.categories.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let category: Category = storage.categories[indexPath.row]
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "basic")
		}
		
		cell!.textLabel!.text = category.name
		
		return cell!
	}
}
