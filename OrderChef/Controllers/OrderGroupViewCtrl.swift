
import UIKit

class OrderGroupViewCtrl: UITableViewController, RefreshDelegate {
	var table: Table! // actual table.
	
	var orderGroup: OrderGroup!
	var orders: [Order] = []
	var newOrder: Order?
	
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
				
				self.orders = orders
				
				for (i, order) in enumerate(self.orders) {
					var numOrders = order.order_items.count
					order.getItems({ (err: NSError?) -> Void in
						self.tableView.reloadData()
					})
				}
				
				SVProgressHUD.dismiss()
				self.tableView.reloadData()
				self.refreshControl!.endRefreshing()
			})
		})
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if self.newOrder != nil {
			// add order to group
			if self.newOrder!.type_id == nil || self.newOrder!.type_id == 0 {
				// cancelled or not picked
				self.newOrder = nil
				return
			}
			
			self.orderGroup.addOrder(self.newOrder!, callback: { (err: NSError?) -> Void in
				if err != nil {
					SVProgressHUD.showErrorWithStatus(err!.description)
					return
				}
				
				SVProgressHUD.showSuccessWithStatus("Adding Order..")
				self.reloadData(nil)
			})
			
			self.newOrder = nil
		}
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.orders.count + 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		
		return self.orders[section - 1].order_items.count
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
		
		let order = self.orders[indexPath.section - 1]
		let orderItem = order.order_items[indexPath.row]
		
		cell!.textLabel!.text = orderItem.item.name
		
		return cell!
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			// Create order.
			var vc = OrderTypesViewCtrl(nibName: plainTableNibName, bundle: nil)
			
			self.newOrder = Order()
			self.newOrder!.group = self.orderGroup
			self.newOrder!.group_id = self.orderGroup.id!
			vc.pickForOrder = self.newOrder
			
			var nvc = UINavigationController(rootViewController: vc)
			self.presentViewController(nvc, animated: true, completion: nil)
			
			return
		}
		
		let order = self.orders[indexPath.section - 1]
		
		let vc = EditOrderItemViewCtrl(nibName: groupedTableNibName, bundle: nil)
		vc.order = order
		vc.item = order.order_items[indexPath.row]
		self.navigationController!.pushViewController(vc, animated: true)
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
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let text = self.tableView(tableView, titleForHeaderInSection: section)
		if text == nil {
			return nil
		}
		
		var view = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, tableView.sectionHeaderHeight))
		
		var label = UILabel(frame: CGRectMake(15, 15, view.frame.size.width - 15 * 2, 16))
		label.backgroundColor = UIColor.clearColor()
		label.textColor = UIColor.grayColor()
		label.font = UIFont.systemFontOfSize(13)
		label.text = text!.uppercaseString
		label.userInteractionEnabled = true
		label.tag = section
		
		var tap = UITapGestureRecognizer(target: self, action: "didTouchHeader:")
		label.addGestureRecognizer(tap)
		
		view.addSubview(label)
		
		return view
	}
	
	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 0 {
			return self.orders.count == 0 ? "Empty order." : nil
		}
		
		let order = self.orders[section - 1]
		if order.type == nil {
			return nil
		}
		
		return order.type.description
	}
	
	func didTouchHeader(tap: UITapGestureRecognizer) {
		let section = tap.view!.tag
		var vc = OrderDetailsViewCtrl(nibName: groupedTableNibName, bundle: nil)
		vc.order = self.orders[section - 1]
		vc.orderGroup = self.orderGroup
		self.navigationController!.pushViewController(vc, animated: true)
	}
}
