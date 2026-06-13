# Create your 10+ core roles cleanly using the iam folder module
module "battle_test" {
  source = "./iam"
  role_name = "t14s"
  project_tag = "tanks"
}

module "bucket-01" {
  source = "./s3"
  bucket_name = "tanks-final-bucket-abdi-63000"
  authorized_project = "tanks" 
}


module "bucket-02" {
  source = "./s3"
  bucket_name = "tanks-final-bucket-abdi-007"
  authorized_project = "tanks" 
}

module "air_test" {
  source = "./iam"
  role_name = "t72s"
  project_tag = "alpha"
}
 
module "bucket-03" {
  source = "./s3"
  bucket_name = "alpha-final-bucket-abdi-006"
  authorized_project = "alpha" 
}




