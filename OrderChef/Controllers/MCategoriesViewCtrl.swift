
import UIKit

class MCategoriesViewCtrl: UITableViewController, RefreshDelegate {
	
	var pickingForItem: Item?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Categories"
		
		AppDelegate.setupRefreshControl(self)
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FAPlus) + " ", style: UIBarButtonItemStyle.Plain, target: self, action: "addCategory")
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
		
		self.reloadData(nil)
	}
	
	func reloadData(sender: AnyObject?) {
		storage.updateCategories({ (err: NSError?) -> Void in
			self.refreshControl!.endRefreshing()
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableView.reloadData()
		})
	}
	
	func addCategory() {
		var vc = MCategoryViewCtrl(nibName: groupedTableNibName, bundle: nil)
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.categories.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let category = storage.categories[indexPath.row]
		
		if self.pickingForItem != nil {
			self.pickingForItem!.category = category
			self.pickingForItem!.category_id = category.id!
			
			tableView.reloadData()
			self.navigationController!.popViewControllerAnimated(true)
			return
		}
		
		var vc = MCategoryViewCtrl(nibName: groupedTableNibName, bundle: nil)
		vc.category = category
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let category: Category = storage.categories[indexPath.row]
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		if self.pickingForItem != nil {
			cell!.accessoryType = .None
			
			if category.id != nil && self.pickingForItem!.category_id == category.id! {
				cell!.accessoryType = .Checkmark
			}
		}
		
		cell!.textLabel!.text = category.name
		
		return cell!
	}
	
}
