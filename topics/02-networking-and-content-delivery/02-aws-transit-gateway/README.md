AWS Transit Gateway
layanan penghubung jaringan terpusah yang berfungsi sebagai hub untuk mengelola komunikasi antar vpc to vpc dan vpc to on prem

jika kita memiliki banyak vpc akan sangat melelahkan dan presentase human error nya akan sering terjadi, nah dengan  aws transiit gateway ini sebagai solusi dengan menyederhanakan kerumitan tersebut menjadi simple dan mudah dengan  konsep hub and spoke

hub and spoke = jaringan terpusat di satu titik lalu di sebarkan ke jaringan lain

Cara Kerja AWS Transit Gateway
Bayangkan Transit Gateway seperti router pusat atau switch raksasa di dalam cloud AWS:

Setiap VPC, VPN connection, atau Direct Connect dihubungkan ke satu titik pusat (Transit Gateway) sebagai attachment.

Jika VPC A ingin berbicara dengan VPC B atau dengan jaringan kantor lokal, lalu lintasnya cukup dilewatkan ke Transit Gateway terlebih dahulu.

Transit Gateway kemudian akan merutekan (routing) paket data tersebut ke tujuan yang tepat berdasarkan tabel rute (route tables) yang telah dikonfigurasi.

Fitur Utama dan Keunggulan
Arsitektur Hub-and-Spoke yang Sederhana:

Menggantikan koneksi VPC Peering yang rumit (N x N koneksi) menjadi satu jalur terpusat melalui Transit Gateway. Penambahan VPC baru di masa depan menjadi sangat mudah karena cukup disambungkan ke hub pusat.

Konektivitas Lintas Akun AWS (Cross-Account Attachment):

Anda dapat menghubungkan VPC dari berbagai akun AWS yang berbeda ke satu Transit Gateway yang sama (menggunakan layanan AWS RAM / Resource Access Manager), sangat cocok untuk perusahaan besar dengan banyak divisi.

Mendukung Koneksi Hibrida (Hybrid Connectivity):

Tidak hanya antar-VPC di cloud, Transit Gateway juga bisa dihubungkan ke jaringan fisik lokal (on-premises) melalui AWS Site-to-Site VPN atau AWS Direct Connect.

Route Tables Kustom (Pemisahan Jalur):

Anda dapat membuat beberapa tabel rute di dalam satu Transit Gateway. Ini berguna untuk melakukan isolasi jaringan, misalnya memisahkan lalu lintas jaringan Production agar tidak bisa diakses secara sembarangan oleh jaringan Development.

Dukungan Multicast:

Transit Gateway mendukung lalu lintas jaringan jenis multicast (pengiriman data ke banyak penerima sekaligus), yang jarang didukung oleh layanan peering biasa.

amazon_side_asn = 64512
Masuk dalam Kategori Private ASN: Angka 64512 adalah awal dari rentang Private ASN (yaitu dari 64512 hingga 65534). Rentang ini dicadangkan secara internasional (berdasarkan standar RFC 6996) untuk penggunaan internal perusahaan atau pribadi, sehingga tidak akan berbenturan dengan nomor ASN publik yang terdaftar di internet.

dns_support
jika di aktifkan instance bisa saling resolve dns antar vpc yang terhubung ke transit gateway tersebut
prefer : enable

default_route_table_associatioin
untuk memasukan vpc baru langsung ke dalam table route di transit gateway
prefer : enable

default_route_table_propagation
untuk menyebarkan vpc baru ini ke jalur rutenya agar bisa langsung terhubung tanpa perlu membuat rule manual satu persatu
prefer : enable

vpn_ecmp_support
untuk menggabungkan beberapa jalur vpc sekaligus untuk membagi beban traffic secara rata dan meningkatkan bandwidth kapasitas serta redudancy dan sangat disarankan untuk selalu di nyalakan
prefer : enable

auto_accept_shared_attachments
jika ada account aws lain yang ingin menyambungkan vpc mereke ke transit gateway ini melalui aws ram(resource access manager) maka sistem tidak akan langsung menerimanya secara otomatis dan kita sebagai administrator harus menyetujui dan mengeceknya secara manual tersebut

multicast_support
apps moderm biasanya menggunakan jenis komunikasi unicast satu ke satu atau broadcast dan fitur multicast ini jarang sekali digunakan karena akan membebani jaringan serta tidak didukung di semua type instance

security_group_referencing_support
Biasanya, aturan Security Group (SG) di AWS hanya bisa merujuk ke SG lain di dalam VPC yang sama. Dengan mengaktifkan parameter security_group_referencing_support pada Transit Gateway, Anda bisa membuat aturan keamanan di satu VPC yang merujuk langsung ke Security Group dari VPC lain yang terhubung lewat Transit Gateway tersebut.

Contoh Kasus:
Anda punya Database VPC dan App VPC. Alih-alih harus mengetik alamat IP privat statis (CIDR block) di aturan Security Group database, Anda bisa langsung menuliskan: "Izinkan trafik masuk dari Security Group Application-Server yang ada di VPC sebelah."
