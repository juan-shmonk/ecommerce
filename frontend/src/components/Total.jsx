export default function Total({ total }) {
  // Total simple del carrito.
  return (
    <p className="total">
      Total: <strong>${total.toFixed(2)}</strong>
    </p>
  )
}
