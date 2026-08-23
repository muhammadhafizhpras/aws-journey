#KMS for Encryption
resource "aws_kms_key" "s3_key" {
    description = "KMS Key for S3 Bucket Encryption"
}

# S3 Bucket
resource "aws_s3_bucket" "main" {
    bucket              = var.bucket_name
    object_lock_enabled = var.enable_object_lock
    force_destroy       = var.force_destroy

    tags = merge(
        local.common_tags,
        {Name = "${local.resource_name}"
    })
}

# Ownership
resource "aws_s3_bucket_ownership_controls" "name" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = var.object_ownership
  }
}

# Public Access Blocking
resource "aws_s3_bucket_public_access_block" "main" {
    bucket                  = aws_s3_bucket.main.id
    block_public_acls       = var.block_public_acls
    block_public_policy     = var.block_public_policy
    ignore_public_acls      = var.ignore_public_acls
    restrict_public_buckets  = var.restrict_public_buckets
}


# Versioning
resource "aws_s3_bucket_versioning" "main" {
    bucket  = aws_s3_bucket.main.id
    versioning_configuration {
        status = var.enable_versioning ? "Enabled" : "Suspended"
    }
}

# Encryption
# Encryption (Diperbaiki dengan menambahkan _configuration)
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
    bucket  = aws_s3_bucket.main.id

    rule {
        apply_server_side_encryption_by_default {
            kms_master_key_id   = aws_kms_key.s3_key.arn
            sse_algorithm       = "aws:kms"
        }
        bucket_key_enabled = true
    }
}

# Object Lock
resource "aws_s3_bucket_object_lock_configuration" "main" {
    count       = var.enable_object_lock ? 1 : 0
    depends_on  = [aws_s3_bucket_versioning.main]
    bucket      = aws_s3_bucket.main.id

    rule {
        default_retention {
            mode = var.object_lock_mode
            days = var.object_lock_days
        }
    }
}

# Intelligent-Tiering
resource "aws_s3_bucket_intelligent_tiering_configuration" "main" {
    count   = var.enable_intelligent_tiering ? 1 : 0
    bucket  = aws_s3_bucket.main.id
    name    = "CustomIntelligentTiering"

    tiering {
        access_tier = var.access_tier_it
        days        = var.intelligent_tiering_days
    }
    
}

# Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "main" {
    bucket = aws_s3_bucket.main.id

    rule {
        id     = "S3-Storage-Transition-Rule"
        status = "Enabled"
        filter {}

        # Transisi ke Standard IA
        dynamic "transition" {
            for_each = var.enable_standart_ia ? [1] : []
            content {
                days          = var.standart_ia_days
                storage_class = "STANDARD_IA"
            }
        }

        # Transisi ke Onezone IA
        dynamic "transition" {
            for_each = var.enable_onezone_ia ? [1] : []
            content {
                days          = var.onezone_ia_days
                storage_class = "ONEZONE_IA"
            }
        }

        # Transisi ke Glacier Flexible
        dynamic "transition" {
            for_each = var.enable_glacier_flexible ? [1] : []
            content {
                days          = var.glacier_flexible_days
                storage_class = "GLACIER"
            }
        }

        # Transisi ke Glacier Deep Archive
        dynamic "transition" {
            for_each = var.enable_glacier_deep_archive ? [1] : []
            content {
                days          = var.glacier_deep_archive_days
                storage_class = "DEEP_ARCHIVE"
            }
        }
    }
}

