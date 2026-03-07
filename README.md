# Carrito de compras escolar

Demo minima con backend en Haskell + Scotty y frontend en React + Vite.

## Que hace

- El backend expone `GET /products` con productos de ejemplo.
- El backend expone `POST /validate-card` para una validacion simulada.
- El frontend muestra productos, permite agregarlos al carrito, quitarlos, vaciarlo y calcular el total.
- El frontend envia la tarjeta al backend y muestra un mensaje de compra simulada cuando la tarjeta es valida.

## Estructura

- `backend/app/Main.hs`: servidor HTTP y endpoints.
- `backend/src/Domain.hs`: tipos y funciones puras del dominio.
- `frontend/src/App.jsx`: flujo principal del frontend.
- `frontend/src/components/`: componentes simples de React.

## Ejecutar en Windows

### 1. Backend Haskell

Si no tienes Haskell instalado, instala `ghc` y `cabal` con GHCup:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm https://get-ghcup.haskell.org -OutFile ghcup.ps1
.\ghcup.ps1
```

Luego ejecuta:

```powershell
cd backend
cabal update
cabal run shopping-cart-backend
```

El backend queda en `http://localhost:3001`.

### 2. Frontend React

```powershell
cd frontend
npm install
npm run dev
```

El frontend queda en `http://localhost:5173`.

## Comandos generales

Backend:

```bash
cd backend
cabal update
cabal run shopping-cart-backend
```

Frontend:

```bash
cd frontend
npm install
npm run dev
```

## Probar rapido

### Endpoint de productos

```powershell
Invoke-RestMethod http://localhost:3001/products
```

### Endpoint de tarjeta

```powershell
Invoke-RestMethod -Method Post http://localhost:3001/validate-card `
  -ContentType 'application/json' `
  -Body '{"cardNumber":"4242424242424242"}'
```

## Que se corrigio

- Se dejo el backend como servidor Scotty minimo con CORS habilitado.
- Se mantuvo la logica pura de Haskell para descuento, agregar, eliminar, vaciar y total.
- Se corrigio el flujo del frontend para carrito en memoria.
- Se completo la validacion de tarjeta desde React hacia el backend.
- Se agrego el mensaje de compra simulada cuando la tarjeta es valida.
- Se dejo el proyecto listo para correr localmente sin base de datos ni autenticacion.
