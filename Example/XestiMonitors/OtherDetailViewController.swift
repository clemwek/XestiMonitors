//
//  OtherDetailViewController.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XestiMonitors

class OtherDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var keyboardActionLabel: UILabel!
    @IBOutlet weak var keyboardAnimationCurveLabel: UILabel!
    @IBOutlet weak var keyboardAnimationDurationLabel: UILabel!
    @IBOutlet weak var keyboardFrameBeginLabel: UILabel!
    @IBOutlet weak var keyboardFrameEndLabel: UILabel!
    @IBOutlet weak var keyboardIsLocalLabel: UILabel!
    @IBOutlet weak var keyboardTextField: UITextField!

    lazy var keyboardMonitor: KeyboardMonitor = { KeyboardMonitor { self.displayKeyboard($0) } }()

    lazy var monitors: [Monitor] = { [self.keyboardMonitor] }()

    // MARK: -

    private func displayKeyboard(_ event: KeyboardMonitor.Event?) {

        if let event = event {

            switch event {

            case let .didChangeFrame(info):
                displayKeyboard("Did change frame", info)

            case let .didHide(info):
                displayKeyboard("Did hide", info)

            case let .didShow(info):
                displayKeyboard("Did show", info)

            case let .willChangeFrame(info):
                displayKeyboard("Will change frame", info)

            case let .willHide(info):
                displayKeyboard("Will hide", info)

            case let .willShow(info):
                displayKeyboard("Will show", info)

            }

        } else {

            displayKeyboard(" ", nil)

        }

    }

    private func displayKeyboard(_ action: String,
                                 _ info: KeyboardMonitor.Info?) {

        if let info = info {

            keyboardAnimationCurveLabel.text = "\(formatAnimationCurve(info.animationCurve))"

            keyboardAnimationDurationLabel.text = "\(info.animationDuration)"

            keyboardFrameBeginLabel.text = "\(info.frameBegin)"

            keyboardFrameEndLabel.text = "\(info.frameEnd)"

            keyboardIsLocalLabel.text = "\(info.isLocal)"

        } else {

            keyboardAnimationCurveLabel.text = " "

            keyboardAnimationDurationLabel.text = " "

            keyboardFrameBeginLabel.text = " "

            keyboardFrameEndLabel.text = " "

            keyboardIsLocalLabel.text = " "

        }

        keyboardActionLabel.text = action

    }

    private func formatAnimationCurve(_ animationCurve: UIViewAnimationCurve) -> String {

        switch animationCurve {

        case .easeIn:
            return "Ease in"

        case .easeInOut:
            return "Ease in/out"

        case .easeOut:
            return "Ease out"

        case .linear:
            return "Linear"

        }
    }

    // MARK: -

    override func viewDidLoad() {

        super.viewDidLoad()

        keyboardTextField.delegate = self

        displayKeyboard(nil)

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        monitors.forEach { $0.beginMonitoring() }

    }

    override func viewWillDisappear(_ animated: Bool) {

        monitors.forEach { $0.endMonitoring() }

        super.viewWillDisappear(animated)

    }

    // MARK: -

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.text = ""

        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }

        return false

    }

}
