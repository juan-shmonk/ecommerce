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
