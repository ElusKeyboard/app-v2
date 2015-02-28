
import UIKit

class MModifierViewCtrl: UITableViewController, RefreshDelegate, TextFieldCellDelegate, SwitchCellDelegate {
	
	var modifier = ConfigModifierGroup()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = modifier.name
		if modifier.id == nil {
			self.navigationItem.title = "New Modifier Group"
		}
		
		AppDelegate.setupRefreshControl(self)
		AppDelegate.registerCommonCellsForTable(self.tableView)
		tableView.registerNib(UINib(nibName: "SwitchViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.reloadData(nil)
	}
	
	func reloadData(sender: AnyObject?) {
		self.modifier.getModifiers({ (err: NSError?) -> Void in
			self.refreshControl!.endRefreshing()
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableView.reloadData()
		})
	}
	
	func didEdit() {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "save")
	}
	
	func save() {
		self.modifier.save({ (err: NSError?) -> Void in
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			SVProgressHUD.showSuccessWithStatus("Saved.")
			self.navigationItem.rightBarButtonItem = nil
		})
	}
	
	func add() {
		var vc = MItemViewCtrl(nibName: groupedTableNibName, bundle: nil)
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? 2 : modifier.modifiers.count + 1
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var vc = MModifierSingleViewCtrl(nibName: groupedTableNibName, bundle: nil)
		
		if indexPath.row != self.modifier.modifiers.count {
			vc.modifier = self.modifier.modifiers[indexPath.row]
		}
		
		vc.modifier.group_id = self.modifier.id!
		
		self.navigationController!.pushViewController(vc, animated: true)
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			if indexPath.row == 0 {
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
			} else {
				var cell: SwitchViewCell? = tableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath: indexPath) as? SwitchViewCell
				if cell == nil {
					cell = SwitchViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "switchCell")
				}
				
				cell!.label.text = "Optional Modifier"
				cell!.toggle.on = !self.modifier.choiceRequired
				cell!.delegate = self
				cell!.setup()
				
				return cell!
			}
		} else {
			if indexPath.row == self.modifier.modifiers.count {
				// add item cell
				var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
				if cell == nil {
					cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
				}
				
				cell!.textLabel!.text = "Add Modifier"
				cell!.textLabel!.textAlignment = .Center
				
				return cell!
			}
			
			let modifier = self.modifier.modifiers[indexPath.row]
			
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
			}
			
			cell!.accessoryType = .DisclosureIndicator
			cell!.textLabel!.text = modifier.name
			cell!.textLabel!.textAlignment = .Left
			
			return cell!
		}
	}
	
	// MARK: - Delegates
	
	// MARK: SwitchCellDelegate
	
	func switchCellDidToggle(cell: SwitchViewCell, isOn: Bool) {
		self.modifier.choiceRequired = !isOn
		self.didEdit()
	}
	
	// MARK: TextFieldDelegate
	
	func TextFieldCellDidChangeValue(cell: UITableViewCell, value: String) {
		self.modifier.name = value
		self.didEdit()
	}
	
}
