
import UIKit

class TablesTVC: UITableViewController {
	var tableList: [SortedTable] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl!.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
		
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "basic")
		
		self.navigationItem.title = "Venue Name.."
		self.refreshData(nil)
	}
	
	func refreshData(sender: AnyObject?) {
		Table.getTableList({ (err: NSError?, list: [SortedTable]) -> Void in
			self.refreshControl!.endRefreshing()
			
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableList = list
			self.tableView.reloadData()
		})
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.tableList.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.tableList[section].tables.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		let table = self.tableList[indexPath.section].tables[indexPath.row]
		
		cell!.textLabel!.text = table.name
		
		return cell!
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.tableList[section].type_name
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var vc: OrderGroupTVC = OrderGroupTVC(nibName: "OrderGroupTVC", bundle: nil)
		vc.sortedTable = self.tableList[indexPath.section]
		vc.table = vc.sortedTable.tables[indexPath.row]
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
}
