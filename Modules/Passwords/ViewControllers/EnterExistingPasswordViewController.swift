//
//  EnterExistingPasswordViewController.swift
//  MyMonero
//
//  Created by Paul Shapiro on 6/3/17.
//  Copyright © 2017 MyMonero. All rights reserved.
//

import UIKit

class EnterExistingPasswordViewController: PasswordEntryScreenBaseViewController, PasswordEntryTextFieldEventDelegate
{
	var password_label: UICommonComponents.FormLabel!
	var password_inputView: UICommonComponents.FormInputField!
	var forgot_linkButtonView: UICommonComponents.LinkButtonView!
	//
	override func setup()
	{
		super.setup()
		self.edgesForExtendedLayout = [ .top ] // do slide under nav bar, in this case
		self.extendedLayoutIncludesOpaqueBars = true // since we use an opaque bar
		self.setup_subviews() // before nav, cause nav setup references subviews
		self.setup_navigation()
	}
	func setup_navigation()
	{
		self.navigationItem.title = "Enter \(PasswordController.shared.passwordType.capitalized_humanReadableString)"
		self.navigationItem.leftBarButtonItem = self._new_leftBarButtonItem()
		self.navigationItem.rightBarButtonItem = self._new_rightBarButtonItem()
	}
	func setup_subviews()
	{
		do {
			let view = UICommonComponents.FormInputField(
				placeholder: NSLocalizedString("So we know it's you", comment: "")
			)
			view.isSecureTextEntry = true
			view.keyboardType = PasswordController.shared.passwordType == PasswordController.PasswordType.PIN ? .numberPad : .default
			view.returnKeyType = .go
			view.addTarget(self, action: #selector(aPasswordField_editingChanged), for: .editingChanged)
			view.delegate = self
			self.password_inputView = view
			self.view.addSubview(view)
		}
		do {
			let view = UICommonComponents.FormLabel(
				title: PasswordController.shared.passwordType.humanReadableString.uppercased(),
				sizeToFit: true
			)
			self.password_label = view
			self.view.addSubview(view)
		}
		do {
			let view = UICommonComponents.LinkButtonView(mode: .mono_default, title: NSLocalizedString("Forgot?", comment: ""))
			view.addTarget(self, action: #selector(tapped_forgotButton), for: .touchUpInside)
			view.contentHorizontalAlignment = .right // so we can just set the width to whatever
			self.forgot_linkButtonView = view
			self.view.addSubview(view)
		}
	}
	//
	// Accessors - Factories - Views
	func _new_leftBarButtonItem() -> UICommonComponents.NavigationBarButtonItem?
	{
		if self.isForChangingPassword != true {
			return nil
		}
		let item = UICommonComponents.NavigationBarButtonItem(
			type: .cancel,
			target: self,
			action: #selector(tapped_leftBarButtonItem)
		)
		return item
	}
	func _new_rightBarButtonItem() -> UICommonComponents.NavigationBarButtonItem?
	{
		let item = UICommonComponents.NavigationBarButtonItem(
			type: .save,
			target: self,
			action: #selector(tapped_rightBarButtonItem),
			title_orNilForDefault: NSLocalizedString("Next", comment: "")
		)
		let passwordInputValue = self.password_inputView.text
		item.isEnabled = passwordInputValue != nil && passwordInputValue != "" // need to enter PW first
		//
		return item
	}
	//
	// Imperatives
	func _tryToSubmitForm()
	{
		self.__disableForm()
		// we can assume pw is not "" here
		self.__yield_nonZeroPassword()
	}
	func __yield_nonZeroPassword()
	{
		if let cb = userSubmittedNonZeroPassword_cb {
			cb(self.password_inputView.text!)
		}
	}
	func __disableForm()
	{
		self.navigationItem.rightBarButtonItem!.isEnabled = false
		//
		self.password_inputView.isEnabled = false
		self.forgot_linkButtonView.isEnabled = false
	}
	func __reEnableForm()
	{
		self.navigationItem.rightBarButtonItem!.isEnabled = true
		//
		self.password_inputView.isEnabled = true
		self.password_inputView.becomeFirstResponder() // since disable would have de-focused
		self.forgot_linkButtonView.isEnabled = true
	}
	//
	// Overrides - Imperatives - Validation
	override func setValidationMessage(_ message: String)
	{
		self.password_inputView.setValidationError(message)
	}
	override func clearValidationMessage()
	{
		self.password_inputView.clearValidationError()
	}
	//
	// Delegation - Navigation bar buttons
	@objc
	func tapped_leftBarButtonItem()
	{
		if let cb = self.cancelButtonPressed_cb {
			cb()
		}
	}
	@objc
	func tapped_rightBarButtonItem()
	{
		self._tryToSubmitForm()
	}
	//
	// Delegation - View lifecycle
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		//
		self.password_inputView.becomeFirstResponder()
	}
	override func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews()
		//
		let textField_topMargin: CGFloat = 8
		let fieldGroup_h = self.password_label.frame.size.height + textField_topMargin + self.password_inputView.frame.size.height
		let fieldGroup_y = (self.view.frame.size.height - fieldGroup_h) / 2
		let textField_x: CGFloat = CGFloat.form_input_margin_x
		let labels_x: CGFloat  = CGFloat.form_label_margin_x
		let textField_w: CGFloat = self.view.frame.size.width - 2 * textField_x
		do {
			self.password_label.frame = CGRect(
				x: labels_x,
				y: fieldGroup_y,
				width: self.view.frame.size.width - 2 * labels_x,
				height: self.password_label.frame.size.height
			)
			assert(self.forgot_linkButtonView.frame.size.height > self.password_label.frame.size.height, "self.forgot_linkButtonView.frame.size.height <= self.password_label.frame.size.height")
			self.forgot_linkButtonView.frame = CGRect(
				x: textField_x + textField_w - self.forgot_linkButtonView.frame.size.width - fabs(labels_x - textField_x),
				y: self.password_label.frame.origin.y - fabs(self.forgot_linkButtonView.frame.size.height - self.password_label.frame.size.height)/2, // since this button is taller than the label, we can't use the same y offset; we have to vertically center the forgot_linkButtonView with the label
				width: self.forgot_linkButtonView.frame.size.width,
				height: self.forgot_linkButtonView.frame.size.height
			)
			self.password_inputView.frame = CGRect(
				x: textField_x,
				y: self.password_label.frame.origin.y + self.password_label.frame.size.height + textField_topMargin,
				width: textField_w,
				height: self.password_inputView.frame.size.height
			)
		}
	}
	//
	// Delegation - Password field - Control events
	@objc func aPasswordField_editingChanged()
	{
		let password = self.password_inputView.text
		let submitEnabled = password != nil && password != ""
		self.navigationItem.rightBarButtonItem!.isEnabled = submitEnabled
	}
	//
	// Delegation - UITextField
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		self.aPasswordField_didReturn()
		return false
	}
	//
	// Delegation - Password field - Internal events
	func aPasswordField_didReturn()
	{
		if self.navigationItem.rightBarButtonItem!.isEnabled {
			self._tryToSubmitForm()
		}
	}	//
	// Delegation - Interactions
	@objc
	func tapped_forgotButton()
	{
		let controller = ForgotPasswordViewController()
		DispatchQueue.main.async { // to avoid animation jank (TODO: does this actually work? is this a problem on-device?); possibly exists due to time needed to lay out emoji label
			self.navigationController!.pushViewController(controller, animated: true)
		}
	}

}