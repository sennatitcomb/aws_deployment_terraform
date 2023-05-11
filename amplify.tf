#Policy document specifying what service can assume the role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}
#IAM role providing read-only access to CodeCommit
resource "aws_iam_role" "*role-name*" {
  name                = "*name*"
  assume_role_policy  = join("", data.aws_iam_policy_document.assume_role.*.json)
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"]
}
resource "aws_amplify_app" "*app-name*" {
  name       = "*name*"
  repository = "https://git-codecommit.*region*.amazonaws.com/v1/repos/*app-name*"
  iam_service_role_arn = "arn:aws:iam::*role-number*:role/*app-name*"
  enable_branch_auto_build = true
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install
            - npm test -- --watchAll=false
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT
  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }
  environment_variables = {
    ENV = "dev"
  } 
}
resource "aws_amplify_branch" "develop" {
  app_id      = aws_amplify_app.*app-name*.id
  branch_name = "develop"
  framework = "React"
  stage     = "DEVELOPMENT"
}
resource "aws_amplify_branch" "master" {
  app_id      = aws_amplify_app.*app-name*.id
  branch_name = "master"
  framework = "React"
  stage     = "PRODUCTION"
}
