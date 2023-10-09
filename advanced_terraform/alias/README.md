
```
variable "aws_regions" {
  default = [
    {
      region = "us-east-1"
      alias  = "default"
    },
    {
      region = "us-east-2"
      alias  = "useast2"
    },
    {
      region = "us-west-1"
      alias  = "uswest1"
    },
    {
      region = "us-west-2"
      alias  = "uswest2"
    },
    {
      region = "eu-central-1"
      alias  = "eucent1"
    }
  ]
}
```
