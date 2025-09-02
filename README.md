# Ingredient Analysis App (Flutter)


## 📌 Description
2024년에 개발한 **성분표 분석 어플리케이션**입니다.  
이 앱은 사용자가 업로드한 성분표 이미지를 기반으로 성분을 인식하고,  
데이터베이스와 연동하여 **의약품/식품 성분 정보** 및 **알레르기 유발 성분** 여부를 확인할 수 있도록 도와줍니다.  


- **Framework**: Flutter  
- **Language**: Dart  
- **Database**: MySQL  
- **Development Time**: 2024  

---

## ✨ Features
- **User Authentication**: 회원가입 및 로그인 기능  
- **OCR & Ingredient Analysis**: 이미지 기반 성분표 인식 및 분석  
- **Allergy Data Management**: 사용자 알러지 정보 저장 및 조회  
- **Secure Storage**: 사용자 정보 암호화 및 로컬 저장소 활용  
- **UI/UX**: 직관적인 성분 정보 확인 화면과 설정 화면 제공  

---

## 🛠️ Tech Stack
| Component         | Technology            |
|-------------------|-----------------------|
| Framework         | Flutter               |
| Language          | Dart                  |
| Database          | MySQL                 |
| Authentication    | Custom login/signup   |
| Storage & Security| Flutter Secure Storage, Encryption |

---

## 📂 Project Structure
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
3. Connect to your database by configuring `DBConnect.dart`.
4. Run the app:

   ```bash
   flutter run
   ```

---

## 🚀 Usage

* Launch the app → 회원가입 또는 로그인 진행
* 성분표 이미지 업로드 → OCR 및 성분 분석 진행
* 결과 화면에서 **성분 정보** 및 **알러지 경고** 확인

---

## 📜 License

This project is licensed under the MIT License.

---

## 👩‍💻 Author

Developed by GYEONGEUN PARK/MINYOUNG KIM/SAEEUN KIM, 2024.

