import Foundation
import Stencil

@objc(ViewController)
class ViewController: NSObject, Generator {
    required override init() {}
    
    func generate(arguments: [String], options: [String]) {
        guard !arguments.isEmpty else {
            printUsage()
            exit(0)
        }
        
        var arguments = arguments
        let resourceName = arguments.removeFirst().camelCased(.upper)
        
        let containsCoordinator = options.contains("-c") || options.contains("--coordinator")
        
        let context: [String: Any] = [
            "resourceName": resourceName,
            "coordinator": containsCoordinator
        ]
        
        let ext = Extension()
        ext.registerFilter("pluralized") { (value: Any?) in
            if let value = value as? String {
                return value.pluralized
            }
            return value
        }
        ext.registerFilter("upperCamelCased") { (value: Any?) in
            if let value = value as? String {
                return value.camelCased(.upper)
            }
            return value
        }
        ext.registerFilter("lowerCamelCased") { (value: Any?) in
            if let value = value as? String {
                return value.camelCased(.lower)
            }
            return value
        }
        
        let loader = FileSystemLoader(paths: [path])
        let environment = Environment(loader: loader, extensions: [ext])
        let rendered = try! environment.renderTemplate(name: "ViewController.stf", context: context)
        
        Writer.createFile("Source/ViewControllers/\(resourceName)/\(resourceName)ViewController.swift", contents: rendered, options: options)
        
        if containsCoordinator {
            let rendered2 = try! environment.renderTemplate(name: "ChildCoordinator.stf", context: context)
            Writer.createFile("Source/Coordinator/\(resourceName)Coordinator.swift", contents: rendered2, options: options)
        }
    }
    
    func printUsage() {
        print("Usage: hackman generate view_controller NAME")
        print()
        print("Example:")
        print("  hackman generate view_controller song")
    }
}
