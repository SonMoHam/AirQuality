//
//  CustomViewC.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/07.
//

import Foundation
import UIKit

class CustomViewC: UIView {
    
    var completionClosure: (() -> Void)?
    var delegate: CustomViewProtocol?
    
    @IBOutlet weak var pointALabel: UILabel!
    @IBOutlet weak var pointBLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        if let view = Bundle.main.loadNibNamed("CustomViewC", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            
            addSubview(view)
            
        }
    }
    @IBAction func onBackButtonClicked(_ sender: Any) {
        delegate?.sendCustomViewButtonIsClicked(buttonName: BUTTON_NAME.CUSTOM_VIEW_C.BACK)
        UIView.transition(with: self, duration: 1, options: [.transitionCrossDissolve], animations: {
            self.removeFromSuperview()
        }, completion: nil)
    }
}
