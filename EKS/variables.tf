variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string

}

variable "private_subnets" {
  description = "List of private subnets inside the VPC"
  type        = list(string)

}

variable "public_subnets" {
  description = "List of public subnets inside the VPC"
  type        = list(string)

}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string

}
variable "cluster_version" {
  description = "value of the EKS cluster"
  type        = string

}