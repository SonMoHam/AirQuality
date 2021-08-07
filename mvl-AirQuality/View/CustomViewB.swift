//
//  CustomViewB.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/07.
//

import Foundation
import UIKit

class CustomViewB: UIView {
    @IBOutlet weak var setButton: UIButton!
    var myClosure: (() -> Void)?
    var delegate: CustomViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        if let view = Bundle.main.loadNibNamed("CustomViewB", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            
            addSubview(view)
            
        }
    }
    @IBAction func onSetButtonClicked(_ sender: Any) {
        if let closure = self.myClosure {
            closure()
        }
        delegate?.sendCustomViewButtonIsClicked(buttonName: BUTTON_NAME.CUSTOM_VIEW_B.SET)
        UIView.transition(with: self, duration: 1, options: [.transitionCrossDissolve], animations: {
            self.removeFromSuperview()
        }, completion: nil)

    }
}
