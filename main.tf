
module "battle_test" {
  source = "./iam"
  role_name = "t14s"            # THE FIRST ROLE 
  project_tag = "tanks"
}

module "bucket-01" {
  source = "./s3"
  bucket_name = "tanks-final-bucket-abdi-63000"       # THE TANK'S FIRST BUCKET
  authorized_project = "tanks" 
}


module "bucket-02" {
  source = "./s3"
  bucket_name = "tanks-final-bucket-abdi-007"       # THE TANK'S SECOND BUCKET, CREATED SPERATELY WITHOUT THE ROLE
  authorized_project = "tanks" 
}

module "air_test" {
  source = "./iam"
  role_name = "t72s"                                # THE SECOND ROLE 
  project_tag = "alpha"
}
 
module "bucket-03" {
  source = "./s3"
  bucket_name = "alpha-final-bucket-abdi-006"     #  ALPHA'S BUCKET
  authorized_project = "alpha" 
}




