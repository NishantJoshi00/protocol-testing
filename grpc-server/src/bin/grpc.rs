use base64::Engine;
use grpc_server::{
    cards::{
        card_server::{Card, CardServer},
        CardRequest, CardResponse,
    },
    BASE64_ENGINE,
};
use tonic::{transport::Server, Request, Response, Status};

#[derive(Debug, Default)]
pub struct CardService;

#[tonic::async_trait]
impl Card for CardService {
    async fn add_card(
        &self,
        request: Request<CardRequest>,
    ) -> Result<Response<CardResponse>, Status> {
        let card = request.into_inner();
        let current_time = current_time()?;
        let encoded_data = BASE64_ENGINE.encode(format!(
            "{}{}{}",
            card.card_no, card.card_name, current_time
        ));

        Ok(Response::new(CardResponse {
            card_hash: encoded_data,
            created_at: current_time,
        }))
    }
}

fn current_time() -> Result<String, Status> {
    let current = time::OffsetDateTime::now_utc();

    let format =
        time::format_description::parse("[year]-[month]-[day] [hour]:[minute]:[second] UTC")
            .map_err(|_| Status::internal("failed while building time format"))?;

    current
        .format(&format)
        .map_err(|_| Status::internal("failed while building format"))
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // let addr = "[::1]:8080".parse()?;
    let addr = "0.0.0.0:8080".parse()?;
    let server = CardService::default();

    Server::builder()
        .add_service(CardServer::new(server))
        .serve(addr)
        .await?;
    Ok(())
}
