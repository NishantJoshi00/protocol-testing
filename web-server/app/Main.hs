{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson (FromJSON, ToJSON)
import Data.Proxy (Proxy (..))
import Data.Text (Text, pack)
import Data.Text.Encoding.Base64 (encodeBase64)
import Data.Time (getCurrentTime)
import GHC.Generics (Generic)
import Network.Wai.Handler.Warp (run)
import Servant.API (JSON, Post, ReqBody, type (:>))
import Servant.Server (Handler, Server, serve)

data Card = Card
  { merchantId :: Text
  , customerId :: Text
  , cardNo :: Text
  , cardName :: Text
  , expMo :: Maybe Int
  , expYr :: Maybe Int
  }
  deriving stock (Generic, Eq, Show)
  deriving anyclass (ToJSON, FromJSON)

data CardRes = CardRes
  { cardHash :: Text
  , createdAt :: Text
  }
  deriving stock (Generic, Eq, Show)
  deriving anyclass (ToJSON, FromJSON)

type CardAPI =
  "cards" :> ReqBody '[JSON] Card :> Post '[JSON] CardRes

cardsAPI :: Data.Proxy.Proxy CardAPI
cardsAPI = Data.Proxy.Proxy :: Data.Proxy.Proxy CardAPI

cardHandler :: Card -> Handler CardRes
cardHandler card = do
  time <- liftIO getCurrentTime
  pure $
    CardRes
      { cardHash = encodeBase64 $ mappend (mappend (cardNo card) (cardName card)) (pack $ show time)
      , createdAt = pack $ show time
      }

cardsServer :: Server CardAPI
cardsServer = cardHandler

runServer :: IO ()
runServer = run 8080 (serve cardsAPI cardsServer)

main :: IO ()
main = putStrLn "Running server, plej plej" >> runServer
