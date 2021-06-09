from .store-interface import StoreInterface
from file import File
from console import Console
from database import Database

type StoreParams {
	name: string
	location: string
	dbPath: string
}

service Store( params:StoreParams ) {
	execution: sequential

	embed Console as console
	embed File as fs

	inputPort input {
		location: params.location
		protocol: sodep
		interfaces: StoreInterface
	}

	init {
		readFile@fs( { filename = params.dbPath format = "json" } )( global.db )
		println@console( params.name + " launched at " + global.inputPorts.input.location )()
	}

	main {
		getPrice( request )( price ) {
			price = global.db.products.(request.product).price
			if( request.discountCode instanceof string
				&& is_defined( global.db.discountCodes.(request.discountCode) ) ) {
				price -= price * global.db.discountCodes.(request.discountCode) / 100
			}
		}
	}
}
