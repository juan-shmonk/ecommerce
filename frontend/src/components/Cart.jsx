export default function Cart({ cart, onRemove, onEmpty }) {
  // Vista del carrito con opcion de eliminar y vaciar.
  if (cart.length === 0) {
    return <p>El carrito esta vacio.</p>
  }

  return (
    <div className="cart">
      {cart.map((item) => (
        <div key={item.product.productId} className="cart-item">
          <div>
            <strong>{item.product.productName}</strong>
            <span className="muted"> x {item.quantity}</span>
          </div>
          <div className="cart-actions">
            <span>${(item.product.productPrice * item.quantity).toFixed(2)}</span>
            <button
              className="link"
              onClick={() => onRemove(item.product.productId)}
            >
              Quitar
            </button>
          </div>
        </div>
      ))}

      <button className="secondary" onClick={onEmpty}>
        Vaciar carrito
      </button>
    </div>
  )
}
