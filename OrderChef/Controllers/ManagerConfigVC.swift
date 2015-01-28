
import UIKit

class ManagerConfigVC: UITableViewController, TextFieldCellDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Configuration"
		
		self.tableView.registerNib(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "textField")
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		
		if self.navigationController == nil {
			self.tableView.backgroundColor = mainColour
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		saveSettings()
		storage.setSettings({ (err: NSError?) -> Void in
			if err != nil {
				SVProgressHUD.showErrorWithStatus(err!.description)
			}
		})
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 2
		}
		
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			var cell: TextFieldCell? = tableView.dequeueReusableCellWithIdentifier("textField", forIndexPath: indexPath) as? TextFieldCell
			if cell == nil {
				cell = TextFieldCell(style: UITableViewCellStyle.Default, reuseIdentifier: "textField")
			}
			
			if indexPath.row == 0 {
				cell!.label.text = "Venue name:"
				cell!.field.text = storage.venue_name
			} else if indexPath.row == 1 {
				cell!.label.text = "Server IP:"
				cell!.field.text = storage.server_ip
			}
			
			cell!.delegate = self
			cell!.setup()
			
			return cell!
		} else {
			var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? UITableViewCell
			if cell == nil {
				cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
			}
			
			cell!.textLabel!.text = "Set Up"
			cell!.textLabel!.textAlignment = .Center
			
			return cell!
		}
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 1 {
			var url: NSURL?
			if storage.server_ip != nil {
				url = NSURL(string: storage.server_ip! + "/api/ping")
			}
			
			if url == nil {
				SVProgressHUD.showErrorWithStatus("Server IP Invalid")
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
				return
			}
			
			SVProgressHUD.showProgress(0.0, status: "Testing server")
			
			doRequest(NSMutableURLRequest(URL: url!), { (err: NSError?, data: AnyObject?) -> Void in
				if err != nil {
					SVProgressHUD.showErrorWithStatus("Server Not Responding")
					tableView.deselectRowAtIndexPath(indexPath, animated: true)
					return
				}
				
				SVProgressHUD.dismiss()
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
				
				if self.navigationController == nil {
					// we're not presented inside managerVC
					var delegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
					delegate.setRootVC()
				}
			}, nil)
		}
	}
	
	//MARK: TextFieldCellDelegate
	
	func TextFieldCellDidChangeValue(cell: UITableViewCell, value: String) {
		var indexPath = self.tableView.indexPathForCell(cell)
		
		if indexPath!.row == 0 {
			storage.venue_name = value
		} else if indexPath!.row == 1 {
			storage.server_ip = value
		}
	}
	
}
