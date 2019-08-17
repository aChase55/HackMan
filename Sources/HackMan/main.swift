//
//  File.swift
//  
//
//  Created by Devran on 15.08.19.
//

import Stencil
import Foundation
import HackManLib

var arguments = CommandLine.arguments

let options = arguments.filter { $0.starts(with: "-") }
arguments = arguments.filter { !options.contains($0) }

do {
    try _ = Run(arguments: arguments, options: options)
} catch let error as Run.CommandError {
    switch error {
    case Run.CommandError.noCommand:
        Run.printCommandUsage()
    case .unknownCommand(let name):
        print("Unknown command \"\(name)\".")
        print()
        Run.printCommandUsage()
    }
} catch let error as Run.GeneratorCommandError {
    switch error {
    case .noGenerator:
        Run.printGeneratorUsage()
    case .unknownGenerator:
        print("Unknown generator.")
        print()
        Run.printGeneratorUsage()
    }
}
