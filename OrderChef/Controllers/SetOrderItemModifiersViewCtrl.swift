
import UIKit

class SetOrderItemModifiersViewCtrl: UITableViewController, RefreshDelegate {
	
	var orderItem: OrderItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Modifiers"
		
		AppDelegate.setupRefreshControl(self)
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
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
	
	func getModifier(id: Int) -> ConfigModifierGroup? {
		for modifier in storage.modifiers {
			if modifier.id! == id {
				return modifier
			}
		}
		
		return nil
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.orderItem.item.modifiers.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let modifierGroup = self.getModifier(self.orderItem.item.modifiers[section])
		if modifierGroup == nil {
			return 0
		}
		
		return modifierGroup!.modifiers.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let modifierGroup = self.getModifier(self.orderItem.item.modifiers[indexPath.section])
		let modifier = modifierGroup!.modifiers[indexPath.row]
		
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		
		return cell!
	}
	
}
