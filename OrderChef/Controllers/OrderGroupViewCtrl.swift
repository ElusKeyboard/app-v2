
import UIKit

class OrderGroupViewCtrl: UITableViewController, RefreshDelegate {
	var table: Table! // actual table.
	
	var orderGroup: OrderGroup!
	var orders: [Order] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		AppDelegate.setupRefreshControl(self)
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.title = self.table.name
		
		self.reloadData(nil)
	}
	
	func reloadData(sender: AnyObject?) {
		self.table.getGroup({ (err: NSError?, group: OrderGroup?) -> Void in
			if err != nil {
				SVProgressHUD.showErrorWithStatus(err!.description)
				self.refreshControl!.endRefreshing()
				
				return
			}
			
			self.orderGroup = group
			self.orderGroup.getOrders({ (err: NSError?, orders: [Order]) -> Void in
				if err != nil {
					SVProgressHUD.showErrorWithStatus(err!.description)
					self.refreshControl!.endRefreshing()
					
					return
				}
				
				self.tableView.reloadData()
				self.refreshControl!.endRefreshing()
			})
		})
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.orders.count + 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		
		return self.orders[section - 1].order_items.count + 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		
		if indexPath.section == 0 {
			cell!.textLabel!.text = "Add Order"
			return cell!
		}
		
		if indexPath.row == 0 {
			cell!.textLabel!.text = "Add Item"
			return cell!
		}
		
		let order = self.orders[indexPath.section - 1]
		let orderItem = order.order_items[indexPath.row - 1].item
		
		cell!.textLabel!.text = orderItem.name
		
		return cell!
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			// Create order.
			
		}
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return nil
		}
		
		let order = self.orders[section - 1]
		if order.type == nil {
			return nil
		}
		
		return order.type.name
	}
}
