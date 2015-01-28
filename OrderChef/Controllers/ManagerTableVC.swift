
import UIKit

class ManagerTableVC: UITableViewController, TextFieldCellDelegate {
	
	var table: Table = Table()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Add Table"
		if self.table.id != nil {
			self.navigationItem.title = "Update Table"
		}
		
		self.tableView.registerNib(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "textField")
		self.tableView.registerNib(UINib(nibName: "TextViewCell", bundle: nil), forCellReuseIdentifier: "textView")
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableType")
	}
	
	func didEdit() {
		self.navigationItem.setHidesBackButton(true, animated: true)
		
		var attributes = AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " " + NSString.fontAwesomeIconStringForEnum(FAIcon.FATimes), style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FACheck) + " ", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
		
		self.navigationItem.leftBarButtonItem!.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
	}
	
	func cancel() {
		self.navigationController!.popViewControllerAnimated(true)
	}
	
	func save() {
		self.table.save({ (err: NSError?) -> Void in
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.navigationController!.popViewControllerAnimated(true)
		})
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.table.id == nil ? 2 : 3
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 3
		}
		
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			var cell: TextFieldCell? = tableView.dequeueReusableCellWithIdentifier("textField", forIndexPath: indexPath) as? TextFieldCell
			if cell == nil {
				cell = TextFieldCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textField")
			}
			
			switch indexPath.row {
			case 0:
				cell!.label.text = "Name:"
				cell!.field.text = self.table.name
			case 1:
				cell!.label.text = "Table Number:"
				cell!.field.text = self.table.table_number
			case 2:
				cell!.label.text = "Location:"
				cell!.field.text = self.table.location
			default:
				break
			}
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else if indexPath.section == 1 {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("tableType", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Value1, reuseIdentifier: "tableType")
			}
			
			cell!.textLabel!.text = "Table Type"
			
			cell!.textLabel!.textAlignment = .Left
			cell!.accessoryType = .DisclosureIndicator
			
			return cell!
		} else {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
			}
			
			cell!.textLabel!.text = "Delete"
			cell!.textLabel!.textAlignment = .Center
			
			return cell!
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 1 {
			// Pick table type
			var vc: ManagerTableTypesVC = ManagerTableTypesVC(nibName: "ManagerTableTypesVC", bundle: nil)
			vc.pickingForTable = table
			
			self.navigationController!.pushViewController(vc, animated: true)
		} else if indexPath.section == 2 {
			// Delete
			table.remove({ (err: NSError?) -> Void in
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
				
				if err != nil {
					return SVProgressHUD.showErrorWithStatus(err!.description)
				}
				
				self.navigationController!.popViewControllerAnimated(true)
			})
		}
	}
	
	//MARK: TextFieldCellDelegate
	
	func TextFieldCellDidChangeValue(cell: UITableViewCell, value: String) {
		self.didEdit()
		
		var indexPath = self.tableView.indexPathForCell(cell)
		
		if indexPath!.row == 0 {
			self.table.name = value
		} else if indexPath!.row == 1 {
			self.table.table_number = value
		} else if indexPath!.row == 2 {
			self.table.location = value
		}
	}
	
}
