# Ingredient Analysis App 



## 📌 Description
This is an **Ingredient Analysis Application** developed in 2024.  
The app allows users to upload ingredient label images, recognize ingredients, and check **medicinal/food ingredient information** as well as **potential allergy-causing components** by linking with a database.  

- **Framework**: Flutter  
- **Language**: Dart  
- **Database**: MySQL  
- **Development Time**: 2024  

---

## ✨ Features
- **User Authentication**: Sign-up and login functionality  
- **OCR & Ingredient Analysis**: Recognize and analyze ingredient labels from images  
- **Allergy Data Management**: Store and retrieve user allergy information  
- **Secure Storage**: Encrypt user information and utilize local storage  
- **UI/UX**: Intuitive interface for ingredient information and settings  

---

## 🛠️ Tech Stack
| Component         | Technology                       |
|-------------------|----------------------------------|
| Framework         | Flutter                          |
| Language          | Dart                             |
| Database          | MySQL                            |
| Authentication    | Custom login/signup              |
| Storage & Security| Flutter Secure Storage, Encryption |

---

## 📂 Project Structure
```

is\_app
├─ before
│  ├─ logInPage.dart          # User login logic
│  └─ signup.dart             # User sign-up logic
│
├─ common
│  ├─ CropImage.dart          # Image cropping logic
│  └─ SplashScreen.dart       # Splash screen
│
├─ config
│  ├─ DBConnect.dart          # Database connection logic (with DTOs)
│  ├─ StorageService.dart     # Local storage service logic
│  └─ EncryptUser.dart        # User data encryption logic
│
├─ ingredientListScan
│  ├─ ViewIngredientInfo.dart # Provides ingredient information
│  ├─ ImageModule.dart        # Ingredient label image processing
│  └─ IngredientFind.dart     # Query and display ingredient info
│
├─ user
│  ├─ SettingsScreen.dart     # Settings screen
│  ├─ UserAllergyData.dart    # User allergy management
│  ├─ UserInfo.dart           # User info management
│
├─ Main.dart                  # App entry point
└─ Menu.dart                  # Main menu page logic

````

---

## ⚙️ Installation
1. Clone the repository:
```bash
git clone https://github.com/Tmfprl/is_app.git
cd is_app
````

2. Install dependencies:

```bash
flutter pub get
```

3. Configure your database connection in `DBConnect.dart`.

4. Run the app:

```bash
flutter run
```

---

## 🚀 Usage

* Launch the app → Sign up or log in
* Upload an ingredient label image → OCR and ingredient analysis runs
* Check **ingredient information** and **allergy warnings** on the results screen

---

## 📜 License

This project is licensed under the MIT License.

---

## 👩‍💻 Authors

* GYEONGEUN PARK
* MINYOUNG KIM
* SAEEUN KIM, 2024

---
KOREAN.ver
# 성분 분석 앱


## 📌 프로젝트 개요
2024년에 개발한 **성분표 분석 어플리케이션**입니다.  
이 앱은 사용자가 업로드한 성분표 이미지를 기반으로 성분을 인식하고,  
데이터베이스와 연동하여 **의약품/식품 성분 정보** 및 **알레르기 유발 성분** 여부를 확인할 수 있도록 도와줍니다.  


- **Framework**: Flutter  
- **Language**: Dart  
- **Database**: MySQL  
- **Development Time**: 2024  

---

## ✨ 주요기능
- **User Authentication**: 회원가입 및 로그인 기능  
- **OCR & Ingredient Analysis**: 이미지 기반 성분표 인식 및 분석  
- **Allergy Data Management**: 사용자 알러지 정보 저장 및 조회  
- **Secure Storage**: 사용자 정보 암호화 및 로컬 저장소 활용  
- **UI/UX**: 직관적인 성분 정보 확인 화면과 설정 화면 제공  

---

## 🛠️ 기술 스택
| Component         | Technology            |
|-------------------|-----------------------|
| Framework         | Flutter               |
| Language          | Dart                  |
| Database          | MySQL                 |
| Authentication    | Custom login/signup   |
| Storage & Security| Flutter Secure Storage, Encryption |

---

## 📂 프로젝트 구조
```

is\_app
├─ before
│  ├─ logInPage.dart          # 회원 로그인 로직
│  └─ signup.dart             # 회원 가입 로직
│
├─ common
│  ├─ CropImage.dart          # 이미지 편집 로직
│  └─ SplashScreen.dart       # 시작 화면
│
├─ config
│  ├─ DBConnect.dart          # DB 서버 연결 로직 (DTO 포함)
│  ├─ StorageService.dart     # 내부 저장공간 로직
│  └─ EncryptUser.dart        # 사용자 정보 암호화 로직
│
├─ ingredientListScan
│  ├─ ViewIngredientInfo.dart # 의약품 성분 정보 제공 로직
│  ├─ ImageModule.dart        # 성분표 이미지 처리 로직
│  └─ IngredientFind.dart     # 성분 정보 조회 및 출력 로직
│
├─ user
│  ├─ SettingsScreen.dart     # 설정 화면 로직
│  ├─ UserAllergyData.dart    # 유저 알러지 정보 관리
│  ├─ UserInfo.dart           # 사용자 관리 로직
│
├─ Main.dart                  # 앱 진입점
└─ Memu.dart                  # 메인 메뉴 페이지 로직

````

---

## ⚙️ 설치 방법
1. Clone the repository:
   ````
   git clone https://github.com/Tmfprl/is_app.git
   cd is_app
   ````

2. Install dependencies:

   ````
   flutter pub get
   ````
3. Connect to your database by configuring `DBConnect.dart`.
4. Run the app:

   ````
   flutter run
   ````

---

## 🚀 사용 방법

* Launch the app → 회원가입 또는 로그인 진행
* 성분표 이미지 업로드 → OCR 및 성분 분석 진행
* 결과 화면에서 **성분 정보** 및 **알러지 경고** 확인

---

## 📜 라이선스

This project is licensed under the MIT License.

---

## 👩‍💻 개발자

Developed by GYEONGEUN PARK/MINYOUNG KIM/SAEEUN KIM, 2024.

