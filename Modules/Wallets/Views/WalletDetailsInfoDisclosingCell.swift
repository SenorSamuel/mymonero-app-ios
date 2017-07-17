//
//  WalletDetailsInfoDisclosingCell.swift
//  MyMonero
//
//  Created by Paul Shapiro on 7/15/17.
//  Copyright © 2017 MyMonero. All rights reserved.
//

import UIKit

extension WalletDetails
{
	struct InfoDisclosing
	{
		class Cell: UICommonComponents.Tables.ReusableTableViewCell
		{
			override class func reuseIdentifier() -> String {
				return "UICommonComponents.Details.WalletDetails.InfoDisclosing.Cell"
			}
			override class func height() -> CGFloat {
				assert(false, "Intentionally not implemented")
				return 5
			}
			// Declared instead for consumer (tableView)
			var cellHeight: CGFloat {
				if self.isDisclosed {
					return self.contentContainerView.frame.size.height // rely on having been sized already
				} else { // start with constant since we might not be sized yet
					return WalletDetails.InfoDisclosing.ContentContainerView.height__closed
				}
			}
			//
			// Properties - Internally managed
			var contentContainerView: ContentContainerView
			var isDisclosed: Bool {
				return self.contentContainerView.isDisclosed
			}
			//
			// Lifecycle - Init
			init(wantsMnemonicDisplay: Bool)
			{
				self.contentContainerView = ContentContainerView(wantsMnemonicDisplay: wantsMnemonicDisplay)
				super.init()
			}
			required init?(coder aDecoder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
			}
			required init() {
				fatalError("init() has not been implemented, use init(wantsMnemonicDisplay:) instead, which calls super.init()")
			}
			override func setup()
			{
				super.setup()
				do {
					self.layer.masksToBounds = true // minor detail… :)
					self.selectionStyle = .none
					self.backgroundColor = UIColor.contentBackgroundColor
				}
				do {
					let view = self.contentContainerView
					self.contentView.addSubview(view)
				}
			}
			//
			// Overrides
			override func layoutSubviews()
			{
				super.layoutSubviews()
			}
			override func _configureUI()
			{
				let configuration = self.configuration!
				let wallet = configuration.dataObject as? Wallet
				if wallet == nil {
					assert(false)
					return
				}
				if wallet!.didFailToInitialize_flag == true || wallet!.didFailToBoot_flag == true {
					return
				} else {
					self.contentContainerView.set(infoWithWallet: wallet!)
				}
			}
			//
			// Imperatives - Disclosure
			func toggleDisclosureAndPrepareToAnimate(
			) -> (
				selfFrame: CGRect,
				isHiding: Bool
			)
			{
				return self.contentContainerView.toggleDisclosureAndPrepareToAnimate()
			}
			func configureForJustToggledDisclosureState(animated: Bool, isHiding: Bool)
			{
				self.contentContainerView.configureForJustToggledDisclosureState(animated: animated)
			}
			func hasFinishedCellToggleAnimation(isHiding: Bool)
			{
				self.contentContainerView.hasFinishedCellToggleAnimation(isHiding: isHiding)
			}
		}
		
		class InfoDisclosing_CopyableLongStringFieldView: UICommonComponents.Details.CopyableLongStringFieldView
		{
			override var contentInsets: UIEdgeInsets {
				return UIEdgeInsetsMake(17, 44, 17, 16)
			}
		}
		class InfoDisclosing_Truncated_CopyableLongStringFieldView: InfoDisclosing_CopyableLongStringFieldView
		{
			override var contentInsets: UIEdgeInsets {
				return UIEdgeInsetsMake(17, 44, 12, 16)
			}
			override func setup()
			{
				super.setup()
				do {
					let view = self.contentLabel!
					view.numberOfLines = 1 // special case
					view.lineBreakMode = .byTruncatingTail
				}
			}
			override func layOut_contentLabel(
				content_x: CGFloat,
				content_w: CGFloat
			)
			{
				let x: CGFloat = 73
				self.contentLabel.frame = CGRect(
					x: x,
					y: self.titleLabel.frame.origin.y - 3,
					width: content_w - x,
					height: 19
				)
			}

		}
		
		class ContentContainerView: UICommonComponents.Details.SectionContentContainerView
		{
			//
			// Constants
			static let height__closed: CGFloat = 47
			//
			// Properties
			var isDisclosed = false
			let arrowIconView = UIImageView(image: UIImage(named: "disclosureArrow_icon")!)
			//
			let truncated__fieldView_address = InfoDisclosing_Truncated_CopyableLongStringFieldView(
				labelVariant: .middling,
				title: NSLocalizedString("Address", comment: ""),
				valueToDisplayIfZero: nil
			)
			//
			let disclosed__fieldView_address = InfoDisclosing_CopyableLongStringFieldView(
				labelVariant: .middling,
				title: NSLocalizedString("Address", comment: ""),
				valueToDisplayIfZero: nil
			)
			let disclosed__fieldView_viewKey = InfoDisclosing_CopyableLongStringFieldView(
				labelVariant: .middling,
				title: NSLocalizedString("Secret View Key", comment: ""),
				valueToDisplayIfZero: nil
			)
			let disclosed__fieldView_spendKey = InfoDisclosing_CopyableLongStringFieldView(
				labelVariant: .middling,
				title: NSLocalizedString("Secret Spend Key", comment: ""),
				valueToDisplayIfZero: nil
			)
			let disclosed__fieldView_mnemonic = InfoDisclosing_CopyableLongStringFieldView(
				labelVariant: .middling,
				title: NSLocalizedString("Secret Mnemonic", comment: ""),
				valueToDisplayIfZero: nil
			)
			//
			// Lifecycle - Init
			var wantsMnemonicDisplay: Bool
			init(wantsMnemonicDisplay: Bool)
			{
				self.wantsMnemonicDisplay = wantsMnemonicDisplay
				super.init()
				do {
					let view = self.arrowIconView
					view.layer.anchorPoint = CGPoint(x: 0.38, y: 0.55) // to make it look more like it's rotating around the center - normalizing padding in the image would probably be a better way to do this
					self.addSubview(view)
				}
			}
			required init?(coder aDecoder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
			}
			//
			// Accessors
			var _new_fieldViews: [UICommonComponents.Details.FieldView] {
				if self.isDisclosed == false {
					return [
						self.truncated__fieldView_address
					]
				} else {
					var fieldViews: [UICommonComponents.Details.FieldView] = [
						self.disclosed__fieldView_address,
						self.disclosed__fieldView_viewKey,
						self.disclosed__fieldView_spendKey
					]
					if self.wantsMnemonicDisplay {
						fieldViews.append(self.disclosed__fieldView_mnemonic)
					}
					return fieldViews
				}
			}
			//
			// Imperatives
			func set(infoWithWallet wallet: Wallet)
			{
				self._configureFieldViews(withWallet: wallet)
				self.regenerateArrayOfFieldViews()
				self.frame = self.sizeAndLayOutSubviews_returningSelfFrame()
			}
			func _configureFieldViews(withWallet wallet: Wallet)
			{
				self.truncated__fieldView_address.set(text: wallet.public_address)
				self.disclosed__fieldView_address.set(text: wallet.public_address)
				self.disclosed__fieldView_viewKey.set(text: wallet.private_keys.view)
				self.disclosed__fieldView_spendKey.set(text: wallet.private_keys.spend)
				if self.wantsMnemonicDisplay {
					self.disclosed__fieldView_mnemonic.set(text: wallet.mnemonicString!)
				}
			}
			func regenerateArrayOfFieldViews()
			{
				self.set(fieldViews: self._new_fieldViews)
			}
			//
			// Imperatives - Disclosure
			// I.
			func toggleDisclosureAndPrepareToAnimate(
			) -> (
				selfFrame: CGRect,
				isHiding: Bool
			)
			{
				let isHiding = self.isDisclosed
				self.isDisclosed = !self.isDisclosed
				var selfFrame: CGRect
				if isHiding == false {
					self.regenerateArrayOfFieldViews()
					selfFrame = self.sizeAndLayOutSubviews_returningSelfFrame() // because we can measure the already existing field views
				} else {
					let to_fieldViews = self._new_fieldViews // but do not actually display them yet!
					selfFrame = self.sizeAndLayOutSubviews_returningSelfFrame(
						givenFieldViews: to_fieldViews,
						alsoLayOutSharedSeparatorViewsForDisplay: false // because we're not going to defer modifying them until it's "our turn" to do so - as we are deferring regeneration of of fieldView list to the completion of animation
					)
				}
				return (
					selfFrame: selfFrame,
					isHiding: isHiding
				)
			}
			// II.
			func configureForJustToggledDisclosureState(animated: Bool)
			{
				let configure: (Void) -> Void =
				{ [unowned self] in
					do { // arrow
						let degreesAngle: Double = self.isDisclosed ? 90 : 0
						let radiansAngle: Double = degreesAngle * .pi / 180
						let rotationTransform = CATransform3DRotate(
							CATransform3DIdentity,
							CGFloat(radiansAngle), // rotation
							0,
							0,
							1 // around z
						)
						self.arrowIconView.layer.transform = CATransform3DConcat(CATransform3DIdentity, rotationTransform)
					}
				}
				if animated {
					UIView.animate(
						withDuration: 0.14, // should appear relatively snappy
						delay: 0,
						options: [.beginFromCurrentState, .curveEaseOut],
						animations: configure,
						completion:
						{ (finished) in
						}
					)
				} else {
					configure()
				}
			}
			func hasFinishedCellToggleAnimation(isHiding: Bool)
			{
				if isHiding == true { // this was deferred until here for visual effect
					self.regenerateArrayOfFieldViews()
					let _/*no need for selfFrame here*/ = self.sizeAndLayOutSubviews_returningSelfFrame() // or we could just size only the separatorViews (after having established an interface method to pair with having only initially measured the subviews, of course) if we wanted a slight optimization
				}
			}
			//
			// Imperatives - Layout
			func sizeAndLayOutSubviews_returningSelfFrame() -> CGRect
			{
				return self.sizeAndLayOutSubviews_returningSelfFrame(
					givenFieldViews: self.fieldViews,
					alsoLayOutSharedSeparatorViewsForDisplay: true // because this is being called for immediate display, not for measuring
				)
			}
			func sizeAndLayOutSubviews_returningSelfFrame(
				givenFieldViews: [UICommonComponents.Details.FieldView],
				alsoLayOutSharedSeparatorViewsForDisplay: Bool
			) -> CGRect
			{
				let selfFrame = self.sizeAndLayOutGivenFieldViews_andReturnMeasuredSelfFrame(
					withContainingWidth: self.superview!.frame.size.width,
					andYOffset: 0,
					givenSpecificFieldViews: givenFieldViews,
					alsoLayOutSharedSeparatorViewsForDisplay: alsoLayOutSharedSeparatorViewsForDisplay
				)
				return selfFrame
			}
			//
			// Imperatives - Overrides
			override func layoutSubviews()
			{
				super.layoutSubviews()
				self.arrowIconView.center = CGPoint( // bounds is already set
					x: 19 + self.arrowIconView.frame.size.width/2,
					y: 19 + self.arrowIconView.frame.size.height/2
				)
			}
		}
	}
}