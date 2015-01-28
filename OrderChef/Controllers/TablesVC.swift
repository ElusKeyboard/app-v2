
import UIKit

class TablesVC: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl!.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
		
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "basic")
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " " + NSString.fontAwesomeIconStringForEnum(FAIcon.FATasks), style: UIBarButtonItemStyle.Plain, target: self, action: "openManager")
		self.navigationItem.leftBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationItem.title = storage.venue_name
	}
	
	func refreshData(sender: AnyObject?) {
		self.refreshControl!.endRefreshing()
		self.tableView.reloadData()
	}
	
	func openManager() {
		var vc: ManagerVC = ManagerVC(nibName: "ManagerVC", bundle: nil)
		var nvc: UINavigationController = UINavigationController(rootViewController: vc)
		
		self.presentViewController(nvc, animated: true, completion: nil)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return storage.table_types.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.table_types[section].tables.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		let table = storage.table_types[indexPath.section].tables[indexPath.row]
		
		cell!.textLabel!.text = table.name
		
		return cell!
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return storage.table_types[section].name
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var vc: OrderGroupVC = OrderGroupVC(nibName: "OrderGroupVC", bundle: nil)
		vc.table = storage.table_types[indexPath.section].tables[indexPath.row]
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
}
