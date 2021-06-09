type ProductId: string
type Price: double
type DiscountCode: string

type GetPriceRequest {
	product: ProductId
	discountCode?: DiscountCode
}

interface StoreInterface {
RequestResponse: getPrice( GetPriceRequest )( Price )
}