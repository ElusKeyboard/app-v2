class OrderTypesViewCtrl: UITableViewController, RefreshDelegate {
	var pickForOrder: Order!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		AppDelegate.registerCommonCellsForTable(self.tableView)
		
		self.navigationItem.title = "Order Types"
		self.navigationItem.title = "Select Order Type"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "dismiss")
	}
	
	func reloadData(sender: AnyObject?) {
		storage.updateOrderTypes({ (err: NSError?) -> Void in
			self.refreshControl!.endRefreshing()
			if err != nil {
				return SVProgressHUD.showErrorWithStatus(err!.description)
			}
			
			self.tableView.reloadData()
		})
	}
	
	func dismiss() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.order_types.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let order_type = storage.order_types[indexPath.row]
		
		self.pickForOrder!.type = order_type
		self.pickForOrder!.type_id = order_type.id!
		
		return self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let order_type: OrderType = storage.order_types[indexPath.row]
		var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("basic", forIndexPath: indexPath) as? UITableViewCell
		if cell == nil {
			cell = UITableViewCell(style: .Default, reuseIdentifier: "basic")
		}
		
		cell!.accessoryType = .DisclosureIndicator
		cell!.textLabel!.text = order_type.name
		
		return cell!
	}
}