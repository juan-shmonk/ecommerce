# Carrito de compras (Haskell + React)

## Que hace
- Backend en Haskell expone productos y valida tarjeta (simulada).
- Frontend en React lista productos, agrega/quita/vacia y calcula total.

## Estructura
- backend/app/Main.hs
- backend/src/Domain.hs
- frontend/src/App.jsx
- frontend/src/components/

## Como correr

### Backend (Windows PowerShell)
1) Instalar GHC + cabal con GHCup (si ya los tienes, omite este paso):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm https://get-ghcup.haskell.org -OutFile ghcup.ps1
.\ghcup.ps1
```
2) Levantar servidor:
```powershell
cd backend
cabal update
cabal run shopping-cart-backend
```

### Backend (comandos generales)
```bash
curl https://get-ghcup.haskell.org | sh
cd backend
cabal update
cabal run shopping-cart-backend
```

### Frontend (Windows PowerShell)
```powershell
cd frontend
npm install
npm run dev
```

### Frontend (comandos generales)
```bash
cd frontend
npm install
npm run dev
```

## Como probar
Con el backend arriba (puerto 3001) y el frontend (puerto 5173):
- Abre el navegador en:
```text
http://localhost:5173
```

Probar endpoints manualmente:

PowerShell:
```powershell
Invoke-RestMethod http://localhost:3001/products

Invoke-RestMethod -Method Post http://localhost:3001/validate-card `
  -ContentType 'application/json' `
  -Body '{"cardNumber":"4242424242424242"}'
```

Comandos generales:
```bash
curl http://localhost:3001/products
curl -X POST http://localhost:3001/validate-card \
  -H "Content-Type: application/json" \
  -d '{"cardNumber":"4242424242424242"}'
```
