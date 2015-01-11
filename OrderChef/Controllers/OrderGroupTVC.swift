
import UIKit

class OrderGroupTVC: UITableViewController {
	var sortedTable: SortedTable! // usually from previous vc.
	var table: Table! // actual table.
	
	var orderGroup: OrderGroup!
	var orders: [Order] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "basic")
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl!.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
		
		self.navigationItem.title = self.table.name
		
		self.refreshData()
	}
	
	func refreshData() {
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
		return self.orders.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.orders[section].order_items.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let orderItem = self.orders[indexPath.section].order_items[indexPath.row].item
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		
		if cell == nil {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "basic")
		}
		
		return cell!
	}
}
