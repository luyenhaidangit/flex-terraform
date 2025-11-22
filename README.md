# flex-terraform

## Thiết lập AWS credentials cho Terraform

Terraform sẽ tự động lấy thông tin xác thực AWS theo thứ tự ưu tiên sau:

1) Biến môi trường (ưu tiên cao nhất)  
2) AWS CLI credentials (từ lệnh `aws configure`)

### Cách 1: Dùng AWS CLI credentials (phổ biến nhất)
Sau khi chạy lệnh:
```
aws configure
```
nhập lần lượt:
- AWS Access Key
- AWS Secret Key
- Default region

Terraform sẽ đọc thông tin từ các file:
- `~/.aws/credentials`
- `~/.aws/config`

Không cần thêm cấu hình khác trong `main.tf`. Bạn chỉ cần khai báo provider:
```hcl
provider "aws" {
  region = "ap-southeast-1"
}
```

### Cách 2: Dùng biến môi trường (ưu tiên cao hơn AWS CLI)
Thiết lập các biến môi trường (ví dụ trên Windows PowerShell):
```
setx AWS_ACCESS_KEY_ID "xxxx"
setx AWS_SECRET_ACCESS_KEY "yyyy"
setx AWS_DEFAULT_REGION "ap-southeast-1"
```
Hoặc dùng `set` cho phiên hiện tại:
```
set AWS_ACCESS_KEY_ID=xxxx
set AWS_SECRET_ACCESS_KEY=yyyy
set AWS_DEFAULT_REGION=ap-southeast-1
```

Khi các biến môi trường này tồn tại, Terraform sẽ sử dụng chúng thay vì cấu hình từ AWS CLI.
