# InterviewAce - Test Guide
## ทำไมต้องเทส? เทสเพื่ออะไร?

Testing เป็นเกณฑ์บังคับของ Exam ต้องครบ 3 ระดับตาม **Testing Pyramid**:
- **Unit Test** — ทดสอบ Logic ทีละหน่วย
- **Widget Test** — ทดสอบ UI ว่าแสดงผลถูกต้อง
- **Integration Test** — ทดสอบแอปแบบ End-to-End

---

## คำสั่งรัน Test ทั้งหมด

```bash
flutter test
```
ผลลัพธ์ที่คาดหวัง: `+53: All tests passed!`

---

## รายละเอียดแต่ละไฟล์

### 1. Unit Test: HistoryBloc (9 tests)

**ทำไมต้องเทส?**
BLoC ที่จัดการประวัติสัมภาษณ์เป็นหัวใจของแอป ต้องมั่นใจว่าโหลดข้อมูลได้ ลบได้ เเละเมื่อ API ล้มเหลวจะแสดง Error ไม่ crash

```bash
flutter test test/features/history/presentation/bloc/history_bloc_test.dart
```

| Test | ทำไมต้องเทส |
|---|---|
| โหลดประวัติสำเร็จ | ต้องได้ข้อมูล 2 sessions จาก Repository |
| โหลดประวัติล้มเหลว | ต้องแสดง Error message ไม่ใช่ crash |
| ลบ session | ต้องเรียก deleteSession ใน Repository จริง |
| ดูรายละเอียด session | ต้องโหลด session + questions มาแสดง |
| ล้างทั้งหมด | ต้องลบทุก session แล้วแสดงรายการว่าง |
| isEmpty ว่าง | state ว่างต้อง return true |
| isEmpty มีข้อมูล | state มีข้อมูลต้อง return false |
| คะแนนเฉลี่ย | คำนวณ (80+60)/2 = 70 ถูกต้อง |

**เทคนิคที่ใช้:** mocktail (Mock Repository), bloc_test, dartz Either

---

### 2. Unit Test: SettingsBloc (10 tests)

**ทำไมต้องเทส?**
ต้องมั่นใจว่า Dark Mode เเละภาษาถูกบันทึกลง SharedPreferences ปิดแอปเปิดมาใหม่ค่ายังอยู่

```bash
flutter test test/features/settings/presentation/bloc/settings_bloc_test.dart
```

| Test | ทำไมต้องเทส |
|---|---|
| ค่าเริ่มต้น Dark Mode = false | ยืนยันว่าเริ่มเป็น Light Mode |
| toggle Dark Mode | สลับจาก false เป็น true ถูกต้อง |
| toggle สองครั้ง | กลับเป็น false เหมือนเดิม |
| เปลี่ยนภาษาเป็น th | UI ทั้งแอปต้องเปลี่ยนเป็นภาษาไทย |
| บันทึกค่า | ปิดเปิดแอปใหม่ค่ายังคงอยู่ |

**เทคนิคที่ใช้:** SharedPreferences.setMockInitialValues, bloc_test

---

### 3. Unit Test: DataExportService (10 tests)

**ทำไมต้องเทส?**
ระบบ Export ข้อมูลต้องสร้างไฟล์ CSV/JSON ที่ถูกต้อง ถ้าผิดรูปแบบจะเปิดไม่ได้

```bash
flutter test test/features/analytics/data/services/data_export_service_test.dart
```

| Test | ทำไมต้องเทส |
|---|---|
| CSV มี header | ต้องมี Session ID, Position, Company, Level |
| CSV มีข้อมูล session | ต้องมี session-1, Flutter Developer, Google |
| CSV ว่าง | ต้องมี header แต่ไม่มีแถวข้อมูล |
| JSON ถูกต้อง | ต้องมี exportDate, totalSessions, sessions |
| JSON มีข้อมูล | ต้องมี Flutter Developer, Google, score 85 |
| JSON format สวย | ต้องมีการเยื้อง (indentation) |
| Report ภาพรวม | ต้องมี Total Sessions: 2, Average Score |
| Report recent | ต้องมี Flutter Developer, Google |
| Report ว่าง | ต้อง return "No sessions to report." |
| คะแนนเฉลี่ย | (85+72)/2 = 78% ถูกต้อง |

---

### 4. Unit Test: Interview Entities (10 tests)

**ทำไมต้องเทส?**
Domain Entity เป็นหัวใจ Clean Architecture ถ้า Data Model พัง ทุกอย่างพัง

```bash
flutter test test/features/interview/domain/entities/interview_entities_test.dart
```

| Test | ทำไมต้องเทส |
|---|---|
| สร้าง Session มี UUID | ID ต้องยาว 36 ตัว (UUID v4) |
| Session มี timePerQuestion | ค่า 120 วินาทีต้องถูกเก็บ |
| copyWith อัพเดทบาง field | เปลี่ยน score ต้องไม่เปลี่ยน position |
| copyWith คงค่าเดิม | field ที่ไม่ได้ระบุต้องคงเดิม |
| สร้าง Question | ต้องเก็บคำถาม + category ได้ |
| Question copyWith | ต้องอัพเดท answer, score, feedback ได้ |
| Question suggestedKeywords | ต้องเก็บ keywords 3 ตัวได้ |
| ResumeProfile ครบ | ต้องเก็บ strengths, weaknesses ได้ |
| ResumeProfile minimal | field ที่ไม่ได้ใส่ต้องเป็น null |
| คะแนนเฉลี่ย | (90+70)/2 = 80 ถูกต้อง |

---

### 5. Widget Test: Login Page (6 tests)

**ทำไมต้องเทส?**
ระบบตรวจสอบฟอร์ม Login เป็นเกณฑ์ Form Validation ที่อาจารย์กำหนด

```bash
flutter test test/features/auth/presentation/pages/login_page_test.dart
```

| Test | ทำไมต้องเทส |
|---|---|
| Email ว่าง | ต้องแสดง 'Please enter your email' |
| Email ไม่มี @ | ต้องแสดง 'Please enter a valid email' |
| Password สั้น | ต้องแสดง 'Password must be at least 6 characters' |
| กรอกถูกต้อง | ต้องผ่าน validation + เรียก onSubmit |
| UI ครบ | ต้องมี TextFormField 2 ช่อง + ปุ่ม 1 ปุ่ม |

**เทคนิคที่ใช้:** GlobalKey<FormState> ตามเกณฑ์

---

### 6. Widget Test: Settings Page (7 tests)

**ทำไมต้องเทส?**
หน้าตั้งค่าต้องแสดง UI ครบทุกส่วน ทั้ง Dark Mode, ภาษา, Data management

```bash
flutter test test/features/settings/presentation/pages/settings_page_test.dart
```

| Test | ทำไมต้องเทส |
|---|---|
| แสดง Settings title | หัวข้อต้องขึ้น |
| แสดง Dark Mode toggle | Switch ต้องมี |
| แสดง English/ไทย | ตัวเลือกภาษาต้องครบ |
| แสดง Appearance | section ต้องครบ |
| แสดง Clear Cache | ปุ่มจัดการข้อมูลต้องมี |
| แสดง About + Version | ชื่อแอป + เวอร์ชันต้องแสดง |
| Dark Mode switch ค่าถูก | Switch = true เมื่อ state เป็น true |

**เทคนิคที่ใช้:** MockBloc จำลอง SettingsBloc

---

### 7. Integration Test (17 tests)

**ทำไมต้องเทส?**
ต้องมั่นใจว่าแอปทำงานได้ครบวงจร ทุกอย่างทำงานร่วมกันได้จริง

```bash
flutter test integration_test/app_test.dart
```

| กลุ่ม | ทำไมต้องเทส |
|---|---|
| เปิดแอป | ต้อง build สำเร็จ ไม่ crash |
| Form Validation | ฟอร์มว่างต้องแสดง error / กรอกถูกต้องต้องผ่าน |
| Navigation | ไป-กลับระหว่างหน้าต้องทำงานถูกต้อง |
| Theme Switch | สลับ Dark Mode แล้วค่าต้องเปลี่ยนจริง |

---

## สรุป Testing Pyramid

```
         /\
        /  \          Integration Test (17)
       /    \         ทดสอบแอปครบวงจร
      /------\
     /        \       Widget Test (13)
    /          \      ทดสอบ UI + Form Validation
   /------------\
  /              \    Unit Test (23)
 /                \   ทดสอบ Business Logic + Data Model
/------------------\
     53 Tests Total
```

| ระดับ | จำนวน | ไฟล์ |
|---|:---:|---|
| Unit Test | 23 | history_bloc, settings_bloc, data_export, entities |
| Widget Test | 13 | login_page, settings_page, widget_test |
| Integration Test | 17 | app_test |
| **รวม** | **53** | **8 ไฟล์** |
