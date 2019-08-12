resource "aws_iam_role" "backup" {
  name = "backup-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role = "${aws_iam_role.backup.name}"
}

resource "aws_backup_plan" "main" {
  name = "thecraftmine-backup-plan"

  rule {
    rule_name = "thecraftmine-backup-rule"
    target_vault_name = "${aws_backup_vault.main.name}"
    schedule = "cron(0 0 * * ? *)"
  }
}

resource "aws_backup_selection" "main" {
  iam_role_arn = "${aws_iam_role.backup.arn}"
  name = "thecraftmine-backup-selection"
  plan_id = "${aws_backup_plan.main.id}"
  resources = ["${data.aws_ebs_volume.main.arn}"]
}

resource "aws_backup_vault" "main" {
  name = "thecraftmine-backup-vault"
  kms_key_arn = "${aws_kms_key.main.arn}"
}

resource "aws_kms_key" "main" {
  description = "A minecraft backup key"
  deletion_window_in_days = 10
}
