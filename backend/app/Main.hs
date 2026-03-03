{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

-- Servidor HTTP simple con Scotty.
-- Aqui va el IO: endpoints, JSON y configuracion.
module Main where

import Web.Scotty
import Network.Wai.Middleware.Cors (simpleCors)
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics (Generic)
import qualified Data.Text as T

import Domain (Product, sampleProducts, validateCard)

-- Request para validar tarjeta.
data CardRequest = CardRequest
  { cardNumber :: T.Text
  } deriving (Show, Generic)

instance FromJSON CardRequest

-- Response para validar tarjeta.
data CardResponse = CardResponse
  { valid :: Bool
  , message :: T.Text
  } deriving (Show, Generic)

instance ToJSON CardResponse

main :: IO ()
main = scotty 3001 $ do
  -- CORS abierto para que el frontend en otro puerto pueda llamar al backend.
  middleware simpleCors

  -- Lista de productos.
  get "/products" $ do
    json sampleProducts

  -- Validar tarjeta (simulada).
  post "/validate-card" $ do
    req <- jsonData :: ActionM CardRequest
    let number = T.unpack (cardNumber req)
        ok = validateCard number
        msg = if ok
          then "Tarjeta valida (simulada)."
          else "Tarjeta invalida. Debe tener 13 a 19 digitos y pasar Luhn."
    json (CardResponse ok msg)
