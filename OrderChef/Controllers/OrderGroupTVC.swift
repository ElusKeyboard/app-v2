
import UIKit

class OrderGroupTVC: UITableViewController {
	var sortedTable: SortedTable! // usually from previous vc.
	var table: Table! // actual table.
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = self.table.name
	}
}
