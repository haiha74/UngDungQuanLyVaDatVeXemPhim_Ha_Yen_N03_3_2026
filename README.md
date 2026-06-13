# Lập trình cho thiết bị di động-1-3-25(N03)
# UngDungQuanLyVaDatVeXemPhim_Ha_Yen_N03_3_2026

## Thành viên nhóm 
* Nguyễn Hải Hà - 23010469
* Vũ Thị Hải Yến - 23010421
# Ứng dụng Quản lý và Đặt vé xem phim

## 1. Giới thiệu dự án

Đây là ứng dụng quản lý và đặt vé xem phim được xây dựng bằng Flutter và Firebase. Ứng dụng hỗ trợ người dùng xem danh sách phim, xem chi tiết phim, chọn suất chiếu, chọn ghế, đặt vé và thanh toán. Ngoài ra, hệ thống còn có phần quản trị dành cho Admin để quản lý phim, phòng chiếu, ghế, suất chiếu, vé và thanh toán.

## 2. Thành viên nhóm

| STT | Họ và tên      | Mã sinh viên | Vai trò                                                                | Tỷ lệ đóng góp |
| --- | -------------- | ------------ | ---------------------------------------------------------------------- | -------------- |
| 1   | Nguyễn Hải Hà  | 23010469     | Phát triển chức năng người dùng, Firebase, đặt vé, thanh toán, báo cáo | 50%            |
| 2   | Vũ Thị Hải Yến | 23010421     | Phát triển chức năng Admin, CRUD, quản lý dữ liệu, giao diện quản trị  | 50%            |


## 3. Công nghệ sử dụng

| Công nghệ               | Mục đích                                   |
| ----------------------- | ------------------------------------------ |
| Flutter                 | Xây dựng giao diện ứng dụng đa nền tảng    |
| Dart                    | Ngôn ngữ lập trình chính                   |
| Firebase Core           | Kết nối ứng dụng Flutter với Firebase      |
| Cloud Firestore         | Lưu trữ dữ liệu phim, vé, booking, payment |
| Firebase Authentication | Quản lý đăng nhập và tài khoản người dùng  |
| Material Design         | Thiết kế giao diện ứng dụng                |

## 4. Chức năng chính

### Người dùng

* Xem danh sách phim.
* Xem chi tiết phim.
* Chọn suất chiếu.
* Chọn ghế ngồi.
* Đặt vé xem phim.
* Thanh toán vé.
* Xem lịch sử đặt vé.

### Quản trị viên

* Quản lý phim.
* Quản lý phòng chiếu.
* Quản lý ghế ngồi.
* Quản lý suất chiếu.
* Quản lý booking.
* Quản lý thanh toán.
* Quản lý vé.

## 5. Cấu trúc thư mục

```text
UngDungQuanLyVaDatVeXemPhim_Ha_Yen_N03_3_2026/
│
├── android/                  # Cấu hình chạy ứng dụng trên Android
├── ios/                      # Cấu hình chạy ứng dụng trên iOS
├── web/                      # Cấu hình chạy ứng dụng trên Web
├── windows/                  # Cấu hình chạy ứng dụng trên Windows
├── macos/                    # Cấu hình chạy ứng dụng trên macOS
├── linux/                    # Cấu hình chạy ứng dụng trên Linux
│
├── lib/                      # Thư mục mã nguồn chính
│   ├── main.dart             # File khởi chạy ứng dụng
│   ├── firebase_options.dart # Cấu hình Firebase
│   │
│   ├── models/               # Các class Model ánh xạ dữ liệu Firebase
│   │   ├── movie.dart
│   │   ├── booking.dart
│   │   ├── payment.dart
│   │   ├── room.dart
│   │   ├── seat.dart
│   │   └── showtime.dart
│   │
│   ├── pages/                # Các màn hình của ứng dụng
│   │   ├── home_page.dart
│   │   ├── movie_detail_page.dart
│   │   ├── booking_page.dart
│   │   ├── payment_page.dart
│   │   ├── ticket_history_page.dart
│   │   └── admin/            # Các màn hình quản trị
│   │       ├── admin_dashboard_page.dart
│   │       ├── admin_movies_page.dart
│   │       ├── admin_rooms_page.dart
│   │       ├── admin_seats_page.dart
│   │       ├── admin_showtimes_page.dart
│   │       ├── admin_bookings_page.dart
│   │       ├── admin_payments_page.dart
│   │       └── admin_tickets_page.dart
│   │
│   ├── services/             # Xử lý nghiệp vụ và thao tác Firebase
│   │   ├── movie_service.dart
│   │   ├── booking_service.dart
│   │   ├── payment_service.dart
│   │   ├── user_service.dart
│   │   └── admin_service.dart
│   │
│   └── widgets/              # Các widget dùng chung
│       ├── app_background.dart
│       ├── cinema_button.dart
│       ├── movie_card.dart
│       ├── section_title.dart
│       └── ticket_card.dart
│
├── test/                     # Thư mục kiểm thử
│   └── widget_test.dart
│
├── pubspec.yaml              # Khai báo thư viện và cấu hình project
├── pubspec.lock              # Thông tin phiên bản thư viện
├── analysis_options.yaml     # Quy tắc kiểm tra code Dart
└── README.md                 # Tài liệu mô tả project
```

## 6. Hướng dẫn cài đặt và chạy project

### Bước 1: Clone project từ GitHub

```bash
git clone https://github.com/haiha74/UngDungQuanLyVaDatVeXemPhim_Ha_Yen_N03_3_2026.git
```

### Bước 2: Di chuyển vào thư mục project

```bash
cd UngDungQuanLyVaDatVeXemPhim_Ha_Yen_N03_3_2026
```

### Bước 3: Cài đặt thư viện

```bash
flutter pub get
```

### Bước 4: Kiểm tra thiết bị chạy

```bash
flutter devices
```

### Bước 5: Chạy ứng dụng

Chạy trên Chrome:

```bash
flutter run -d chrome
```

Chạy trên Android Emulator:

```bash
flutter run
```

Chạy bằng web-server:

```bash
flutter run -d web-server
```

### Bước 6: Tài khoản kiểm thử

### Tài khoản Admin
Admin : admin@gmail.com / Mk : 123456
### Tài khoản User
User : eniuu127@gmail.com / Mk : eniuu127@ hoặc đăng ký tài khoản mới để sử dụng

## 7. Firebase

Project sử dụng Firebase Firestore để lưu trữ dữ liệu. Các collection chính gồm:

| Collection | Chức năng                 |
| ---------- | ------------------------- |
| movies     | Lưu thông tin phim        |
| rooms      | Lưu thông tin phòng chiếu |
| seats      | Lưu thông tin ghế         |
| showtimes  | Lưu thông tin suất chiếu  |
| bookings   | Lưu thông tin đặt vé      |
| payments   | Lưu thông tin thanh toán  |
| users      | Lưu thông tin người dùng  |

## Mục lục các bài tập thực hành trên lớp
* Bài thực hành 01 
* Bài thực hành 02
* Bài thực hành 03
* Bài kiểm tra giữa kỳ

## Bài thực hành 01 
### 1. Tạo repo nhóm 
<img width="1841" height="873" alt="image" src="https://github.com/user-attachments/assets/c5dc1a44-efdf-4623-bf98-6ee25d1e801c" />

### 2. Add thành viên (members) vào Repo nhóm 
<img width="1846" height="879" alt="image" src="https://github.com/user-attachments/assets/0adee863-9848-4c34-b083-8c23ee9a8868" />

### 3. Tạo một framework Flutter cho nhóm để làm việc từ buổi ngày 8/4/2026 đến hết môn học.
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/9b648b96-304f-460e-b5f1-231550e5d3bf" />

### 4. Thay đổi code trên repo : thay đổi title `main.dart` , thêm thông tin thành viên
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/88713aac-2c67-4b4c-a8a9-775d18269c6c" />

## Bài thực hành 02
### 1. Thực hiện sử dụng các biến vào trong file main.dart
![Câu 1](https://github.com/user-attachments/assets/ff7f0589-1393-497a-8862-45bd16108217)

### 2. Thực hiện sử dụng Collections (Array, List, Map) trong file main.dart cho dữ liệu đối tượng vừa miêu tả
![câu 2](https://github.com/user-attachments/assets/a705729b-2a8d-48db-a248-82a09b89059f)

## 3. Hiển thị dữ liệu
![câu1 1](https://github.com/user-attachments/assets/1580a803-304f-4bb2-8bd5-5f06ea8b609c)
![câu2 1](https://github.com/user-attachments/assets/94a17883-2c21-44bb-9725-21d4c65b69be)
![câu3](https://github.com/user-attachments/assets/0785a2a9-92f9-4511-a739-4f5d30da23a8)

## 4. Chụp ảnh màn hình chạy 
![chạy code](https://github.com/user-attachments/assets/fd31295c-ecee-4de4-9003-df6000faeecd)

## Bài thực hành 03 
### 1. <img width="1070" height="337" alt="image" src="https://github.com/user-attachments/assets/8ea059a4-4efc-47d5-beab-c14835d483ae" />

### 2. Xây dựng 01 Generics Class và in dữ liệu
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/88380b03-6ba8-4942-b512-04d129c6dca4" />

### 3. File : Movie.dart 
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/08d9a58d-1573-446f-8b37-f87ca6f22ddb" />

**Mô tả các biến của class Movie**

| Biến | Ý nghĩa |
|------|--------|
| movieId | mã phim |
| title | tên phim |
| description | mô tả phim |
| runtime | thời lượng phim |
| posterUrl | đường dẫn ảnh poster |
| trailerUrl | đường dẫn trailer |
| status | trạng thái phim |
| releaseDate | ngày phát hành |
| createdAt | thời gian tạo dữ liệu |
| showtimes | danh sách suất chiếu của phim |

**Mô tả các phương thức của class Movie**
| Phương thức | Ý nghĩa |
|------------|--------|
| hienThiThongTin() | hiển thị toàn bộ thông tin phim |
| capNhatTrangThai(String trangThaiMoi) | cập nhật trạng thái phim |
| capNhatThoiLuong(int thoiLuongMoi) | cập nhật thời lượng phim |
| toJson() | chuyển đối tượng Movie thành Map/JSON |
| fromJson() | tạo đối tượng Movie từ dữ liệu JSON |
| toString() | in dữ liệu đối tượng dưới dạng chuỗi |

### 4. File : list_movie.dart 
<img width="1099" height="744" alt="image" src="https://github.com/user-attachments/assets/b2fd6f0b-0163-42a7-9deb-ee0f045b495c" />

#### Create
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/be253171-6fd4-4bb3-ac11-0dd79c2bec18" />

#### Read 
<img width="1070" height="998" alt="image" src="https://github.com/user-attachments/assets/0b29c7da-66dc-40ac-81de-35f7be11eed6" />

#### Edit 
<img width="1029" height="733" alt="image" src="https://github.com/user-attachments/assets/0ec1dab0-96d1-4703-8a61-f0bec2937a4d" />

#### Demo 
<img width="749" height="840" alt="image" src="https://github.com/user-attachments/assets/505da6dd-d621-4819-8fbb-0fcb3cac6341" />

### 5. 

#### Link Repo : https://github.com/haiha74/UngDungQuanLyVaDatVeXemPhim_Ha_Yen_N03_3_2026.git

#### Link ReadMe : https://github.com/haiha74/UngDungQuanLyVaDatVeXemPhim_Ha_Yen_N03_3_2026/blob/main/README.md

# Bài kiểm tra giữa kỳ
## WebCinema - Ứng dụng Quản lý & Đặt vé xem phim

## Thông tin nhóm

* **Nguyễn Hải Hà**

  * Phụ trách: **Content**
* **Vũ Thị Hải Yến**

  * Phụ trách: **Home + About**

---

## Công nghệ sử dụng

* **Flutter**: Xây dựng giao diện đa nền tảng
* **Dart**: Ngôn ngữ lập trình chính
* **Material UI**: Thiết kế giao diện
* **Navigator**: Điều hướng giữa các màn hình
* **Widget tái sử dụng (`app_common.dart`)**:

  * Dùng chung **Header + Footer + Bottom Navigation**

---

## Phân chia công việc

---

### 1. Home Screen (Vũ Thị Hải Yến)

#### Công nghệ sử dụng

* `StatelessWidget`
* `SingleChildScrollView`
* `Column`, `Container`
* `BoxDecoration` (banner + bo góc)
* Dùng lại layout từ `app_common.dart`

#### Mô tả chức năng

* Hiển thị **banner chính**
* Hiển thị danh sách **phim nổi bật**
* Scroll ngang danh sách phim
* Điều hướng sang:

  * Content
  * About

---

### 2. Content Screen (Nguyễn Hải Hà)

#### Công nghệ sử dụng

* `GridView`
* `Card`
* `Image.network`
* `Text`, `Column`
* Layout dùng chung `app_common.dart`

#### Mô tả chức năng

* Hiển thị danh sách phim dạng **grid (lưới)**
* Mỗi phim gồm:

  * Ảnh
  * Tên phim
  * Thời lượng
* Giao diện giống app xem phim thực tế

---

### 3. About Screen (Vũ Thị Hải Yến)

#### Công nghệ sử dụng

* `Column`, `Text`, `Container`
* `Padding`, `SizedBox`
* `BoxDecoration`
* Dùng lại layout từ `app_common.dart`

#### Mô tả chức năng

* Hiển thị thông tin dự án:

  * Tên hệ thống
  * Mô tả chức năng
* Hiển thị thông tin nhóm:

  * Tên sinh viên
* Thiết kế theo **Figma template**

---

## Tái sử dụng Layout chung

Tất cả các màn hình đều sử dụng:

```
app_common.dart
```

### Bao gồm:

* Header (AppBar)
* Footer
* Bottom Navigation

## Hướng dẫn chạy project

```bash
flutter pub get
flutter run
```

---








