// A SwiftUI-first component example

import Foundation
import SwiftUI
import Tokens

public enum RDSButtonVariant {
    case primary
    case secondary
}
public struct RDSButton: View {
    public var title: String
    public var action: () -> Void
    public var variant: RDSButtonVariant;

    public init(title: String, action: @escaping () -> Void, variant: RDSButtonVariant = .primary) {
        self.title = title
        self.action = action
        self.variant = variant
    }

    public var body: some View {
        if variant == .primary {
            Button(action: action) {
                Text(title)
                    .foregroundColor(Color(UIColor.white))
                    .padding(.vertical, RDSToken.Spacing.medium)
                    .padding(.horizontal, RDSToken.Spacing.large)
                    .background(Color(RDSToken.Color.primary))
                    .cornerRadius(20)
            }
        } else if variant == .secondary {
            Button(action: action) {
                Text(title)
                    .foregroundColor(Color(RDSToken.Color.secondary))
                    .padding(.vertical, RDSToken.Spacing.medium)
                    .padding(.horizontal, RDSToken.Spacing.large)
                    .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(RDSToken.Color.secondary), lineWidth: 2)
                            )
            }
        }
    }
}

#if DEBUG
struct RDSButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            RDSButton(title: "Primary", action: {})
                .previewLayout(.sizeThatFits)
                .padding()
            RDSButton(title: "Secondary", action: {}, variant: .secondary)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
#endif
