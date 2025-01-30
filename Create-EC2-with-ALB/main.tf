#create aws key pair
resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create an EC2 instance
resource "aws_instance" "server1" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet1.id
  key_name      = aws_key_pair.mykey.key_name
  tags = {
    name = "myserver1"
  }
  user_data              = base64encode(file("userdata1.sh"))
  vpc_security_group_ids = [aws_security_group.sg1.id]
}

#Create an EC2 instance
resource "aws_instance" "server2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet2.id
  key_name      = aws_key_pair.mykey.key_name
  tags = {
    name = "myserver2"
  }
  user_data              = base64encode(file("userdata2.sh"))
  vpc_security_group_ids = [aws_security_group.sg1.id]
}