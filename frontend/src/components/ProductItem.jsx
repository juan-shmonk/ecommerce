export default function ProductItem({ product, onAdd }) {
  // Tarjeta simple del producto.
  const discount = product.productDiscount

  return (
    <div className="card">
      <h3>{product.productName}</h3>
      <p>
        Precio: ${product.productPrice.toFixed(2)}{' '}
        {discount !== null && discount !== undefined && (
          <span className="badge">-{discount}%</span>
        )}
      </p>
      <button onClick={() => onAdd(product)}>Agregar</button>
    </div>
  )
}
