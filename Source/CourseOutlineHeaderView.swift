//
//  DownloadProgressView.swift
//  edX
//
//  Created by Akiva Leffert on 6/3/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import UIKit

public class CourseOutlineHeaderView: UIView {
    private let styles : OEXStyles
    
    private let verticalMargin = 3
    
    private let bottomDivider : UIView = UIView(frame: CGRect.zero)
    
    private let viewButton = UIButton(type: .system)
    private let messageView = UIView(frame: CGRect.zero)
    private let titleLabel = UILabel(frame: CGRect.zero)
    private let subtitleLabel = UILabel(frame: CGRect.zero)

    private var contrastColor : UIColor {
        return styles.neutralWhiteT()
    }
    
    private var labelStyle : OEXTextStyle {
        return OEXTextStyle(weight: .semiBold, size: .base, color: contrastColor)
    }
    
    private var subtitleLabelStyle : OEXTextStyle {
        return OEXTextStyle(weight: .normal, size: .base, color : contrastColor)
    }
    
    private var hasSubtitle : Bool {
        return !(subtitleLabel.text?.isEmpty ?? true)
    }
    
    public var subtitleText : String? {
        get {
            return subtitleLabel.text
        }
        set {
            subtitleLabel.attributedText = subtitleLabelStyle.attributedString(withText: newValue)
        }
    }
    
    public init(frame : CGRect, styles : OEXStyles, titleText : String? = nil, subtitleText : String? = nil) {
        self.styles = styles
        super.init(frame : frame)
        
        messageView.addSubview(titleLabel)
        messageView.addSubview(subtitleLabel)

        addSubview(messageView)
        addSubview(bottomDivider)
        addSubview(viewButton) // Keep this on top to catch taps anywhere in this view

        let buttonIcon = #imageLiteral(resourceName: "chevron_right").withRenderingMode(.alwaysTemplate)
        viewButton.setImage(buttonIcon, for: .normal)
        viewButton.tintColor = styles.accentAColor()
        viewButton.contentHorizontalAlignment = .trailing
        viewButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: StandardHorizontalMargin, bottom: 0, right: StandardHorizontalMargin)
        
        titleLabel.attributedText = labelStyle.attributedString(withText: titleText)
        subtitleLabel.attributedText = subtitleLabelStyle.attributedString(withText: subtitleText)
        
        backgroundColor = styles.primaryBaseColor()
        bottomDivider.backgroundColor = contrastColor
        
        bottomDivider.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.height.equalTo(OEXStyles.dividerSize())
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }
        
        viewButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing)
            make.leading.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }

        viewButton.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        
        messageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(StandardHorizontalMargin)
            make.trailing.lessThanOrEqualTo(viewButton.snp.trailing).offset(-StandardHorizontalMargin - buttonIcon.size.width - 10).priority(.high) // 10pt away from the button icon once the icon is positioned correctly
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(messageView)
            make.leading.equalTo(messageView)
            make.trailing.equalTo(messageView)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(messageView)
            make.leading.equalTo(messageView)
            make.trailing.equalTo(messageView)
        }

        setAccessibilityIdentifiers()
    }

    private func setAccessibilityIdentifiers() {
        accessibilityIdentifier = "CourseOutlineHeaderView:view"
        bottomDivider.accessibilityIdentifier = "CourseOutlineHeaderView:bottom-divider"
        viewButton.accessibilityIdentifier = "CourseOutlineHeaderView:view-button"
        messageView.accessibilityIdentifier = "CourseOutlineHeaderView:message-label"
        subtitleLabel.accessibilityIdentifier = "CourseOutlineHeaderView:subtitle-label"
    }
    
    public func setViewButtonAction(action: @escaping (AnyObject) -> Void) {
        viewButton.oex_removeAllActions()
        viewButton.oex_addAction(action, for: UIControl.Event.touchUpInside)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
