{-# LANGUAGE DeriveGeneric #-}

-- Dominio puro: tipos y funciones del carrito.
-- Todo aqui es logica sin IO, para que sea facil de entender y probar.
module Domain
  ( Product(..)
  , Client(..)
  , CartItem(..)
  , Cart
  , applyDiscount
  , addToCart
  , removeFromCart
  , emptyCart
  , cartItemTotal
  , cartTotal
  , validateCard
  , sampleProducts
  ) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)
import Data.Char (isDigit)

-- Producto basico.
-- Nota: productPrice representa el precio final (ya con descuento si aplica).
-- productDiscount es solo informativo (porcentaje aplicado).
data Product = Product
  { productId :: Int
  , productName :: String
  , productPrice :: Double
  , productDiscount :: Maybe Double
  } deriving (Show, Eq, Generic)

instance ToJSON Product
instance FromJSON Product

-- Cliente basico (no se usa en endpoints, solo como ejemplo de tipo).
data Client = Client
  { clientId :: Int
  , clientName :: String
  } deriving (Show, Eq, Generic)

instance ToJSON Client
instance FromJSON Client

-- Item dentro del carrito.
data CartItem = CartItem
  { cartProduct :: Product
  , cartQuantity :: Int
  } deriving (Show, Eq, Generic)

instance ToJSON CartItem
instance FromJSON CartItem

-- Carrito = lista de items.
type Cart = [CartItem]

-- Aplica un descuento al producto.
-- pct es un porcentaje de 0 a 100. Ej: 10 = 10%.
-- Devuelve un nuevo producto con el precio ajustado.
applyDiscount :: Double -> Product -> Product
applyDiscount pct p
  | pct <= 0 = p { productDiscount = Just 0 }
  | pct >= 100 = p { productPrice = 0, productDiscount = Just 100 }
  | otherwise =
      let newPrice = productPrice p * (1 - pct / 100)
      in p { productPrice = newPrice, productDiscount = Just pct }

-- Agrega un producto al carrito.
-- Si ya existe, suma la cantidad.
addToCart :: Product -> Int -> Cart -> Cart
addToCart product qty cart
  | qty <= 0 = cart
  | otherwise = addOrUpdate cart
  where
    addOrUpdate [] = [CartItem product qty]
    addOrUpdate (item:rest)
      | productId (cartProduct item) == productId product =
          item { cartQuantity = cartQuantity item + qty } : rest
      | otherwise = item : addOrUpdate rest

-- Elimina un producto del carrito por id.
removeFromCart :: Int -> Cart -> Cart
removeFromCart pid cart = filter (\item -> productId (cartProduct item) /= pid) cart

-- Vaciar carrito.
emptyCart :: Cart -> Cart
emptyCart _ = []

-- Total de un item (precio * cantidad).
cartItemTotal :: CartItem -> Double
cartItemTotal item = productPrice (cartProduct item) * fromIntegral (cartQuantity item)

-- Total del carrito: suma de (precio * cantidad).
cartTotal :: Cart -> Double
cartTotal cart = sum (map cartItemTotal cart)

-- Validacion de tarjeta (simulada).
-- Reglas:
-- 1) Solo digitos
-- 2) Longitud entre 13 y 19
-- 3) Pasa el algoritmo de Luhn
validateCard :: String -> Bool
validateCard s =
  let len = length s
      onlyDigits = all isDigit s
  in onlyDigits && len >= 13 && len <= 19 && luhnCheck s

-- Implementacion simple de Luhn.
-- Pasos:
-- 1) Convertir cada caracter a numero
-- 2) Invertir la lista (para empezar desde el ultimo digito)
-- 3) Duplicar cada segundo digito
-- 4) Si al duplicar pasa de 9, restar 9
-- 5) Sumar todo y verificar que el total sea divisible por 10
luhnCheck :: String -> Bool
luhnCheck digits =
  let nums = map charToInt digits
      reversed = reverse nums
      processed = zipWith luhnStep [0..] reversed
      total = sum processed
  in total `mod` 10 == 0
  where
    charToInt c = fromEnum c - fromEnum '0'

    luhnStep index n
      | odd index =
          let doubled = n * 2
          in if doubled > 9 then doubled - 9 else doubled
      | otherwise = n

-- Productos de ejemplo para el endpoint /products.
-- Se aplican descuentos usando applyDiscount.
sampleProducts :: [Product]
sampleProducts =
  [ Product 1 "Cafe" 3.50 Nothing
  , applyDiscount 10 (Product 2 "Te" 2.00 Nothing)
  , applyDiscount 20 (Product 3 "Galletas" 1.50 Nothing)
  , Product 4 "Pan" 1.20 Nothing
  ]
