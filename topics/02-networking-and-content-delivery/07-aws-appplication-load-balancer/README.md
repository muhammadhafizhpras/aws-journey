load balancer name

scheme 
internet facing
- load balancer ip address type = ["ipv4", "dual stack", "dual stack withouth ipv4"]

internal
- load balancer ip address type = ["ipv4", "dual stack"]

Network Mapping
- VPC
- IP Pools = Enable Use IPAM pool for public ipv4 addresses
- AZ and Subnet
- Security Groups

Listeners and routing
- Protocol
- Port
Default Action
- Forward to target groups
    - forward to target group (target group, weight, enable target group stickiness)
- Redirect to URL
    - protocol
    - port
    enable custom host, path, query
    - status code
- Return fixed response
    - Response Code
    - Content Type
    - Respon body



Listener Tags
- key and value

add listener


FUNGSI

application load balancer berfungsi untuk membagi traffic secara merata ke sebuah server dan bekerja di layer 7

internet facing 
load balancer yang dilengkapi dengan alamat public ip dan dns sehingga dapat diakses secara langsung oleh pengguna melalui jaringan internet,
alb ditempatkan di public subnet dikarenakan bertindak sebagai pintu masuk dari internet ke app yang kita miliki

Internal
load balancer untuk private network dan tidak bisa mengakses internet
aws akan otomatis mengalokasikan alamat ip privat dari block cidr subnet yang anda pilih dalam vpc cocok digunakan untuk microservices architecture

IPAM Pool IPv4
berfungsi sebagai wadah terpusat untuk mengalokasikan, mengelola, dan mengontrol alamar ip public ipv4 yanf kita miliki di seluruh account dan vpc

listener
berfungsi untuk mengecek dan mendenegarkan request koneksi masuk dari client/pengguna berdasarkan port dan protokol yang kita tentukan dan juga untuk mengelola sertifikat ssl/tls
Example
membuat listener di port 80 untuk traffic biasa atau port 443 untuk traffic terenkripsi
Mengelola Sertifikat SSL/TLS
pada listener di port 443, kita memasang sertifikat SSL/TLS, Listener inilah yang melakukan deskripsi data (SSL Termination) sebelum meneruskan traffic ke server backend

ROUTING
Routing rules adalah sekumpulan kondisi dan tindakan yang dipasang pada listener untuk mengevaluasi request dari pengguna
1. condition : mencocokan kriteria dari isi paket, misal : "Apakah url nya di awali denga /api atau bukan"
kalo iya actionnya apa
2. action : Apa yang harus dilakukan alb jika kondisi terpenuhi, misal : "teruskan ke target group API atau redirect dari http ke https"

jadi mencocokan kriteria dari isi paket lalu mengeksekusi jika condition nya terpenuhi

Path-based-routing : mengarahkan berdasarkan path URL
Host-Based-Routing : mengarahkan berdasarkan nama domain/subdomain
HTTP header : mengarahkan berdasarkan header khusus atau metode HTTP(GET, POST)
Query string : mengarahkan berdasarkan parameter di URL
Redirect Action : mengalihkan request langsun tanpa ke server/ memaksa semua pengunjung menggunakan https
fixed response action : mengembalikan respon teks/HTML/HTTP status code langsung dari alb, misal : status 403/503 berfungsi untuk menampilkan halaman maintenance tanpa membebankan server backend

parameter didalam listener 
1. port and protocol binding
    berfungsi untuk mendengarkan koneksi, misal https di port 443
2. tls/ssl engine 
    mesin yang bertugas untuk melakukan handshake dan dekripsi enkripsi sebuah data 
3. http parser
    mesin yang membedah teks paket data http untuk membaca header path query cokie

flownya
user mengakses web kita 
1. inisiasi koneksi tcp dan tls handshake
    user menekan tombol di aplikasi. browser di user langsung mencari ip public alb dan membuka koneksi jaringan ke port 443
2. tls engine melakukan dekripsi ssl menjadi http polos
    lsitener menyambut koneksi ini karena ini port 443 , tls engine pada listenert melakukan proses handshake menggunakan sertifikast ssl/tls yang terpasang di lsitener lalu kuncu enkripsi dicocokan, setelah cocok paket data terenkripsi tadi didekripsi oleh listener menjadi data http mentah
3. http parser membedah paket data misal methodnya apa hostnya apa pathnya kemana
    HTTP Parser di dalam Listener membaca teks HTTP polos tersebut. Listener meng-ekstrak informasi penting seperti:

Method: POST

Host Header: tokosaya.com

Path: /checkout/pay

User-Agent: Mozilla/5.0... (Smartphone)

Cookie: session_id=abc123xyz

4. routing engine
    listener menyerahkan hsil bedahan data http tersebut ke routing engine
    routing engine mengevaluasi aturan dari atas ke bawah berdasarkan nomor prioritas
        cek rule priority 10: apakah pathnya /statis/* tidak cocok
        cek rule priority 20: apakah pathnya /checkout/* cocok
    karena cocok dengan rule priority 20, routing engine mengeksekusi action: forward ke target group payment

5. Tahap 6: Pengiriman ke EC2 Backend
ALB memilih salah satu server EC2 yang ada di dalam Target Group Payment yang statusnya Healthy (Sehat).

Data HTTP mentah/polos tersebut dikirim ke IP Privat server EC2 tujuan (misal: 10.0.2.45:8080).

