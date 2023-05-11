resource "aws_codecommit_repository" "*app-name" {
  repository_name = "*name"
  description     = "*App-name* with terraform"
}
