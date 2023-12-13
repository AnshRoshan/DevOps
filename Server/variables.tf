variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string

}

variable "public_subnets" {
  description = "List of public subnets inside the VPC"
  type        = list(string)

}
variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"

}
variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
}

variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
}