
import UIKit

protocol SwitchCellDelegate {
	func switchCellDidToggle(cell: SwitchViewCell, isOn: Bool)
}

class SwitchViewCell: UITableViewCell {
	
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var toggle: UISwitch!
	
	var delegate: SwitchCellDelegate?
	
	func setup() {
		self.toggle.addTarget(self, action: "didToggle:", forControlEvents: UIControlEvents.ValueChanged)
	}
	
	func didToggle(sender: AnyObject?) {
		if self.delegate == nil {
			return
		}
		
		self.delegate!.switchCellDidToggle(self, isOn: self.toggle.on)
	}
	
}
