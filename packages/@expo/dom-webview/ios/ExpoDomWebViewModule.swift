// Copyright 2015-present 650 Industries. All rights reserved.

import ExpoModulesCore

public class ExpoDomWebViewModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoDomWebViewModule")

    View(ExpoDomWebView.self) {
      Prop("name") { (view: ExpoDomWebView, prop: String) in
        print(prop)
      }
    }
  }
}
