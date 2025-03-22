terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true # Отключаем проверку через AWS API
    skip_requesting_account_id  = true # Отключаем запросы к AWS STS и IAM
  }
}