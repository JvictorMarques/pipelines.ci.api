resource "aws_iam_openid_connect_provider" "oidc-github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com.cn"
  ]
  thumbprint_list = [
    "74f3a68f16524f15424927704c9506f55a9316bd"
  ]
  tags = {
    IAC = "True"
  }
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Effect : "Allow",
          Action : "sts:AssumeRoleWithWebIdentity",
          Principal : {
            "Federated" : "arn:aws:iam::864981720117:oidc-provider/token.actions.githubusercontent.com"
          },
          Condition : {
            StringEquals : {
              "token.actions.githubusercontent.com:aud" : [
                "sts.amazonaws.com.cn"
              ],
              "token.actions.githubusercontent.com:sub" : [
                "repo:JvictorMarques/pipelines.ci.api:ref:refs/heads/main"
              ]
            }
          }
        }
      ]
  })

  inline_policy {
    name = "ecr-permission"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "Statement1"
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:GetAuthorizationToken"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Sid = "Statement2"
          Action = [
            "apprunner:*"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Sid = "Statement3"
          Action = [
            "iam:PassRole",
            "iam:CreateServiceLinkedRole"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  tags = {
    IAC = "True"
  }
}
resource "aws_iam_role" "app-runner-role-policy" {
  name = "app-runner-role-policy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  tags = {
    IAC = "True"
  }
}
