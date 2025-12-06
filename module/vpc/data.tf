data "aws_availability_zones" "available_zones" {
    state = "available"
    region = var.aws_region
}
