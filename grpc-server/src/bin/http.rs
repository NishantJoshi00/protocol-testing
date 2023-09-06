use axum::{http::StatusCode, routing::post, Json, Router};
use base64::Engine;
use grpc_server::BASE64_ENGINE;

#[derive(serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
struct CardRequest {
    merchant_id: String,
    customer_id: String,
    #[serde(rename = "cardNo")]
    card_number: String,
    card_name: String,
    #[serde(rename = "expMo")]
    expiry_month: Option<u32>,
    #[serde(rename = "expYr")]
    expiry_year: Option<u32>,
}

#[derive(serde::Serialize, serde::Deserialize)]
#[serde(rename_all = "camelCase")]
struct CardResponse {
    card_hash: String,
    created_at: String,
}

fn current_time() -> Result<String, axum::Error> {
    let current = time::OffsetDateTime::now_utc();

    let format =
        time::format_description::parse("[year]-[month]-[day] [hour]:[minute]:[second] UTC")
            .map_err(|_| axum::Error::new("failed while building time format"))?;

    current
        .format(&format)
        .map_err(|_| axum::Error::new("failed while building format"))
}

async fn cards<'a>(Json(card): Json<CardRequest>) -> Result<Json<CardResponse>, StatusCode> {
    let current_time = current_time().map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;
    let encoded_data = BASE64_ENGINE.encode(format!(
        "{}{}{}",
        card.card_number, card.card_name, current_time
    ));

    Ok(Json(CardResponse {
        card_hash: encoded_data,
        created_at: current_time,
    }))
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let app = Router::new().route("/cards", post(cards));

    axum::Server::bind(&"0.0.0.0:8080".parse()?)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}
