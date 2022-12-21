data "aws_route53_zone" "main" {
  name = "adorsys.io"
}

resource "aws_route53_zone" "tribe" {
  name = "tribe.adorsys.io"
}

resource "aws_route53_zone" "playground" {
  name = "playground.adorsys.io"
}

resource "aws_route53_record" "tribe" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "tribe.adorsys.io"
  type    = "NS"
  ttl     = "60"
  records = aws_route53_zone.tribe.name_servers
}

resource "aws_route53_record" "playground" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "playground.adorsys.io"
  type    = "NS"
  ttl     = "60"
  records = aws_route53_zone.playground.name_servers
}
