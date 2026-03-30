# TOPICS: PROVISIONER (FILE & REMOTE-EXEC), CONDITION, TRIGGERS
# Description: Uses provisioners to copy and execute setup scripts on EC2 instances
# NOTE: Provisioners are a last resort and should generally be avoided in favor of user_data

resource "null_resource" "public-server-user-data" {
  # TOPIC: CONDITION - Only run provisioners in prod environment
  count = var.environment == "prod" ? length(var.public_cidr_block) : 1

  # Ensures EC2 instances are created before attempting provisioners
  depends_on = [aws_instance.public-server]

  # TOPIC: TRIGGERS - Re-runs provisioners when template content changes
  # Recalculates on every apply if the script hash differs
  triggers = {
    script_hash = filesha1("${path.module}/user-data.sh.tftpl")
  }

  # SSH connection configuration for remote provisioners
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(pathexpand("~/.ssh/dev-mentor-keypair.pem"))
    host        = aws_instance.public-server[count.index].public_ip
  }

  # TOPIC: PROVISIONER - FILE
  # Copies the rendered script to the remote instance
  # Source can be: source parameter (local file path) OR content parameter (inline content)
  provisioner "file" {
    # Render the template with variables and copy the output
    content = templatefile("${path.module}/user-data.sh.tftpl", {
      vpc_name       = var.vpc_name
      instance_index = count.index + 1
    })
    # Remote destination path
    destination = "/tmp/user-data.sh"
  }

  # TOPIC: PROVISIONER - REMOTE-EXEC
  # Executes commands remotely on the instance
  # Can use 'inline' parameter for multiple commands OR 'scripts' parameter for script files
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/user-data.sh",
      "sudo /tmp/user-data.sh",
    ]
  }
}
