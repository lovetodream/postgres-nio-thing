import Hummingbird
import HummingbirdXCT
@_spi(ConnectionPool) import PostgresNIO
import ServiceLifecycle

struct PostgresClientService: Service {
    let client: PostgresClient

    func run() async {
        await cancelOnGracefulShutdown {
            await self.client.run()
        }
    }
}

var logger = Logger(label: "lalala")
logger.logLevel = .debug

let client = PostgresClient(
    configuration: .init(host: "localhost", username: "my_username", password: "my_password", database: "hummingbird", tls: .disable),
    backgroundLogger: logger
)

let router = HBRouter()
router.get("/") { request, context in
    "Hello\n"
}

var app = HBApplication(
    router: router,
    configuration: .init(address: .hostname("0.0.0.0", port: 8080)),
    logger: logger
)

app.addServices(PostgresClientService(client: client))
app.runBeforeServerStart {
    try await client.withConnection { connection in
        let hello = try await connection.query(#"SELECT "hello";"#, logger: logger)
        print(hello)
    }
}
try await app.test(.router) { client in // weird thingy
    print(client)
}

//try await app.test(.live) { client in // all good
//    print(client)
//}

//try await app.run() // all good
