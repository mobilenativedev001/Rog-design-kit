// UIKit compatibility helpers and wrappers

import Foundation
import UIKit
import Components
import Tokens

public final class RDSButtonFactory {
    public static func makePrimaryButton(title: String, target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = RDSToken.Color.primary
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
