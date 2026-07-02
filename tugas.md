# TUGAS DATA ENGINEERING

---

## 01 Transaction Analytics
include/sql/analytics/01_transaction_analytics.sql

---

### 1.Transaksi harian
<img width="753" height="973" alt="image" src="https://github.com/user-attachments/assets/ae3611cb-c646-4b3f-95d4-8ae2d240343c" />

### 2.Transaksi mingguan

<img width="753" height="1005" alt="image" src="https://github.com/user-attachments/assets/5f5640cb-1dd8-4477-b261-4fe6953ac303" />

### 3.Transaksi bulanan

<img width="753" height="1020" alt="image" src="https://github.com/user-attachments/assets/1ea31bf7-22af-4bc2-81da-3221c1b76eea" />

### 4.Pertumbuhan Bulanan

<img width="753" height="476" alt="image" src="https://github.com/user-attachments/assets/a594cd3e-9992-43b4-b1c8-51dbdcb423f6" />

Berdasarkan hasil analisis bulanan, jumlah transaksi dan total nominal transaksi mengalami fluktuasi dari bulan ke bulan. Pertumbuhan dihitung menggunakan persentase perubahan dibanding bulan sebelumnya (Month-over-Month). Pada beberapa bulan terjadi peningkatan, misalnya Mei 2023 (+10,09%) dan Juli 2024 (+7,75%), sedangkan penurunan terbesar terjadi pada Februari 2025 (-15,84%). Secara keseluruhan tidak terlihat tren naik atau turun yang konsisten karena dataset yang digunakan merupakan data simulasi yang dihasilkan secara acak.

---
## 02 Customer 360
include/sql/analytics/02_customer_360.sql

---
### 1.Top 10 nasabah paling aktif
<img width="753" height="310" alt="image" src="https://github.com/user-attachments/assets/1506e42f-5cd6-4cd4-a442-22794600592e" />

### 2.Top 10 berdasarkan nilai transaksi
<img width="753" height="208" alt="image" src="https://github.com/user-attachments/assets/bfde2531-c74b-4fe3-a931-94f17c3ace24" />

### 3.Distribusi segmen
<img width="438" height="162" alt="image" src="https://github.com/user-attachments/assets/410e219f-6892-42c7-8488-ef5d5bd7e194" />

## 03 Branch performance
include/sql/analytics/03_branch_performance.sql

---
### 1.Ranking cabang berdasarkan jumlah transaksi di setiap region. 
<img width="619" height="277" alt="image" src="https://github.com/user-attachments/assets/91c33926-2b9d-4f8b-a57b-c66c377e2560" />

### 2.Ranking cabang berdasarkan total nilai transaksi di setiap region.
<img width="622" height="311" alt="image" src="https://github.com/user-attachments/assets/ee93c012-30fc-4e25-a96f-ed8865013c58" />

## 04 Channel analysis
include/sql/analytics/04_channel_analysis.sql

---
### 1.Channel apa yang paling banyak digunakan nasabah? 

<img width="753" height="185" alt="image" src="https://github.com/user-attachments/assets/a51fa519-3ed3-4a64-be61-d30d5c3a337b" />

### 2.Bagaimana tren migrasi ke digital?

<img width="709" height="734" alt="image" src="https://github.com/user-attachments/assets/a0a70659-c5aa-40c7-a2da-296bd62b93f2" />

Berdasarkan data transaksi bulanan tahun 2023–2025, transaksi melalui channel digital (Mobile Banking, Internet Banking, dan Call Center/IVR) selalu lebih tinggi dibandingkan channel physical (ATM, Teller, dan EDC). Transaksi digital menjadi kanal utama nasabah, namun selama periode observasi belum terlihat adanya tren migrasi yang signifikan dari channel fisik menuju channel digital karena proporsi penggunaan kedua channel relatif stabil.

---
## 05 Product Performance

include/sql/analytics/05_product_performance.sql

---
<img width="753" height="90" alt="image" src="https://github.com/user-attachments/assets/607b3ab6-a516-4e53-975a-56ea954027a3" />

Produk paling aktif berdasarkan volume transaksi: Tabungan 
Produk dengan total nilai transaksi terbesar: Tabungan 
Produk dengan rata-rata saldo tertinggi: Tabungan (selisih tipis dengan Giro dan Deposito) 
Tabungan menjadi core product karena paling sering digunakan untuk transaksi sehari-hari seperti transfer, pembayaran, setor tunai, dan tarik tunai. 

--- 

## 06 Fraud detection
include/sql/analytics/06_fraud_detection.sql

---
### 1.Transaksi dengan nilai sangat besar (high value transaction). 
<img width="753" height="948" alt="image" src="https://github.com/user-attachments/assets/93f92614-68cb-42a1-a7bd-a73ac4273231" />

### 2.Nasabah dengan frekuensi transaksi tidak wajar. 

<img width="659" height="916" alt="image" src="https://github.com/user-attachments/assets/16a23015-2e3c-47e1-908b-f1f8f2ecf8fd" />

### 3.Transaksi dengan status FAILED berulang.

<img width="334" height="648" alt="image" src="https://github.com/user-attachments/assets/b1754ab5-a607-4abb-8c0e-ece1e31b0f75" />

### 4.FAILED rate per customer

<img width="692" height="899" alt="image" src="https://github.com/user-attachments/assets/3931e07d-b363-4851-a827-c078d3f2004f" />

### 5.Fraud label summary

<img width="507" height="200" alt="image" src="https://github.com/user-attachments/assets/d972c5ea-7b83-452f-b42c-1787a85566c6" />

### 6.Fraud transaction detail

<img width="753" height="545" alt="image" src="https://github.com/user-attachments/assets/955a157a-3f66-4f6b-8cb1-e0d41291272c" />

---

