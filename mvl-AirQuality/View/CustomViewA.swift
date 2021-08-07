//
//  CustomViewA.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/07.
//

import Foundation
import UIKit

class CustomViewA: UIView {

    @IBOutlet weak var pointALabel: UILabel!
    @IBOutlet weak var pointBLabel: UILabel!
    

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
        if let view = Bundle.main.loadNibNamed("CustomViewA", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
    }
    


    
    
    @IBAction func onSetPointAButtonClicked(_ sender: Any) {
        delegate?.sendCustomViewButtonIsClicked(buttonName: BUTTON_NAME.CUSTOM_VIEW_A.POINT_A)
        UIView.transition(with: self, duration: 1, options: [.transitionCrossDissolve], animations: {
            self.removeFromSuperview()
        }, completion: nil)
    }
    
    @IBAction func onSetPointBButtonClicked(_ sender: Any) {
        delegate?.sendCustomViewButtonIsClicked(buttonName: BUTTON_NAME.CUSTOM_VIEW_A.POINT_B)
        UIView.transition(with: self, duration: 1, options: [.transitionCrossDissolve], animations: {
            self.removeFromSuperview()
        }, completion: nil)
    }
    
    @IBAction func onClearButtonClicked(_ sender: Any) {
        delegate?.sendCustomViewButtonIsClicked(buttonName: BUTTON_NAME.CUSTOM_VIEW_A.CLEAR)
        UIView.transition(with: self, duration: 1, options: [.transitionCrossDissolve], animations: {
            self.removeFromSuperview()
        }, completion: nil)
    }
}


