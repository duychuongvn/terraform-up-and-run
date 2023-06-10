variable "server_port" {
    type = number
    description = "Server Port"
    default = 8080
}

variable "instance_security_group_name" {
    type = string
    description = "Instance security group name"
    default = "terraform-example-security-group-name"
}

variable "alb_security_group_name" {
  description = "The name of the security group for the ALB"
  type        = string
  default     = "terraform-example-alb"
}
variable "alb_name" {
     type = string
    description = "alb name"
    default = "up-and-run-alb"
}