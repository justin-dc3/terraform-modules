variable "provider" {
    description = "Cloud service provider (default aws)"
    default = "aws"
}

variable "env" {
    description = "Deployment environment (default stage)"
    default = "stage"
}
output "env" {
    value = "${var.env}"
}

variable "region" {
    description = "Deployment region (default us-east-1)"
    default = "us-east-1"
}
output "region" {
    value = "${var.region}"
}

variable "shared_credentials_file" {
    description = "Location of provider credentials file"
    default = "~/.aws/credentials"
}

variable "profile" {
    default = "Credentials profile"
    default = "terraform@448905052389"
}

variable "name" {
    description = "Bucket name/identifier"
}
output "bucket name" {
    value = "${var.name}"
}

variable "versioning_enabled" {
    description = "Boolean - enable versioning? (default true)"
    default = true
}
output "versioning enabled" {
    value = "${var.versioning_enabled}"
}

variable "prevent_destroy" {
    description = "Boolean - terraform destroy blocked? (default true)"
    default = true
}
output "prevent destroy enabled" {
    value = "${var.prevent_destroy}"
}

terraform {
    backend = "s3" {
        bucket = "justin-dc3-dev-terraform-state"
        key    = "${var.env}/${var.region}/s3/${var.name}/terraform.state"
        region = "${var.region}"
        profile = "${var.profile}"
    }
}

provider "${var.provider}" {
    region = "${var.region}"
    shared_credentials_file = "${var.shared_credentials_file}"
    profile = "${var.profile}"
}

resource "aws_s3_bucket" "${var.name}" {
    bucket = "${var.name}"

    versioning {
        enabled = ${var.versioning_enabled}
    }

    lifecycle {
        prevent_destroy = ${var.prevent_destroy}
    }
}

output "bucket arn" {
    value = "${self.arn}"
}
