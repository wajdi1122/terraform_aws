resource "aws_sqs_queue" "this" {
 name                      = var.queue_name
 delay_seconds             = 0
 message_retention_seconds = 345600
 visibility_timeout_seconds = 30
}
