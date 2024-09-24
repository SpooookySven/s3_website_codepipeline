resource "aws_codestarconnections_connection" "example" {
  name          = "s3_website-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "s3-website"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = "SpooookySven/s3_website"
        BranchName       = "main"
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      name     = "Deploy"
      category = "Deploy"
      owner    = "AWS"
      provider = "S3"
      version  = "1"
      input_artifacts = ["source_output"]

      configuration = {
        BucketName = "sven-herrmann-simple"
        Extract    = "true"
      }
    }
  }
}