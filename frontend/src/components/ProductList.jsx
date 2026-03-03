import ProductItem from './ProductItem.jsx'

export default function ProductList({ products, onAdd }) {
  // Lista simple de productos.
  if (products.length === 0) {
    return <p>No hay productos disponibles.</p>
  }

  return (
    <div className="grid">
      {products.map((product) => (
        <ProductItem key={product.productId} product={product} onAdd={onAdd} />
      ))}
    </div>
  )
}
