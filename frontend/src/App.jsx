import { useEffect, useMemo, useState } from 'react'
import ProductList from './components/ProductList.jsx'
import Cart from './components/Cart.jsx'
import Total from './components/Total.jsx'

const API_URL = 'http://localhost:3001'

export default function App() {
  // Estado de productos del backend.
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  // Estado del carrito en el frontend (para simplicidad).
  const [cart, setCart] = useState([])

  // Estado de validacion de tarjeta.
  const [cardNumber, setCardNumber] = useState('')
  const [cardResult, setCardResult] = useState(null)
  const [purchaseMessage, setPurchaseMessage] = useState('')

  useEffect(() => {
    // Cargar productos una sola vez.
    const load = async () => {
      try {
        setLoading(true)
        const res = await fetch(`${API_URL}/products`)
        if (!res.ok) {
          throw new Error('Error al cargar productos')
        }
        const data = await res.json()
        setProducts(data)
      } catch (err) {
        setError(err.message || 'Error inesperado')
      } finally {
        setLoading(false)
      }
    }

    load()
  }, [])

  // Agregar producto al carrito (si existe, suma cantidad).
  const addToCart = (product) => {
    setPurchaseMessage('')
    setCart((prev) => {
      const index = prev.findIndex(
        (item) => item.product.productId === product.productId
      )
      if (index >= 0) {
        const next = [...prev]
        next[index] = {
          ...next[index],
          quantity: next[index].quantity + 1
        }
        return next
      }
      return [...prev, { product, quantity: 1 }]
    })
  }

  // Eliminar producto del carrito por id.
  const removeFromCart = (productId) => {
    setPurchaseMessage('')
    setCart((prev) => prev.filter((item) => item.product.productId !== productId))
  }

  // Vaciar carrito.
  const emptyCart = () => {
    setPurchaseMessage('')
    setCart([])
  }

  // Total calculado en el frontend.
  const total = useMemo(() => {
    return cart.reduce((sum, item) => {
      return sum + item.product.productPrice * item.quantity
    }, 0)
  }, [cart])

  // Llamar al backend para validar tarjeta.
  const validateCard = async () => {
    setCardResult(null)
    setPurchaseMessage('')

    if (cart.length === 0) {
      setCardResult({
        valid: false,
        message: 'Agrega al menos un producto antes de simular la compra.'
      })
      return
    }

    try {
      const res = await fetch(`${API_URL}/validate-card`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ cardNumber })
      })
      if (!res.ok) {
        throw new Error('Error al validar tarjeta')
      }
      const data = await res.json()
      setCardResult(data)

      if (data.valid) {
        setPurchaseMessage(
          `Compra simulada realizada por $${total.toFixed(2)}.`
        )
        setCart([])
        setCardNumber('')
      }
    } catch (err) {
      setCardResult({ valid: false, message: err.message || 'Error inesperado' })
    }
  }

  return (
    <div className="page">
      <div className="container">
        <header className="header">
          <h1>Carrito de compras (demo)</h1>
          <p>Backend en Haskell + frontend en React.</p>
        </header>

        <section className="section">
          <h2>Productos</h2>
          {loading && <p>Cargando productos...</p>}
          {error && <p className="error">{error}</p>}
          {!loading && !error && (
            <ProductList products={products} onAdd={addToCart} />
          )}
        </section>

        <section className="section">
          <h2>Carrito</h2>
          <Cart cart={cart} onRemove={removeFromCart} onEmpty={emptyCart} />
          <Total total={total} />
        </section>

        <section className="section">
          <h2>Finalizar compra</h2>
          <div className="card-box">
            <input
              type="text"
              placeholder="Numero de tarjeta"
              value={cardNumber}
              onChange={(e) => {
                setPurchaseMessage('')
                setCardNumber(e.target.value)
              }}
            />
            <button onClick={validateCard}>Validar y comprar</button>
          </div>
          {cardResult && (
            <p className={cardResult.valid ? 'ok' : 'error'}>
              {cardResult.message}
            </p>
          )}
          {purchaseMessage && <p className="purchase">{purchaseMessage}</p>}
        </section>
      </div>
    </div>
  )
}
