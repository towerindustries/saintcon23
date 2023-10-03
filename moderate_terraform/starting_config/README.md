# Starting Config
Copy the files ```main.tf``` and ```nginxserver_amazon_deploy.sh``` to your working_directory.

## User-Data
Removed the large amount of shell script from user-data in main.tf to a shell script in the root directory.  This is a better practice.

```nginxserver_amazon_deploy.sh```  

Below is how you call an external shell script from within your main.tf file.

```
resource "aws_instance" "example" {
    user_data = file("nginxserver_amazon_deploy.sh")
}
```