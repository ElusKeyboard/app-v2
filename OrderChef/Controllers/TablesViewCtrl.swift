
import UIKit

class TablesViewCtrl: UITableViewController, RefreshDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		AppDelegate.setupRefreshControl(self)
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " " + NSString.fontAwesomeIconStringForEnum(FAIcon.FATasks), style: UIBarButtonItemStyle.Plain, target: self, action: "openManager")
		self.navigationItem.leftBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationItem.title = storage.venue_name
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData:", name: "didInit", object: nil)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		NSNotificationCenter.defaultCenter().removeObserver(self, name: "didInit", object: nil)
	}
	
	func reloadData(sender: AnyObject?) {
		self.navigationItem.title = storage.venue_name
		self.refreshControl!.endRefreshing()
		self.tableView.reloadData()
	}
	
	func openManager() {
		var vc = ManagerViewCtrl(nibName: "PlainView", bundle: nil)
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
		var vc = OrderGroupViewCtrl(nibName: groupedTableNibName, bundle: nil)
		vc.table = storage.table_types[indexPath.section].tables[indexPath.row]
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
}
