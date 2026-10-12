Trusted Advisor
layanan dari aws yangn berfungsi sebagai consultan virtual credits dimana layanan ini secara otomatis memindah dan mengevaluasi infrastruktur clous secara real time dan berkala lalu membandingkannya dengan 6 pilar best practice resmi dari aws
 
 6 pilar
 1. cost optimization
 berfokus untuk mendeteksi keborosan cloud(cloud waste)
 example : instance ec2 yang menyalam tapi menganggur atau idle, disk ebs terlepas yang masih dikanakan charge atau elastic ip yang tidak digunakan dan tidak terhubung ke instance manapun dengan aws trusted advisor ini di rekomendasikan untuk di release, jadi intinya dari cost optimization trusted advisor ini adalah untuk menghemat biaya pada akun aws dengan menscan service service yang digunakan agar berfungsi semua dan me rekomendasikan sebuah service untuk dimatikan atau di down scale jika based traffic tidak terpaakai

 2. security 
 berfokus untuk segi security pada akun dan service aws
 example : Ada Security Group yang membuka akses publik bebas (0.0.0.0/0) ke port sensitif (SSH/RDP), bucket S3 yang terbuka untuk umum (public read/write), atau akun Root yang belum mengaktifkan autentikasi dua faktor (MFA).

 3. Performance (Performa):  
 Memastikan aplikasi berjalan pada kecepatan dan kapasitas optimal.
 Contoh temuan: Mengidentifikasi penggunaan tipe instance generasi lama yang bisa diganti ke generasi baru dengan performa dan harga lebih baik.

 4. Resilience / Fault Tolerance (Ketahanan & Toleransi Kesalahan):  
 Memeriksa apakah arsitektur Anda dirancang tahan terhadap kegagalan (high availability).Contoh temuan: Load Balancer yang hanya mencakup satu Availability Zone (AZ) saja, atau database RDS yang belum mengaktifkan fitur Multi-AZ backup.

 5. Service Limits (Kuota Layanan / Quotas):
 Memantau batas maksimal penggunaan resource terhadap kuota yang diizinkan oleh AWS.  Contoh temuan: Memperingatkan jika jumlah VPC atau instance EC2 di suatu region sudah mencapai 80% atau lebih dari batas maksimal kuota akun Anda, sehingga Anda bisa mengajukan peningkatan kuota (limit increase) sebelum sistem mengalami gangguan

 6. Operational Excellence (Keunggulan Operasional):  
 Membantu menyelaraskan konfigurasi infrastruktur dengan standar operasional terbaik AWS (terintegrasi dengan AWS Config) untuk meminimalisir risiko manusia (human error)

 2. Indikator Status Kesehatan (Health Status)Hasil dari setiap pemindaian akan dikategorikan ke dalam tiga indikator visual di dalam dashboard AWS Console:
 🟢 Green (Hijau): Konfigurasi Anda sudah sesuai dengan standar best practices AWS.  
 🟡 Yellow (Kuning): Ditemukan potensi masalah atau konfigurasi yang sebaiknya ditinjau ulang (belum darurat).  
 🔴 Red (Merah): Ditemukan penyimpangan serius atau pemborosan nyata yang harus segera ditindaklanjuti.

 Basic Support (Tier Gratis / Free Tier):  Biaya: Rp0 (Gratis) untuk semua akun.  Fasilitas: Anda mendapatkan akses ke sekitar 56 pemeriksaan inti yang berfokus penuh pada Service Limits (kuota layanan) serta beberapa pemeriksaan dasar penting terkait keamanan dan ketahanan (seperti cek MFA root dan S3 bucket public).  
 Business Support+ (Paket Berbayar Standar):  Biaya: Mulai dari $29 per bulan per akun (atau persentase dari total tagihan bulanan AWS Anda, tergantung mana yang lebih besar).  Fasilitas: Membuka akses ke seluruh ratusan pemeriksaan lengkap (mencakup ratusan cek optimasi biaya mendalam, performa, dan operasional), fitur auto-refresh mingguan, serta akses penuh ke Trusted Advisor API/CLI untuk otomatisasi.  
 Enterprise Support / Unified Operations (Skala Korporat):Biaya: Mulai dari ribuan dolar per bulan.Fasilitas: Akses penuh ke seluruh fitur ditambah Trusted Advisor Priority (rekomendasi khusus yang diprioritaskan oleh Technical Account Manager/TAM).