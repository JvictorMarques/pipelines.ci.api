resource "aws_ecr_repository" "jv-ci-api" {
  name                 = "jv-ci"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    IAC = "True"
  }
}