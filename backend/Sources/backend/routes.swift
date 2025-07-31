import Vapor

func routes(_ app: Application) throws {
    // Optional test routes
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    // ✅ Register controllers
    try app.register(collection: AllCardsController())
    try app.register(collection: UserCardController())
}
