//
//  ThemeController.swift
//  MyMonero
//
//  Created by Paul Shapiro on 6/3/17.
//  Copyright © 2017 MyMonero. All rights reserved.
//

import UIKit
import PKHUD
//
class ThemeController
{
	enum ThemeMode
	{
		case dark
	}
	var mode: ThemeMode = .dark
	//
	static let shared = ThemeController()
	private init() // private due to singleton init
	{
		self.setup()
	}
	func setup()
	{
		self.configureWithMode()
	}
	//
	func configureWithMode()
	{
		self.configureAppearance()
	}
	func configureAppearance()
	{
		self.configureAppearance_navigationBar()
		self.configureAppearance_PKHUD()
	}
	func configureAppearance_navigationBar()
	{
		UINavigationBar.appearance().barTintColor = UIColor.contentBackgroundColor
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
		UINavigationBar.appearance().isTranslucent = false // when this is set to false, if a view wants its extended layout to include .top, it must say its extendedLayoutIncludesOpaqueBars
		UINavigationBar.appearance().titleTextAttributes =
		[
			NSFontAttributeName: UIFont.middlingBoldSansSerif,
			NSForegroundColorAttributeName: UIColor.normalNavigationBarTitleColor
		]
		UINavigationBar.appearance().setTitleVerticalPositionAdjustment(-2, for: .default) // b/c font is smaller, need to align w/nav buttons
		UINavigationBar.appearance().shadowImage = UIImage() // remove shadow - would be good to place shadow back on view's scroll (may do manually)
	}
	func configureAppearance_PKHUD()
	{
		PKHUD.sharedHUD.dimsBackground = false // debatable
		PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false // ofc
	}
	//
	// Imperatives - Convenience
	func styleViewController_navigationBarTitleTextAttributes(
		viewController: UIViewController,
		titleTextColor: UIColor? // nil to reset
	)
	{
		let navigationBar = viewController.navigationController!.navigationBar
		navigationBar.titleTextAttributes =
		[
			NSFontAttributeName: UIFont.middlingBoldSansSerif,
			NSForegroundColorAttributeName: titleTextColor ?? UIColor.normalNavigationBarTitleColor
		]

	}
}
//
extension CGFloat
{
	static let visual__form_input_margin_x: CGFloat = 24
	static let form_input_margin_x: CGFloat = visual__form_input_margin_x - UICommonComponents.FormInputCells.imagePadding_x
	//
	static let form_label_margin_x: CGFloat = 33
	static let form_labelAccessoryLabel_margin_x = visual__form_input_margin_x
}
//
extension UIColor
{ // This is a place to use app-wide, oft-repeated colors - rather than colors which can be encapsulated within e.g. singular components (for their specific semantic or use-cases).
	// Once we add multiple themes, switch by ThemeController.shared.mode
	static var contentBackgroundColor: UIColor
	{
		return UIColor(rgb: 0x272527)
	}
	static var contentTextColor: UIColor
	{
		return UIColor(rgb: 0x9E9C9E)
	}
	//
	static var standaloneValidationTextOrDestructiveLinkContentColor: UIColor
	{
		return UIColor(rgb: 0xF97777)
	}
	static var utilityOrConstructiveLinkColor: UIColor
	{
		return UIColor(rgb: 0x11BBEC)
	}
	static var disabledLinkColor: UIColor
	{
		return UIColor(rgb: 0xD4D4D4)
	}
	static var disabledAndSemiVisibleLinkColor: UIColor
	{
		return UIColor(red: 73/255, green: 71/255, blue: 73/255, alpha: 40)
	}
	//
	static var normalNavigationBarTitleColor: UIColor
	{
		return UIColor.white
	}
}
//
extension UIFont
{
	//
	// Monospace - "Native"
	static var lightMonospaceFontName: String {
		return "Native-Light"
	}
	static var regularMonospaceFontName: String {
		return "Native-Regular"
	}
	static var boldMonospaceFontName: String {
		return "Native-Bold"
	}
	//
	static var visualSizeIncreased_smallRegularMonospace: UIFont // a special case
	{
		return UIFont(name: self.regularMonospaceFontName, size: 12)!
	}
	static var smallLightMonospace: UIFont
	{
		return UIFont(name: self.lightMonospaceFontName, size: 11)!
	}
	static var smallRegularMonospace: UIFont
	{
		return UIFont(name: self.regularMonospaceFontName, size: 11)!
	}
	static var smallBoldMonospace: UIFont
	{
		return UIFont(name: self.boldMonospaceFontName, size: 11)!
	}
	static var middlingLightMonospace: UIFont
	{
		return UIFont(name: self.lightMonospaceFontName, size: 13)!
	}
	static var middlingRegularMonospace: UIFont
	{
		return UIFont(name: self.regularMonospaceFontName, size: 13)!
	}
	static var middlingBoldMonospace: UIFont
	{
		return UIFont(name: self.boldMonospaceFontName, size: 13)!
	}
	
	//
	// Sans Serif - (systemFont should be "San Francisco")
	static var smallSemiboldSansSerif: UIFont
	{
		return UIFont.systemFont(ofSize: 11, weight: UIFontWeightSemibold)
	}
	static var smallMediumSansSerif: UIFont
	{
		return UIFont.systemFont(ofSize: 11, weight: UIFontWeightMedium)
	}
	static var smallBoldSansSerif: UIFont
	{
		return UIFont.systemFont(ofSize: 11, weight: UIFontWeightBold)
	}
	static var middlingBoldSansSerif: UIFont
	{
		return UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
	}
	static var middlingMediumSansSerif: UIFont
	{
		return UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
	}
	static var middlingSemiboldSansSerif: UIFont
	{
		return UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)
	}
	static var middlingRegularSansSerif: UIFont
	{
		return UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
	}
	static var middlingButtonContentSemiboldSansSerif: UIFont
	{
		return UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)
	}
}
