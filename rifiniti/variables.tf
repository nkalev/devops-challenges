variable "aws_region" {
  description = "AWS region to use"
  default     = "eu-west-1"
}

variable "az_count" {
  description = "Number of AZs"
  default     = "2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "<aws_account_id>.dkr.ecr.eu-west-1.amazonaws.com/hello:latest"
}

variable "app_port" {
  description = "Port exposed by docker image"
  default     = 5000
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision"
  default     = "512"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision"
  default     = "2048"
}

variable "ecr_role" {
  description = "ECR role"
  default     = "arn:aws:iam::<aws_account_id>:role/iam-role"
}
