
import UIKit

class AddItemToOrderViewCtrl: UITableViewController, RefreshDelegate {
	
	var order: Order!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Items"
		
		AppDelegate.setupRefreshControl(self)
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
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
	
	func done() {
		self.navigationController!.popViewControllerAnimated(true)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return storage.categories.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.categories[section].items.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		// add Item to Order
		let item = storage.categories[indexPath.section].items[indexPath.row]
		self.order.addItem(item, callback: { (err: NSError?, orderItem: OrderItem?) -> Void in
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
			if err != nil {
				SVProgressHUD.showErrorWithStatus(err!.description)
				return
			}
			
			if item.modifiers.count > 0 {
				// pick modifiers
				let vc = SetOrderItemModifiersViewCtrl(nibName: groupedTableNibName, bundle: nil)
				
				self.navigationController!.pushViewController(vc, animated: true)
			}
			
			SVProgressHUD.showSuccessWithStatus("Added")
		})
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let item = storage.categories[indexPath.section].items[indexPath.row]
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		cell!.textLabel!.text = item.name
		
		return cell!
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return storage.categories[section].name
	}
	
}
