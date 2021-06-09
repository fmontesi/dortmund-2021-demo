type GreetRequest {
	name: string
}

type GreetResponse {
	greeting: string
}

interface GreeterInterface {
RequestResponse: greet( GreetRequest )( GreetResponse )
}

service Greeter {
	execution: concurrent

	inputPort input {
		location: "socket://localhost:8080"
		protocol: http { format = "json" }
		interfaces: GreeterInterface
	}

	main {
		greet( request )( response ) {
			response.greeting = "Hello " + request.name + "!"
		}
	}
}
