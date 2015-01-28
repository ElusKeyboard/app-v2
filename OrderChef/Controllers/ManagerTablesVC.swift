
import UIKit

class ManagerTablesVC: UITableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Tables"
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl!.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
		
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "basic")
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FAPlus) + " ", style: UIBarButtonItemStyle.Plain, target: self, action: "add")
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
		
		self.refreshData()
	}
	
	func refreshData() {
		storage.updateTables({ (err: NSError?) -> Void in
			self.refreshControl!.endRefreshing()
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableView.reloadData()
		})
	}
	
	func add() {
		var vc = ManagerTableVC(nibName: "ManagerTableVC", bundle: nil)
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.tables.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var vc = ManagerTableVC(nibName: "ManagerTableVC", bundle: nil)
		
		vc.table = storage.tables[indexPath.row]
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let table: Table = storage.tables[indexPath.row]
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		cell!.textLabel!.text = table.name
		
		return cell!
	}
}
