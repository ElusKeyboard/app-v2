
import UIKit

class OrderDetailsViewCtrl: UITableViewController {
	
	var orderGroup: OrderGroup!
	var order: Order!
	var action_log: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.title = "Order Details"
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 5
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 0
		}
		
		if section == 1 || section == 2 {
			return 1
		}
		
		if section == 3 {
			return 3
		}
		
		return self.action_log.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			return cell!
		} else if indexPath.section == 1 {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			
			cell!.textLabel!.text = "Add item to order"
			cell!.accessoryType = .DisclosureIndicator
			
			return cell!
		} else if indexPath.section == 2 {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			
			cell!.textLabel!.text = "Order Type: " + self.order.type.name
			cell!.accessoryType = .DisclosureIndicator
			
			return cell!
		} else /*if indexPath.section == 2*/ {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			
			if indexPath.row == 0 {
				cell!.textLabel!.text = "Submit order"
			} else if indexPath.row == 1 {
				cell!.textLabel!.text = "Clear all items"
			} else {
				cell!.textLabel!.text = "Remove order"
			}
			
			cell!.accessoryType = .DisclosureIndicator
			
			return cell!
		}
		
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 1 {
			// Add Item to order
			let vc = AddItemToOrderViewCtrl(nibName: groupedTableNibName, bundle: nil)
			vc.order = order
			self.navigationController!.pushViewController(vc, animated: true)
			
			return
		}
		
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Notes"
		}
		
		return nil
	}
	
}
