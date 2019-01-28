// ----------------------------------------------------------------------------
//
//  PaymentMethodViewModel.swift
//
//  @author     Nikita Semakov <SemakovNV@ekassir.com>
//  @copyright  Copyright (c) 2016, eKassir Ltd. All rights reserved.
//  @link       http://www.ekassir.com/
//
// ----------------------------------------------------------------------------

import SwiftCommonsLang
import TaxiBookingCoreEntities
import UIKit

// ----------------------------------------------------------------------------

class PaymentMethodViewModel
{
// MARK: - Construction

    init(paymentMethod: PaymentMethodModel?)
    {
        if let paymentMethod = paymentMethod
        {
            switch paymentMethod.type
            {
                case .cash:
                    self.image = R.image.ic_cash()
                    self.text = R.string.localizationLabel.cashPayment()

                case .paymentCard:
                    if let paymentCard = paymentMethod.paymentCard
                    {
                        self.image = UIImage.paymentCardTypeIcon(paymentCard.type)
                        self.text = "•••• " + paymentCard.pan.substring(from: (paymentCard.pan.count - Inner.LastDigitCountToTake))
                    }
                    else {
                        Roxie.fatalError("Unexpected PaymentMethodModel state.")
                    }

                case .invalidOptionValue:
                    Roxie.fatalError("Unexpected PaymentMethodModel type.")

                default:
                    Roxie.fatalError("Unexpected PaymentMethodModel type.")
            }
        }
        else
        {
            // TODO: remove after making input paymentMethod non-optional
            self.image = R.image.ic_cash()
            self.text = R.string.localizationLabel.cashPayment()
        }
    }

// MARK: - Properties

    let text: String?

    let image: UIImage?

// MARK: - Constants

    private struct Inner {
        static let LastDigitCountToTake: Int = 4
    }

}

// ----------------------------------------------------------------------------
