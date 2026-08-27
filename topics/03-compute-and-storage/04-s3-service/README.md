# AWS S3 (Simple Storage Service)

Amazon S3 is an object storage service that offers industry-leading scalability, data availability, security, and performance.

> **Pricing Note:** All prices below are based on the **ap-southeast-3 (Jakarta)** region as of 2026. Jakarta region has approximately an **18% premium** compared to us-east-1 (N. Virginia).

---

## S3 Storage Classes Pricing Overview (Jakarta)

| Storage Class | Storage Cost ($/GB-month) | Retrieval Fee ($/GB) | Monitoring Fee | Min Duration | Min Size |
|---------------|---------------------------|----------------------|----------------|--------------|----------|
| S3 Standard | $0.027 (first 50TB) | None | None | None | None |
| S3 Intelligent-Tiering | $0.027 | None (varies by tier) | $0.0025/1K objects | None | None |
| S3 Standard-IA | $0.0148 | $0.01 | None | 30 days | 128 KB |
| S3 Express One Zone | $0.192 | None (same AZ) | None | None | 512 KB |
| S3 One Zone-IA | $0.0118 | $0.01 | None | 30 days | 128 KB |
| S3 Glacier Instant | $0.0047 | $0.03 | None | 90 days | 128 KB |
| S3 Glacier Flexible | $0.0042 | $0.01 - $0.03 | None | 90 days | 40 KB |
| S3 Glacier Deep Archive | $0.0012 | $0.0025 | None | 180 days | 40 KB |

---

## 1. S3 Standard

**Description:** Default, general-purpose storage for frequently accessed data (hot data) with very low latency and high throughput.

**How it works:** Stores and replicates objects simultaneously across a minimum of 3 Availability Zones (AZs) upon upload.

**Use cases:** Static websites, mobile applications, content distribution, active big data analytics, and high-traffic API backends.

**Access time:** Milliseconds.

**Advantages:** Lowest latency, best performance for access-intensive workloads, no operational restrictions or penalties.

**Disadvantages:** Very expensive if used for infrequently accessed or historical backup data.

### Pricing (ap-southeast-3 / Jakarta)

| Tier | Storage Cost | Notes |
|------|-------------|-------|
| First 50 TB/month | $0.027/GB | Standard tier |
| Next 450 TB/month | $0.026/GB | Volume discount |
| Over 500 TB/month | $0.025/GB | Highest volume |
| PUT/COPY/POST/LIST requests | $0.005/1,000 requests | Per request |
| GET/SELECT requests | $0.0004/1,000 requests | Per request |
| Data transfer out to internet | $0.106/GB | First 10TB/month |
| Data transfer out to CloudFront | Free | Same region |

| Attribute | Value |
|-----------|-------|
| Availability | Minimum 3 AZs (99.99% SLA) |
| Durability | 99.999999999% (11 nines) |
| Minimum Retention | None |
| Minimum Size | None |

---

## 2. S3 Intelligent-Tiering

**Description:** Automatically optimizes storage costs without compromising performance. Ideal for data with unknown or changing access patterns.

**How it works:** S3 continuously monitors object access patterns. If an object is not accessed for 30 days, it is automatically moved from the Frequent Access tier to the Infrequent Access tier. If the Archive Access option is enabled, objects not accessed for 90 days are moved to the Archive tier. There are no retrieval or transfer fees.

**Use cases:** Data lakes, data analytics, user-generated content, or new application data with unpredictable access history.

**Access time:** Milliseconds for Frequent, Infrequent, and Instant Archive tiers. Hours for Archive and Deep Archive tiers.

**Advantages:** Automatic cost savings without complex Lifecycle Rules. No surprise charges if cold data is suddenly accessed.

**Disadvantages:** Additional monitoring fees. Not cost-effective for millions of very small files (under 128 KB).

### Pricing (ap-southeast-3 / Jakarta)

| Tier | Storage Cost | Notes |
|------|-------------|-------|
| Frequent Access | $0.027/GB | Same as S3 Standard |
| Infrequent Access | $0.0148/GB | Same as Standard-IA |
| Archive Access | $0.0047/GB | Same as Glacier Instant |
| Deep Archive Access | $0.0012/GB | Same as Glacier Deep Archive |
| Monitoring fee | $0.0025/1,000 objects/month | For objects over 128 KB |
| Retrieval fee | Free | No retrieval charges |

| Attribute | Value |
|-----------|-------|
| Availability | 2-3 AZs |
| Durability | 99.999999999% (11 nines) |
| Minimum Retention | None (no early deletion fees) |
| Minimum Size | None (objects under 128 KB stay in Frequent Access tier and are not monitored) |

---

## 3. S3 Standard-Infrequent Access (Standard-IA)

**Description:** Storage class for data that is accessed less frequently (warm data) but requires rapid access when needed, just like S3 Standard.

**How it works:** Stores data with cross-3-AZ durability at a lower per-GB price, but charges a retrieval fee when data is read.

**Use cases:** Backup files, disaster recovery, and report files accessed once a month.

**Access time:** Milliseconds.

**Advantages:** Same speed performance as S3 Standard at a lower storage cost.

**Disadvantages:** If predictions are wrong and data is frequently downloaded, monthly bills can spike due to retrieval fees.

### Pricing (ap-southeast-3 / Jakarta)

| Component | Cost | Notes |
|-----------|------|-------|
| Storage | $0.0148/GB-month | ~45% cheaper than Standard |
| PUT/COPY/POST/LIST requests | $0.005/1,000 requests | Same as Standard |
| GET/SELECT requests | $0.0004/1,000 requests | Same as Standard |
| Retrieval fee | $0.01/GB | Charged per GB downloaded |
| Data transfer out | $0.106/GB | First 10TB/month |

| Attribute | Value |
|-----------|-------|
| Availability | Minimum 3 AZs (99.9% SLA) |
| Durability | 99.999999999% (11 nines) |
| Minimum Retention | 30 days (full charge applies if deleted earlier) |
| Minimum Size | 128 KB (objects smaller than 128 KB are billed as 128 KB) |

---

## 4. S3 Express One Zone

**Description:** Highest-performance storage class in S3, designed for processing application data with single-digit millisecond latency.

**How it works:** Uses Directory Bucket architecture and stores data in only 1 Availability Zone (AZ) chosen by the user, positioned close to compute resources (EC2 or EKS) to maximize transfer speed.

**Use cases:** Machine Learning / AI training, High-Performance Computing (HPC), real-time media processing, and interactive analytics.

**Access time:** 1 to 5 milliseconds (fastest among all S3 classes).

**Advantages:** Extreme performance with very stable latency, supporting hundreds of thousands of transactions per second (TPS). API request fees are up to 50% cheaper than S3 Standard.

**Disadvantages:** Vulnerable to data loss if the physical AZ experiences a disaster, as there is no replication to other AZs.

### Pricing (ap-southeast-3 / Jakarta)

| Component | Cost | Notes |
|-----------|------|-------|
| Storage | $0.192/GB-month | ~7x more expensive than Standard |
| PUT/COPY/POST/LIST requests | $0.0025/1,000 requests | 50% cheaper than Standard |
| GET/SELECT requests | $0.0002/1,000 requests | 50% cheaper than Standard |
| Data transfer out | $0.106/GB | First 10TB/month |

| Attribute | Value |
|-----------|-------|
| Availability | 1 AZ (99.95% SLA) |
| Durability | 99.999999999% (11 nines) within that single AZ |
| Minimum Retention | None |
| Minimum Size | 512 KB (objects under 512 KB are billed as 512 KB) |

---

## 5. S3 One Zone-Infrequent Access (One Zone-IA)

**Description:** A cheaper version of Standard-IA, intended for infrequently accessed data that is non-critical or can be recreated if lost.

**How it works:** Data is stored in only 1 AZ, reducing AWS infrastructure costs and passing savings to the user.

**Use cases:** Secondary backup copies (while primary backup is on-premise), image thumbnails that can be regenerated from originals.

**Access time:** Milliseconds.

**Advantages:** Most affordable millisecond-access option in the S3 ecosystem.

**Disadvantages:** Risk of permanent data loss if the AZ is physically destroyed (e.g., earthquake, data center fire).

### Pricing (ap-southeast-3 / Jakarta)

| Component | Cost | Notes |
|-----------|------|-------|
| Storage | $0.0118/GB-month | ~20% cheaper than Standard-IA |
| PUT/COPY/POST/LIST requests | $0.005/1,000 requests | Same as Standard |
| GET/SELECT requests | $0.0004/1,000 requests | Same as Standard |
| Retrieval fee | $0.01/GB | Charged per GB downloaded |
| Data transfer out | $0.106/GB | First 10TB/month |

| Attribute | Value |
|-----------|-------|
| Availability | 1 AZ (99.5% SLA) |
| Durability | 99.999999999% (11 nines), but vulnerable at the AZ level |
| Minimum Retention | 30 days |
| Minimum Size | 128 KB |

---

## 6. S3 Glacier Instant Retrieval

**Description:** Instant archive storage class. For data accessed rarely (once per quarter) but must be available immediately when needed.

**How it works:** Stores data in a compressed/archive structure similar to Glacier, but AWS keeps the index in a faster layer to ensure instant response.

**Use cases:** Medical image archives, old insurance claim documents, CCTV footage that may be suddenly requested by authorities.

**Access time:** Milliseconds.

**Advantages:** Bridges the gap between Glacier's low price and Standard-IA's instant access requirements. 68% cheaper than Standard-IA.

**Disadvantages:** Penalty fees for frequent data access can escalate quickly. Retention penalties are stricter (90 days).

### Pricing (ap-southeast-3 / Jakarta)

| Component | Cost | Notes |
|-----------|------|-------|
| Storage | $0.0047/GB-month | 68% cheaper than Standard-IA |
| PUT/COPY/POST/LIST requests | $0.005/1,000 requests | Same as Standard |
| GET/SELECT requests | $0.0004/1,000 requests | Same as Standard |
| Retrieval fee | $0.03/GB | Highest among instant-response classes |
| Data transfer out | $0.106/GB | First 10TB/month |

| Attribute | Value |
|-----------|-------|
| Availability | Minimum 3 AZs (99.9% SLA) |
| Durability | 99.999999999% (11 nines) |
| Minimum Retention | 90 days |
| Minimum Size | 128 KB |

---

## 7. S3 Glacier Flexible Retrieval

**Description:** Traditional archive storage (offline storage) for data accessed 1-2 times per year that can tolerate retrieval delays.

**How it works:** Objects are frozen and cannot be downloaded directly (GET). Users must submit a Restore Request. AWS unpacks the archive to a temporary staging area before it can be downloaded.

**Use cases:** Media recording archives, annual operational data recovery, and passive database backups.

**Access time:** Depends on the retrieval option:
- **Expedited:** 1-5 minutes
- **Standard:** 3-5 hours
- **Bulk:** 5-12 hours (free)

**Advantages:** Well-balanced option for massive backups due to low storage cost and free bulk retrieval.

**Disadvantages:** Applications or users cannot read files in real-time; data must go through a staging process first.

### Pricing (ap-southeast-3 / Jakarta)

| Component | Cost | Notes |
|-----------|------|-------|
| Storage | $0.0042/GB-month | ~84% cheaper than Standard |
| PUT/COPY/POST/LIST requests | $0.005/1,000 requests | Same as Standard |
| GET/SELECT requests | $0.0004/1,000 requests | Same as Standard |
| **Retrieval fees:** | | |
| - Expedited | $0.03/GB | 1-5 minutes |
| - Standard | $0.01/GB | 3-5 hours |
| - Bulk | Free | 5-12 hours |
| Data transfer out | $0.106/GB | First 10TB/month |

| Attribute | Value |
|-----------|-------|
| Availability | Minimum 3 AZs (99.99% SLA) |
| Durability | 99.999999999% (11 nines) |
| Minimum Retention | 90 days |
| Minimum Size | 40 KB |

---

## 8. S3 Glacier Deep Archive

**Description:** The deepest and cheapest cold storage class in AWS, designed as a replacement for on-premise tape library systems.

**How it works:** Data is locked in AWS cold-storage infrastructure. Recovery requests enter a long queue (retrieving data from automated tape libraries).

**Use cases:** Legal and regulatory compliance (e.g., medical records or banking data required to be stored for 7-10 years), historical research data kept solely for archival purposes.

**Access time:** Slowest of all. Standard retrieval: 12 hours. Bulk retrieval: up to 48 hours.

**Advantages:** Provides extraordinary cost efficiency for petabyte-scale data volumes mandated by law. Under $1 USD per Terabyte per month.

**Disadvantages:** Data is completely non-operational. Up to 2-day wait times make this tier irrelevant for critical system Disaster Recovery.

### Pricing (ap-southeast-3 / Jakarta)

| Component | Cost | Notes |
|-----------|------|-------|
| Storage | $0.0012/GB-month | ~96% cheaper than Standard |
| PUT/COPY/POST/LIST requests | $0.005/1,000 requests | Same as Standard |
| GET/SELECT requests | $0.0004/1,000 requests | Same as Standard |
| **Retrieval fees:** | | |
| - Standard | $0.02/GB | 12 hours |
| - Bulk | $0.0025/GB | 48 hours |
| Data transfer out | $0.106/GB | First 10TB/month |

| Attribute | Value |
|-----------|-------|
| Availability | Minimum 3 AZs (99.99% SLA) |
| Durability | 99.999999999% (11 nines) |
| Minimum Retention | 180 days |
| Minimum Size | 40 KB |

---

## 9. S3 Lifecycle Policies

An automation feature that transfers objects between storage classes or deletes them automatically. For example, deleting logs after 90 days to reduce costs.

---

## 10. S3 Data Protection and Security

### Versioning

Protects data from accidental or intentional deletion and overwriting, and enables recovery.

**How it works:** Every version of an object is stored when uploaded, overwritten, or deleted.

### S3 Object Lock (WORM - Write Once, Read Many)

Prevents objects from being deleted or modified for a specified period.

**How it works:** Applies a policy that restricts deletion of an object in S3 for a defined duration.

**Object Lock Modes:**

| Mode | Description |
|------|-------------|
| **Governance Mode** | Regular users cannot modify or remove this permission. Only administrators can change the retention period. |
| **Compliance Mode** | Once set, no one can alter the object. The only option is to wait for the retention period to expire. |

### Block Public Access

An AWS feature that configures permissions at the bucket or account level to prevent public data exposure on S3 buckets.

| Option | Description | Use Case |
|--------|-------------|----------|
| **BlockPublicAcls** | Rejects creation of new ACLs that grant public access to an S3 bucket. | Prevents developers or cloud administrators from uploading objects with `--acl public-read`. |
| **IgnorePublicAcls** | Ignores all existing public ACLs on the S3 bucket. | Neutralizes risk if objects were previously made public via ACL. Preferred over deleting the ACLs. |
| **BlockPublicPolicy** | Rejects adding or changing permissions that grant open public/internet access (e.g., `principal: "*"`). | Ensures no user can apply or modify a bucket policy with public access. |
| **RestrictPublicBuckets** | Restricts access to buckets with public policies to only AWS services or authenticated users within the same AWS account. | Isolates public-facing buckets so only internal services and users can access them. For public content, use a CDN instead of direct S3 access. |

Masalah Kebocoran Anggaran: Saat mengunggah file besar (>100 MB), SDK AWS memecah file menjadi puluhan bagian (multipart upload). Jika koneksi internet terputus di pertengahan proses, bagian-bagian file yang sudah terunggah akan mengendap di S3 selamanya. File ini tidak terlihat di konsol S3 biasa, tetapi AWS tetap menagih biaya penyimpanannya tiap bulan.

Solusi Wajib: Selalu aktifkan aturan Lifecycle Rule dengan opsi AbortIncompleteMultipartUpload (misalnya hapus potongan terputus setelah 7 hari) di setiap bucket produksi Anda.


s3 bucket keys
berfungsi untuk memproses object massal seperti memindahkan 1 juta file untuk masalah biaya api kms dan throtling 
saat diaktifkan s3 akan men cache kunci di kms di level bucket, alih alih memanggil kms setiap kali ada request file, maka s3 hanya memanggil kms sekali, ini akan memangkas biaya api call kms dan biayanya bisa hemat hingga 99% secara otomatis tanpa mengubah code application

ABAC (Attribute-Based Access Control) pada S3 bucket adalah metode pengamanan dan pengaturan hak akses berdasarkan atribut (karakteristik atau label), bukan sekadar mendaftarkan nama user atau grup secara manual (Role-Based Access Control / RBAC).

Server Access Logging adalah fitur di Amazon S3 yang berfungsi untuk mencatat setiap permintaan (request) yang masuk ke dalam S3 bucket kamu.

Berbeda dengan CloudTrail yang mencatat aktivitas manajemen API (seperti siapa yang membuat bucket atau mengubah policy), S3 Access Logging mencatat interaksi data secara langsung (siapa yang mendownload, meng-upload, menghapus, atau melihat daftar file di dalam bucket tersebut).

default encryption

bucket key
Cara kerja aslinya menggunakan sistem kunci turunan (hierarchy of keys):

Bukan Koneksi Terbuka (Bukan Handshake): S3 tidak membuka jalur koneksi khusus yang dibiarkan nyala terus ke KMS. S3 tetap menggunakan panggilan API standar berbasis request-response.

Sistem "Kunci Induk" (Bucket Key):

Saat kamu mau meng-upload 1 juta file, pada file pertama, S3 meminta 1 kunci master ke KMS untuk dijadikan Bucket Key.

Setelah S3 memegang Bucket Key ini, untuk 999.999 file berikutnya, S3 tidak lagi bertanya ke KMS. S3 secara mandiri membuat turunan kunci dari Bucket Key tersebut secara lokal di dalam S3 untuk mengenkripsi file-file baru.

Jadi, yang dihemat bukan koneksi jaringan yang di-handshake, melainkan frekuensi S3 memanggil API KMS.

Intinya: Daripada S3 menelepon KMS 1 juta kali untuk 1 juta file, dengan Bucket Key, S3 cukup "menelepon" KMS sekali di awal (atau sesekali saja saat memperbarui bucket key), lalu sisanya diurus sendiri menggunakan kunci tingkat bucket tersebut!

blocked encryptyon type
1. Fungsi Utama
Fitur ini digunakan oleh administrator cloud untuk memperketat keamanan dan kepatuhan (compliance) standar perusahaan. Jika suatu metode enkripsi masuk dalam daftar blokir, maka request seperti PutObject, CopyObject, PostObject, hingga multipart upload yang menggunakan metode enkripsi tersebut akan langsung ditolak oleh S3 dengan error 403 Access Denied

log delivery to cloudwatch
Log delivery to CloudWatch adalah fitur integrasi di Amazon S3 yang berfungsi untuk mengirimkan Server Access Logs (catatan atau rekam jejak aktivitas yang mengakses S3 bucket) secara langsung ke Amazon CloudWatch Logs.

ada 2 opsi
ke s3 atau ke cloudwatch