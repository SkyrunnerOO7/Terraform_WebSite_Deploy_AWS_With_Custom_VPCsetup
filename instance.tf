resource "aws_key_pair" "dove-key" {
  key_name   = "dovekey"
  public_key = file(var.PUB_KEY)
}

resource "aws_instance" "dove-web" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dove-pub-1.id
  key_name               = aws_key_pair.dove-key.key_name
  vpc_security_group_ids = [aws_security_group.dove_stack_sg.id]
  tags = {
    Name    = "Dove-Instance"
    Project = "my-dove"
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }

  connection {
    user        = var.USER
    private_key = file("dovekey")
    host        = self.public_ip
  }
}



output "PublicIP" {
  value = aws_instance.dove-web.public_ip
}

output "PrivateIP" {
  value = aws_instance.dove-web.private_ip
}