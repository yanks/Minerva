//
//  Copyright © 2019 Optimize Fitness, Inc. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

public final class IconTextCellModel: BaseListCellModel, ListSelectableCellModel, ListBindableCellModel {

  public let iconImage = BehaviorSubject<UIImage?>(value: nil)

  public var labelLeadingMargin: CGFloat = 4
  public var backgroundColor: UIColor?

  public var imageColor: UIColor?
  public var imageContentMode: UIView.ContentMode = .scaleAspectFit

  public var textAlignment: NSTextAlignment = .left
  public var numberOfLines = 0
  public var textColor: UIColor?

  fileprivate var attributedText: NSAttributedString?

  fileprivate let imageWidth: CGFloat
  fileprivate let imageHeight: CGFloat
  fileprivate let text: String
  fileprivate let font: UIFont

  private let cellIdentifier: String

  public init(cellIdentifier: String, imageWidth: CGFloat, imageHeight: CGFloat, text: String, font: UIFont) {
    self.cellIdentifier = text
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
    self.text = text
    self.font = font
    super.init()
  }

  public convenience init(imageWidth: CGFloat, imageHeight: CGFloat, text: String, font: UIFont) {
    self.init(cellIdentifier: text, imageWidth: imageWidth, imageHeight: imageHeight, text: text, font: font)
  }

  public convenience init(imageWidth: CGFloat, imageHeight: CGFloat, attributedText: NSAttributedString, font: UIFont) {
    self.init(imageWidth: imageWidth, imageHeight: imageHeight, text: attributedText.string, font: font)
    self.attributedText = attributedText
  }

  // MARK: - BaseListCellModel

  override public var identifier: String {
    return cellIdentifier
  }

  override public func identical(to model: ListCellModel) -> Bool {
    guard let model = model as? Self, super.identical(to: model) else { return false }
    return labelLeadingMargin == model.labelLeadingMargin
      && imageColor == model.imageColor
      && imageContentMode == model.imageContentMode
      && textAlignment == model.textAlignment
      && numberOfLines == model.numberOfLines
      && textColor == model.textColor
      && attributedText == model.attributedText
      && imageWidth == model.imageWidth
      && imageHeight == model.imageHeight
      && text == model.text
      && font == model.font
  }

  // MARK: - ListSelectableCellModel
  public typealias SelectableModelType = IconTextCellModel
  public var selectionAction: SelectionAction?

  // MARK: - ListBindableCellModel
  public typealias BindableModelType = IconTextCellModel
  public var willBindAction: BindAction?
}

public final class IconTextCell: BaseReactiveListCell<IconTextCellModel> {

  private let buttonView = UIView()
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()

  private var labelLeadingConstraint: NSLayoutConstraint?
  private let label: UILabel = {
    let label = UILabel()
    label.adjustsFontForContentSizeCategory = true
    return label
  }()
  private var imageWidthConstraint: NSLayoutConstraint?
  private var imageHeightConstraint: NSLayoutConstraint?

  private var buttonLeadingConstraint: NSLayoutConstraint?
  private var buttonCenterConstraint: NSLayoutConstraint?
  private var buttonTrailingConstraint: NSLayoutConstraint?

  override public init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(buttonView)
    buttonView.addSubview(imageView)
    buttonView.addSubview(label)
    setupConstraints()
    backgroundView = UIView()
  }

  override public func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }

  override public func bind(model: IconTextCellModel, sizing: Bool) {
    super.bind(model: model, sizing: sizing)

    imageWidthConstraint?.constant = model.imageWidth
    imageHeightConstraint?.constant = model.imageHeight

    self.label.numberOfLines = model.numberOfLines
    if let attributedText = model.attributedText {
      self.label.attributedText = attributedText
    } else {
      self.label.text = model.text
      self.label.font = model.font
    }

    labelLeadingConstraint?.constant = model.labelLeadingMargin

    switch model.textAlignment {
    case .natural, .justified, .center:
      buttonLeadingConstraint?.isActive = false
      buttonCenterConstraint?.isActive = true
      buttonTrailingConstraint?.isActive = false
    case .left:
      buttonLeadingConstraint?.isActive = true
      buttonCenterConstraint?.isActive = false
      buttonTrailingConstraint?.isActive = false
    case .right:
      buttonLeadingConstraint?.isActive = false
      buttonCenterConstraint?.isActive = false
      buttonTrailingConstraint?.isActive = true
    @unknown default:
      assertionFailure("Unknown text alignment \(model.textAlignment)")
      buttonLeadingConstraint?.isActive = false
      buttonCenterConstraint?.isActive = false
      buttonTrailingConstraint?.isActive = false
    }

    label.textAlignment = model.textAlignment

    guard !sizing else { return }

    imageView.contentMode = model.imageContentMode
    imageView.tintColor = model.imageColor

    if model.attributedText == nil {
      label.textColor = model.textColor
    }

    self.backgroundView?.backgroundColor = model.backgroundColor

    model.iconImage.subscribe(onNext: { [weak self] in self?.imageView.image = $0 }).disposed(by: disposeBag)
  }
}

// MARK: - Constraints
extension IconTextCell {
  private func setupConstraints() {
    let layoutGuide = contentView.layoutMarginsGuide

    buttonView.anchor(toLeading: nil, top: layoutGuide.topAnchor, trailing: nil, bottom: layoutGuide.bottomAnchor)
    buttonView.leadingAnchor.constraint(greaterThanOrEqualTo: layoutGuide.leadingAnchor).isActive = true
    buttonView.trailingAnchor.constraint(lessThanOrEqualTo: layoutGuide.trailingAnchor).isActive = true

    buttonLeadingConstraint = buttonView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor)
    buttonCenterConstraint = buttonView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor)
    buttonTrailingConstraint = buttonView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)

    imageView.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor).isActive = true
    imageView.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor).isActive = true

    labelLeadingConstraint = label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor)
    labelLeadingConstraint?.isActive = true
    label.anchor(toLeading: nil, top: buttonView.topAnchor, trailing: nil, bottom: buttonView.bottomAnchor)
    label.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor).isActive = true

    imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 0)
    imageWidthConstraint?.isActive = true
    imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
    imageHeightConstraint?.isActive = true

    buttonView.shouldTranslateAutoresizingMaskIntoConstraints(false)

    contentView.shouldTranslateAutoresizingMaskIntoConstraints(false)
  }
}
