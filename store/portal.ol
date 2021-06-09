from .store-interface import StoreInterface, GetPriceRequest, Price
from console import Console

type GetPricesResponse {
	results* {
		from: string
		price: Price
	}
}

interface PortalInterface {
RequestResponse: getPrices( GetPriceRequest )( GetPricesResponse )
}

service Portal {
	execution: concurrent

	embed Console as console

	outputPort store1 {
		location: "socket://localhost:8001"
		protocol: sodep
		interfaces: StoreInterface
	}

	outputPort store2 {
		location: "socket://localhost:8002"
		protocol: sodep
		interfaces: StoreInterface
	}

	inputPort input {
		location: "socket://localhost:8080"
		protocol: http { format = "json" }
		interfaces: PortalInterface
	}

	main {
		getPrices( request )( response ) {
			getPrice@store1( request )( response.results[0].price ); response.results[0].from = "Nice Store"
			|
			getPrice@store2( request )( response.results[1].price ); response.results[1].from = "Expensive Store"
		}
	}
}