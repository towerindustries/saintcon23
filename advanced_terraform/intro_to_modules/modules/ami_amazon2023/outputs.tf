output "latest_amazon_linux_2023_ami_id" {
  value = data.aws_ami.latest_amazon_linux_2023.id
}