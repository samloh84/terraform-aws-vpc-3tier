variable "owner" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_name" {
  type = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "whitelist_incoming_http_request_cidr_blocks" {
  type = list(string)
  default = []
}
variable "whitelist_outgoing_http_request_cidr_blocks" {
  type = list(string)
  default = []
}






variable "management_network_cidr_blocks" {
  type = list(string)
  default = []
}
