fungsi dari cost anomaly detection ini adalah
1. mendeteksi kebocoran biaya secepat mungkin
    membantu menemukan pembengkakan tagihan yang tidak di sengaja, misal salah konfigurasi yang dapat menyebabkan cost terlalu mahal dan serangan cryptojacking yang memakan resource sehingga menyebabkan biaya membengkak
2. mengurangi beban pemantauan manual
    cara manual kita pantau setiap hari menggunakan aws cost explorer dan membuat puluhan budget alert yang dimana ini akan sangat melelahkan, cukup gunakan aws cost anomaly detection untuk mengetahui ini semua
3. root cause analyst
    fitur ini juga membantu untuk mengidentifikasi apa yang menyebabkan lonjakan tersebut apakah akun tertentu, server tertentu or something like that

cara kerja
    1. mempelajari pola historis
        sistem mempelajari pola historis anda dari waktu ke waktu(mempertimbangkan hari dalam seminggu, tren musiman, dan pertumbuhan bisnis anda)
    2. pemantauan keberlanjutan
        setiap hari sistem membandingkan pengeluaran aktual anda dengan perkiraan ekspektasi biaya berdasarkan pola historis tersebut
    3. deteksi anomali
        jika ditemukan pengeluaran yang jauh diatas batas kewajaran statik(bukan sekedar naik biasa melainkan langsung spike), maka sistem akan langsung mengkategorisasikan sebagai anomaly
    4. evaluasi dampak finansial
        aws akan menghitung total total biaya eksra yang di akibatkan oleh anomali tersebut

parameter monitor
1. name your monitor
2. managed by aws or customer managed -> account IDs
3. monitor dimension 
    a. linked account
    b. cost category -> cost category key
    c. cost allocation tag -> cost allocation tag key
    d. aws service recomended
4. tags
next
1. alert subscriptions (create a new subscriptions or choose an existing subcriptions)
2. subcription name
3. alerting frequency (daily summaries -> alert recipients, weekly summaries -> alert recipients, individual alerts -> enter an amazon sns arn)
4. threshold ($ and %) bisa lebih dari 1