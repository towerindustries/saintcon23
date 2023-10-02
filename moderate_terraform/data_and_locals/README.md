
# /saintcon23/moderate_terraform/data_and_locals/README.md


## CLI Search for AMI

Search for a specific AMI with image-ids.  
* The region command speeds it up.


```
aws ec2 describe-images \
    --region us-east-1 \
    --image-ids ami-054aaceda83e053ee
    --owners amazon
```
Search for an AMI owned by amazon with filters.

```
aws ec2 describe-images \
    --region us-east-1 \
    --owners amazon \
    --filters "Name=root-device-type,Values=ebs" "Name=virtualization-type,Values=hvm"
```

```
aws ec2 describe-images \
    --region us-east-1 \
    --filters "Name=root-device-type,Values=ebs" "Name=platform,Values=windows"
```
Notice there is a Platform category here but not on the Amazon Image.  It only works for windows.

```
aws ec2 describe-images \
    --region us-east-1 \
    --filters "Name=root-device-type,Values=ebs" "Name=platform,Values=windows" "Name=name,Values=al2023-ami-2023"
```
The Image that Terraform picks with our filters.
```
aws ec2 describe-images \
    --region us-east-1 \
    --image-ids ami-0779b302ed007c203
```


## Valid Image Filters
* architecture - The image architecture (i386 | x86_64 | arm64 | x86_64_mac | arm64_mac ).
* block-device-mapping.delete-on-termination - A Boolean value that indicates whether the Amazon EBS volume is deleted on instance termination.
* block-device-mapping.device-name - The device name specified in the block device mapping (for example, /dev/sdh or xvdh ).
* block-device-mapping.snapshot-id - The ID of the snapshot used for the Amazon EBS volume.
* block-device-mapping.volume-size - The volume size of the Amazon EBS volume, in GiB.
* block-device-mapping.volume-type - The volume type of the Amazon EBS volume (io1 | io2 | gp2 | gp3 | sc1 | st1 | standard ).
* block-device-mapping.encrypted - A Boolean that indicates whether the Amazon EBS volume is encrypted.
* creation-date - The time when the image was created, in the ISO 8601 format in the UTC time zone (YYYY-MM-DDThh:mm:ss.sssZ), for example, 2021-09-29T11:04:43.305Z . You can use a wildcard (* ), for example, 2021-09-29T* , which matches an entire day.
* description - The description of the image (provided during image creation).
* ena-support - A Boolean that indicates whether enhanced networking with ENA is enabled.
* hypervisor - The hypervisor type (ovm | xen ).
* image-id - The ID of the image.
* image-type - The image type (machine | kernel | ramdisk ).
* is-public - A Boolean that indicates whether the image is public.
* kernel-id - The kernel ID.
* manifest-location - The location of the image manifest.
* name - The name of the AMI (provided during image creation).
* owner-alias - The owner alias (amazon | aws-marketplace ). The valid aliases are defined in an Amazon-maintained list. This is not the Amazon Web Services account alias that can be set using the IAM console. We recommend that you use the Owner request parameter instead of this filter.
* owner-id - The Amazon Web Services account ID of the owner. We recommend that you use the Owner request parameter instead of this filter.
* platform - The platform. The only supported value is windows .
* product-code - The product code.
* product-code.type - The type of the product code (marketplace ).
* ramdisk-id - The RAM disk ID.
* root-device-name - The device name of the root device volume (for example, /dev/sda1 ).
* root-device-type - The type of the root device volume (ebs | instance-store ).
* state - The state of the image (available | pending | failed ).
* state-reason-code - The reason code for the state change.
* state-reason-message - The message for the state change.
* sriov-net-support - A value of simple indicates that enhanced networking with the Intel 82599 VF interface is enabled.
* tag :<key> - The key/value combination of a tag assigned to the resource. Use the tag key in the filter name and the tag value as the filter value. For example, to find all resources that have a tag with the key Owner and the value TeamA , specify tag:Owner for the filter name and TeamA for the filter value.
* tag-key - The key of a tag assigned to the resource. Use this filter to find all resources assigned a tag with a specific key, regardless of the tag value.
* virtualization-type - The virtualization type (paravirtual | hvm ).
