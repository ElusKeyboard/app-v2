
import UIKit

class ManagerTableTypesVC: UITableViewController {
	
	var pickingForTable: Table? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Table Types"
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl!.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
		
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "basic")
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FAPlus) + " ", style: UIBarButtonItemStyle.Plain, target: self, action: "add")
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20), forState: UIControlState.Normal)
		
		self.refreshData()
	}
	
	func refreshData() {
		storage.updateTableTypes({ (err: NSError?) -> Void in
			self.refreshControl!.endRefreshing()
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableView.reloadData()
		})
	}
	
	func add() {
		var vc = ManagerTableTypeVC(nibName: "ManagerTableTypeVC", bundle: nil)
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.table_types.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if self.pickingForTable != nil {
			self.pickingForTable!.table_type = storage.table_types[indexPath.row]
			self.pickingForTable!.table_type_id = self.pickingForTable!.table_type!.id!
			self.navigationController!.popViewControllerAnimated(true)
			
			return
		}
		
		var vc = ManagerTableTypeVC(nibName: "ManagerTableTypeVC", bundle: nil)
		vc.table_type = storage.table_types[indexPath.row]
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let table_type: TableType = storage.table_types[indexPath.row]
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		if self.pickingForTable != nil {
			if self.pickingForTable!.table_type != nil && self.pickingForTable!.table_type!.id == table_type.id {
				cell!.accessoryType = .Checkmark
			} else {
				cell!.accessoryType = .None
			}
		}
		
		cell!.textLabel!.text = table_type.name
		
		return cell!
	}
}
