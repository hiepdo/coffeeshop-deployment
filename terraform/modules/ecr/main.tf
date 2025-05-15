resource "aws_ecr_repository" "repos" {
  for_each = toset(["web", "proxy", "barista", "kitchen", "counter", "product"])
  name     = "coffeeshop-${each.key}"
}