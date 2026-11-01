/// Uygulamanın çalıştığı dağıtım ortamı.
///
/// `name` değerleri (`dev`, `staging`, `prod`) DI ortam anotasyonları,
/// native flavor adları ve `config/<name>.json` dosyalarıyla birebir eşleşir.
enum AppEnvironment { dev, staging, prod }
