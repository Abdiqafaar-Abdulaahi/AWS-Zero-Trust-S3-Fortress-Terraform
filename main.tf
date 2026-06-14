
module "battle_test" {
  source = "./iam"
  role_name = "TEAM-ALPHA-ROLE"            # THE FIRST ROLE 
  project_tag = "alpha"
}

module "bucket-01" {
 source = "./s3"
 bucket_name = "alpha-tanks-bucket-001"       # THE FIRST ROLE'S FIRST BUCKET
 authorized_project = "alpha" 
}


module "bucket-02" {
  source = "./s3"
  bucket_name = "alpha-tanks-bucket-002"       # THE FIRST ROLE'S SECOND BUCKET, CREATED SPERATELY WITHOUT THE ROLE
  authorized_project = "alpha" 
}

module "air_test" {
  source = "./iam"
  role_name = "TEAM-BETA-ROLE"                                # THE SECOND ROLE 
  project_tag = "beta"
}
 
module "bucket-03" {
  source = "./s3"
  bucket_name = "beta-t90m-bucket-001"     #  SECOND ROLE'S BUCKET
  authorized_project = "beta" 
}

module "bucket-04" {
  source = "./s3"
  bucket_name = "beta-t80m-bucket-002"     #  SECOND ROLE'S 2nd BUCKET
  authorized_project = "beta" 
}


module "sea_test" {
  source = "./iam"
  role_name = "TEAM-GAMMA-ROLE"                                # THE THIRD ROLE 
  project_tag = "gamma"
}

module "bucket-05" {
  source = "./s3"
  bucket_name = "gamma-t54-bucket-001"     #  THIRD ROLE'S BUCKET
  authorized_project = "gamma" 
}