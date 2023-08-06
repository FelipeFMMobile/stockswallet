import SwiftUI
import PlaygroundSupport
import UIKit

struct NavigationRouteView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 10) {
                Text("Root view")
                Button {
                    Router.shared.changeRoute(RoutePath(.user_create))
                } label: {
                    Text("Go to user create")
                }
                Button {
                    let user = User("George")
                    Router.shared.changeRoute(RoutePath(.user_edit(user)))
                } label: {
                    Text("Go to user edit")
                }
                .task {
                     Router.shared.changeRoute = changeRoute
                     Router.shared.backRoute = backRoute
                }
            }
            .navigationDestination(for: RoutePath.self) { route in
                switch route.route {
                case .user_list:
                    Text("User list view comes here")
                case .user_create:
                    Text("User create view comes here")
                case .user_edit(let user):
                    Text("User edit of \(user.name) view comes here")
                    Button {
                        Router.shared.changeRoute(RoutePath(.user_info(user)))
                    } label: {
                        Text("Go to user info")
                    }

                case .user_info(let user):
                    Text("User info of \(user.name) view comes here")
                    Button {
                        Router.shared.backRoute()
                    } label: {
                        Text("Go back")
                    }
                case .error_screen(let error):
                    Text("Some error screen \(error.localizedDescription)")
                case .none:
                    Text("no route")
                }
            }
        }
    }

    // MARK: Route
    func changeRoute(_ route: RoutePath) {
        path.append(route)
    }

    func backRoute() {
        path.removeLast()
    }
}

PlaygroundPage.current.setLiveView(NavigationRouteView())
