pub static BASE64_ENGINE: base64::engine::GeneralPurpose = base64::engine::GeneralPurpose::new(
    &base64::alphabet::STANDARD,
    base64::engine::GeneralPurposeConfig::new(),
);

#[cfg(feature = "grpc")]
pub mod cards {
    tonic::include_proto!("cards");
}
