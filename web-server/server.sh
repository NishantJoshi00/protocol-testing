curl --location 'http://localhost:8080/cards' \
--header 'Content-Type: application/json' \
--data '{
    "merchantId": "kartikey",
    "customerId": "hedge",
    "cardNo": "4242424242424242",
    "cardName": "kritik modi",
    "expMo": 2,
    "expYr": 24
}'
