
import UIKit

class MModifierSingleViewCtrl: UITableViewController, TextFieldCellDelegate {
	
	// DO NOT forget to set the group_id property!
	var modifier: ConfigModifier = ConfigModifier()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Add Modifier"
		if modifier.id != nil {
			self.navigationItem.title = "Update Modifier"
		}
		
		AppDelegate.registerCommonCellsForTable(self.tableView)
	}
	
	func didEdit() {
		self.navigationItem.setHidesBackButton(true, animated: true)
		
		var attributes = AppDelegate.makeFontAwesomeTextAttributesOfFontSize(20)
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: " " + NSString.fontAwesomeIconStringForEnum(FAIcon.FATimes), style: .Plain, target: self, action: "cancel")
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSString.fontAwesomeIconStringForEnum(FAIcon.FACheck) + " ", style: .Plain, target: self, action: "save")
		
		self.navigationItem.leftBarButtonItem!.setTitleTextAttributes(attributes, forState: .Normal)
		self.navigationItem.rightBarButtonItem!.setTitleTextAttributes(attributes, forState: .Normal)
	}
	
	func cancel() {
		self.navigationController!.popViewControllerAnimated(true)
	}
	
	func save() {
		self.modifier.save({ (err: NSError?) -> Void in
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.navigationController!.popViewControllerAnimated(true)
		})
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.modifier.id == nil ? 2 : 3
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			var cell: TextFieldCell? = tableView.dequeueReusableCellWithIdentifier("textField", forIndexPath: indexPath) as? TextFieldCell
			if cell == nil {
				cell = TextFieldCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textField")
			}
			
			cell!.label.text = "Name:"
			cell!.field.text = self.modifier.name
			cell!.field.keyboardType = .Default
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else if indexPath.section == 1 {
			var cell: TextFieldCell? = tableView.dequeueReusableCellWithIdentifier("textField", forIndexPath: indexPath) as? TextFieldCell
			if cell == nil {
				cell = TextFieldCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textField")
			}
			
			cell!.label.text = "Price:"
			cell!.field.text = String(format: "%.2f", self.modifier.price)
			cell!.field.keyboardType = UIKeyboardType.DecimalPad
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			
			cell!.textLabel!.text = "Delete"
			cell!.textLabel!.textAlignment = .Center
			
			return cell!
		}
	}
	
	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 1 {
			return "Price will affect item price. Can be positive or negative. Negative price reduces item price"
		}
		
		return nil
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 2 {
			// Delete
			self.modifier.remove({ (err: NSError?) -> Void in
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
				
				if err != nil {
					return SVProgressHUD.showErrorWithStatus(err!.description)
				}
				
				self.navigationController!.popViewControllerAnimated(true)
			})
		}
	}
	
	// MARK: TextFieldCellDelegate
	
	func TextFieldCellDidChangeValue(cell: UITableViewCell, value: String) {
		self.didEdit()
		
		var indexPath = self.tableView.indexPathForCell(cell)
		
		if indexPath!.section == 0 {
			self.modifier.name = value
		} else if indexPath!.section == 1 {
			var formatter = NSNumberFormatter()
			formatter.numberStyle = .DecimalStyle
			
			var number = formatter.numberFromString(value)
			if number != nil {
				self.modifier.price = number!.floatValue
			} else {
				SVProgressHUD.showErrorWithStatus("Price Invalid")
			}
		}
	}
	
}
