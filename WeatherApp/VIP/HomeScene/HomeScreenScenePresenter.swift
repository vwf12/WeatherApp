//
//  HomeScreenScenePresenter.swift
//  WeatherApp
//
//  Created by FARIT GATIATULLIN on 09.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeScreenScenePresentationLogic
{
  func presentSomething(response: HomeScreenScene.Something.Response)
}

class HomeScreenScenePresenter: HomeScreenScenePresentationLogic
{
  weak var viewController: HomeScreenSceneDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: HomeScreenScene.Something.Response)
  {
    let viewModel = HomeScreenScene.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
