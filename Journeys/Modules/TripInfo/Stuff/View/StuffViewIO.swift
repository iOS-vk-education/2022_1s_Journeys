//
//  StuffViewIO.swift
//  Journeys
//
//  Created by Nastya Ischenko on 18/12/2022.
//

import UIKit
import Foundation


// MARK: - Stuff ViewInput

protocol StuffViewInput: AnyObject {
    func reloadData()
    func showAlert(title: String, message: String)
}

// MARK: - Stuff ViewOutput

protocol StuffViewOutput: AnyObject {
    func viewDidLoad()
    func getSectionHeaderText(_ section: Int) -> String
    func getNumberOfRows(in section: Int) -> Int
    func getStuffCellDisplayData(for indexpath: IndexPath) -> StuffCell.DisplayData?

    func didSelectRow(at indexPath: IndexPath, rowsInSection: Int) -> ((StuffViewController, UITableView, Int)->())?
    func handeleCellDelete(at indexPath: IndexPath)
    func handeleCellEdit(at indexPath: IndexPath, tableView: UITableView?)

    func didTapCellPackButton(at indexpath: IndexPath?, tableView: UITableView)
    func emojiTextFieldDidChange(_ text: String, at indexPath: IndexPath)
    func nameTextFieldDidChange(_ text: String, at indexPath: IndexPath)
    
    func didTapScreen(tableView: UITableView)
    
    func didTapExitButton()
}