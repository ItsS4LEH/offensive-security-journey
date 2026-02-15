# رحلتي في تعلم الأمن السيبراني: من مختبر اختراق مبتدئ إلى متخصص في فريق الهجوم الأحمر - AR

# نظرة عامة

هذا المستند يوثق رحلتي في تعلم الأمن السيبراني، مع تركيز خاص على **اختبار الاختراق**. بدأت من مستوى مبتدئ وأوثق كل خطوة أثناء تقدمي نحو اكتساب مهارات متقدمة تشمل **عمليات الفريق الأحمر (Red Team)**.

تشمل رحلتي التعلم من مصادر متنوعة، التجربة العملية، التحليل الفني، ودراسة الهجمات الواقعية، مع التركيز على **فهم الثغرات وكيفية التعامل معها وتقليل آثارها**، وليس مجرد استغلالها.

كما يسجل المستند تجاربي في تحديات CTF، اختبارات الاختراق، برامج Bug Bounty، وأبحاث الأمن، ليكون مرجعًا شخصيًا لتتبع تقدمي وملاحظة تطور مهاراتي التقنية خطوة خطوة.

**بدأت الرحلة في: الثلاثاء، 27 مايو 2025 — الساعة 05:25 صباحًا**

---

## الشهادات والتدريب

---

## الأساسيات (الشبكات، الأنظمة، الويب، الموبايل)

---

## **برمجة الأدوات والأتمتة الأمنية**

---

## تقييم الثغرات والتقارير

---

## اختبار اختراق تطبيقات الويب

### منصة TryHackMe

### منصة Hack The Box

### دليل OWASP لاختبار أمان تطبيقات الويب – محتويات الإصدار 5.0

### منصة Portswigger

### تصنيف Bugcrowd لتقييم الثغرات الأمنية

- أمن تطبيقات الذكاء الاصطناعي

### تصنيف وتعداد أنماط الهجوم الشائعة (CAPEC) - نسخة قائمة CAPEC 3.9

- **الفئة: البرمجيات - (513)**
    - **1 - استغلال المعرّفات الموثوقة – (21)**
        - **الوصف:**
            
            استغلال معرفات يثق بها النظام (مثل user_id، order_id، file_id) دون التحقق من ملكيتها للمستخدم الحالي. يُعرف غالبًا بـ Insecure Direct Object Reference (IDOR).
            
        - **العملي:**
            
            يحصل المهاجم على معرف خاص به (مثل user_id=1001)، ثم يعدله إلى معرف آخر (مثل 5678) في الطلب.
            
            الطلب (http request):
            
            ```bash
            GET /api/profile?user_id=1001 HTTP/1.1
            Host: app.example.com
            Cookie: session=abc123xyz
            Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
            ```
            
            الرد (http response):
            
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
            
            تعديل المهاجم (http request):
            
            ```bash
            GET /api/profile?user_id=5678 HTTP/1.1
            Host: app.example.com
            Cookie: session=abc123xyz
            Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
            ```
            
            الرد بعد تعديل المهاجم (http response):
            
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
            
        - **سيناريو واقعي:**
            
            في bug bounty reports (HackerOne وMedium، 2022–2025)، يغير الباحث user_id أو account_id في /profile أو /account/details، فيطلع بيانات PII (إيميل، جوال، رصيد). bounties تصل إلى 3,500$–10,000$+ (تصنيف Critical).
            
            الطلب (http request) - من حالة مشابهة (IDOR في profile):
            
            ```bash
            GET /user/details?id=12345 HTTP/1.1
            Host: redacted.com
            ```
            
            الرد (http response):
            
            ```bash
            HTTP/1.1 200 OK
            { "name": "Victim", "phone": "010xxxxxxxx" }
            ```
            
            تعديل المهاجم (http request):
            
            ```bash
            GET /user/details?id=67890 HTTP/1.1
            Host: redacted.com
            ```
            
            الرد بعد تعديل المهاجم (http response):
            
            ```bash
            HTTP/1.1 200 OK
            { "name": "Another Victim", "phone": "011yyyyyyyy" }
            ```
            
            **الخطورة:** حرجة (Critical/P1) – تسريب PII، تعديل/حذف، تأثير مالي.
            
        - **آليات الحماية:**
            - تحقق server-side: `if current_user.id != resource.owner_id → 403`.
            - استخدم UUID أو hashed references غير متسلسلة.
            - لا تعرض IDs حساسة في client-side.
            - استخدم frameworks مع built-in object authorization (مثل Spring Security @PreAuthorize).
            
            ---
            
        - تزييف بيانات اعتماد الجلسة عبر التزوير – (196)
            - **الوصف:**
                
                تزوير بيانات اعتماد جلسة جديدة صالحة (غالباً JWT) من الصفر، مثل استغلال `"alg": "none"` (بدون توقيع).
                
            - **العملي:**
                
                يعدل المهاجم header إلى "none"، يمسح signature، يعدل payload (role=admin).
                
                الطلب (http request):
                
                ```bash
                GET /admin HTTP/1.1
                Host: saas.example.com
                Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciJ9.Sig
                ```
                
                الرد (http response):
                
                ```bash
                HTTP/1.1 403 Forbidden
                {"error": "Access denied"}
                ```
                
                تعديل المهاجم (http request):
                
                ```bash
                GET /admin HTTP/1.1
                Host: saas.example.com
                Authorization: Bearer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJyb2xlIjoiYWRtaW4ifQ.
                ```
                
                الرد بعد تعديل المهاجم (http response):
                
                ```bash
                HTTP/1.1 200 OK
                Admin Panel - Full access
                ```
                
            - **سيناريو واقعي:**
                
                في PortSwigger/Intigriti (2015–2025)، تطبيقات تقبل "none" → تزوير admin token. bounties 1,000$–5,000$+.
                ****الطلب (http request) - من حالة مشابهة:
                
                ```bash
                GET /protected HTTP/1.1
                Authorization: Bearer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJyb2xlIjoiYWRtaW4ifQ.
                ```
                
                الرد (http response):
                
                ```bash
                HTTP/1.1 200 OK
                {"message": "Admin granted"}
                ```
                
                **الخطورة:** حرجة (Critical) – impersonation كامل.
                
            - **آليات الحماية:**
                - رفض "none" صراحة.
                - تحديد whitelist algs (HS256/RS256).
                - تحقق signature + claims (exp, iss, sub).
                - مكتبات محدثة (jsonwebtoken مع strict mode).
                
                ---
                
            - تزييف بيانات اعتماد الجلسة من خلال التلاعب – (226)
                - **الوصف:**
                    
                    تعديل credential موجود (غالباً cookie) مثل role أو level دون توقيع.
                    
                - **العملي:**
                    
                    يعدل cookie ROLE=00 إلى ROLE=11.
                    
                    الطلب (http request):
                    
                    ```bash
                    GET /admin HTTP/1.1
                    Host: crm.example.com
                    Cookie: session=abc; ROLE=00
                    ```
                    
                    الرد (http response):
                    
                    ```bash
                    HTTP/1.1 200 OK
                    User Dashboard
                    ```
                    
                    تعديل المهاجم في (http request):
                    
                    ```bash
                    GET /admin HTTP/1.1
                    Host: crm.example.com
                    Cookie: session=abc; ROLE=11
                    ```
                    
                    الرد بعد تعديل المهاجم (http response):
                    
                    ```bash
                    HTTP/1.1 200 OK
                    Admin Panel - Full privileges
                    ```
                    
                - **سيناريو واقعي:**
                    
                    في Cobalt/HackerOne، ROLE=00 → ROLE=11 بدون signed cookie. bounties 1,000$–5,000$+.
                    
                    الطلب (http request) - من حالة مشابهة:
                    
                    ```bash
                    GET /admin HTTP/1.1
                    Cookie: ROLE=user
                    ```
                    
                    الرد (http response):
                    
                    ```bash
                    HTTP/1.1 200 OK
                    Limited access
                    ```
                    
                    تعديل المهاجم في (http request):
                    
                    ```bash
                    GET /admin HTTP/1.1
                    Cookie: ROLE=admin
                    ```
                    
                    الرد بعد تعديل المهاجم (http response):
                    
                    ```bash
                    HTTP/1.1 200 OK
                    Full admin
                    ```
                    
                    **الخطورة:** عالية (High) – escalation مباشر.
                    
                - **آليات الحماية:**
                    - لا تضع صلاحيات المستخدم (role) في الكوكيز بدون توقيع.
                    - استخدم جلسة (cookies) موقَّعة أو مُشفَّرة (HMAC).
                    - استخدم الجلسات المخزنة على الخادم (server-side session).
                    - اضبط الكوكيز بـ HttpOnly + Secure + SameSite=Strict.
                    
                    ---
                    
            - تزييف بيانات اعتماد الجلسة من خلال التنبؤ – (59)
                - **الوصف:**
                    
                    تخمين session ID بسبب كونه قابل للتنبؤ (متتالي أو timestamp-based).
                    
                - **العملي:**
                    
                    إذا كان ID=1000456 يجرب 1000457.
                    
                    الطلب (http request):
                    
                    ```bash
                    GET /dashboard HTTP/1.1
                    Host: old.example.com
                    Cookie: PHPSESSID=session_1000456
                    ```
                    
                    الرد (http response):
                    
                    ```bash
                    HTTP/1.1 200 OK
                    Welcome User X
                    ```
                    
                    تعديل المهاجم في (http request):
                    
                    ```bash
                    GET /dashboard HTTP/1.1
                    Host: old.example.com
                    Cookie: PHPSESSID=session_1000457
                    ```
                    
                    الرد بعد تعديل المهاجم (http response):
                    
                    ```bash
                    HTTP/1.1 200 OK
                    Welcome User Y - Hijacked
                    ```
                    
                - **سيناريو واقعي:**
                    
                    في OWASP/HackerOne (Ubiquiti-like)، ID متتالي → hijacking. bounties 500$–2,000$+.
                    
                    الطلب (http request) - من حالة مشابهة:
                    
                    ```bash
                    GET /admin HTTP/1.1
                    Cookie: SIDSSL=0000456
                    ```
                    
                    الرد (http response):
                    
                    ```bash
                    HTTP/1.1 200 OK
                    Admin session active
                    ```
                    
                    **الخطورة:** متوسطة-عالية – hijacking سريع.
                    
                - **آليات الحماية:**
                    - استخدم معرف جلسة (session ID) عشوائي وقوي، مثل crypto.random ≥128-bit.
                    - إعادة توليد معرف الجلسة (session ID) بعد تسجيل الدخول أو تسجيل الخروج.
                    - تجنب استخدام أرقام متسلسلة أو طوابع زمنية أو عناوين IP لتوليد المعرفات.
                    - تطبيق حد للطلبات (rate limiting) لحماية الجلسات.
                    
                    ---
                    
        - تزوير طلب مستخدم البرمجيات كخدمة (SaaS) – (510)
            - **الوصف:**
                
                المهاجم يستغل جلسة مصادق عليها موجودة في خدمة SaaS (مثل Google Workspace أو Microsoft 365 أو Salesforce) من خلال تطبيق خبيث مثبت على جهاز المستخدم (إضافة متصفح ضارة أو برمجية خبيثة). يرسل طلبات ضارة باستخدام الجلسة النشطة (cookies أو tokens)، فتقبلها الخدمة وتنفذها كأنها من المستخدم الشرعي.
                
            - **العملي:**
                - يثبت المهاجم تطبيقًا خبيثًا على جهاز الضحية (مثل إضافة متصفح).
                - المستخدم يسجل دخول إلى SaaS ويترك الجلسة مفتوحة.
                - التطبيق الخبيث يرسل طلبات HTTP إلى API الخدمة (مثل حذف ملف، إرسال إيميل، استخراج بيانات).
                
                مثال HTTP عملي (حذف ملف من Google Drive): الطلب (HTTP Request) الصادر من التطبيق الخبيث في الخلفية لتنفيذ عملية حذف ملف.
                
                ```bash
                DELETE /drive/v3/files/1abcDEF123 HTTP/1.1
                Host: www.googleapis.com
                Authorization: Bearer ya29.a0AfH6SMB... (token من جلسة المستخدم)
                Cookie: SID=...; HSID=...; SSID=...
                ```
                
                الرد (http response):
                
                ```bash
                HTTP/1.1 204 No Content
                ```
                
                مثال آخر (إرسال بريد إلكتروني ضار عبر Gmail API) – طلب (HTTP Request) يُرسَل من التطبيق الخبيث في الخلفية.
                
                ```bash
                POST /gmail/v1/users/me/messages/send HTTP/1.1
                Host: gmail.googleapis.com
                Authorization: Bearer ya29.a0AfH6SMD...
                Content-Type: application/json
                
                {"raw": "base64_encoded_phishing_email"}
                ```
                
                الرد (http response):
                
                ```bash
                HTTP/1.1 200 OK
                {"id": "18d..."}
                ```
                
            - **سيناريو واقعي:**
                
                إضافات متصفح Chrome ضارة (مثل تلك المكتشفة في حملات AiFrame أو مشابهة عام 2025–2026) تُروج كأدوات AI مساعدة (تلخيص نصوص أو مساعد Gmail)، لكنها في الخلفية تستغل الجلسات المفتوحة لاستخراج بيانات من Gmail أو Google Drive أو OneDrive، أو إرسال رسائل احتيالية، أو حذف محتوى دون علم المستخدم. حملات مشابهة أثرت على مئات الآلاف من المستخدمين، وتم اكتشافها في Chrome Web Store قبل إزالتها.
                
            - **آليات الحماية:**
                - **للمستخدمين:** تجنب تثبيت إضافات أو تطبيقات من مصادر غير موثوقة، فعّل 2FA قوي (يفضل مفتاح أجهزة)، راقب الجلسات النشطة وقم بتسجيل الخروج الدوري.
                    
                    **للخدمات السحابية:** استخدم PKCE في OAuth، توكنات قصيرة العمر مع إمكانية إلغاء فوري، كشف سلوك شاذ (rate limiting، فحص الموقع الجغرافي، بصمة الجهاز)، ودعم HttpOnly + Secure + SameSite=Strict للكوكيز.
                    
                
                ---
                
    - **2 - استغلال الثقة في العميل – (22)**

---

## اختبار اختراق واجهات البرمجة (API)

---

## اختبار اختراق تطبيقات الموبايل

---

## اختبار اختراق الشبكات

---

## اختبار اختراق الدليل النشط (Active Directory)

---

## اختبار اختراق الحوسبة السحابية

---

## عمليات الفريق الأحمر والهجمات المتقدمة