<div align="center">

# 🤝 MeetWise

**Công cụ AI giúp bạn biết: "Cuộc họp này có nên họp không?"**

*Tránh họp vô bổ — trước khi nó xảy ra*

[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![Next.js](https://img.shields.io/badge/Next.js-14-000000?style=flat-square&logo=next.js&logoColor=white)](https://nextjs.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat-square&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat-square&logo=supabase&logoColor=white)](https://supabase.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

**Xây dựng bởi [Đoàn Hoàng Việt (Việt Gamer)](https://github.com/VietGamer-UIT)**

</div>

---

## MeetWise là gì?

Bạn đã từng vào họp rồi phát hiện: tài liệu chưa xong, người ra quyết định không có mặt, thông tin chưa đủ?

**MeetWise giải quyết điều đó** — bằng cách kiểm tra tự động *trước khi* cuộc họp diễn ra.

Bạn chỉ cần viết điều kiện bằng tiếng Việt thông thường:

```
"Slide cập nhật hoặc Sheet chốt số, bắt buộc Manager phải rảnh"
```

AI sẽ kiểm tra và trả lời ngay:
- ✅ **Sẵn sàng họp** — Tất cả điều kiện đã đáp ứng
- 🔴 **Cần dời lịch** — Lý do cụ thể + đề xuất lịch mới tự động

---

## Tính năng chính

| Tính năng | Mô tả |
|-----------|-------|
| 🧠 **AI hiểu tiếng Việt** | Nhập điều kiện bằng tiếng Việt tự nhiên, không cần học cú pháp kỹ thuật |
| ✅ **Kết quả chắc chắn** | Dùng Z3 Theorem Prover — không đoán mò, luôn đúng |
| 📊 **Dashboard trực quan** | Xem thống kê tỉ lệ sẵn sàng, lịch sử đánh giá |
| 🔔 **Thông báo tự động** | Gửi email khi cần dời lịch họp |
| 👥 **Dùng cho cả công ty** | Mỗi người có tài khoản, quản lý cuộc họp riêng |
| 🔌 **Không cần cài thêm gì** | Chạy được ngay, không cần API key |

---

## Cách chạy

### Cách 1 — Chạy nhanh bằng Docker (khuyến nghị cho công ty)

> **Yêu cầu:** Chỉ cần cài [Docker Desktop](https://www.docker.com/products/docker-desktop/)

**Bước 1:** Tải mã nguồn về máy

```bash
git clone https://github.com/VietGamer-UIT/meetwise-backend.git
cd meetwise-backend
```

**Bước 2:** Copy file cấu hình

```bash
# Windows
copy .env.example .env

# Mac / Linux
cp .env.example .env
```

**Bước 3:** Điền thông tin Supabase vào file `.env`

> Mở file `.env` bằng Notepad/VSCode và điền:
> - `SUPABASE_URL` và `SUPABASE_ANON_KEY` — lấy từ [supabase.com](https://supabase.com) → Project Settings → API
> - Để trống các mục khác nếu chưa cần

**Bước 4:** Khởi động toàn bộ hệ thống

```bash
cd infrastructure/docker
docker-compose up --build
```

Sau vài phút, mở trình duyệt:
- 🌐 **Ứng dụng web:** http://localhost:3000
- 📖 **Tài liệu API:** http://localhost:8000/docs

---

### Cách 2 — Chạy thủ công (cho lập trình viên)

#### Backend (Python + FastAPI)

> **Yêu cầu:** Python 3.11+

```bash
# Di chuyển vào thư mục backend
cd apps/api

# Tạo môi trường ảo (làm 1 lần)
python -m venv .venv

# Kích hoạt môi trường ảo
.venv\Scripts\activate          # Windows
source .venv/bin/activate       # Mac / Linux

# Cài thư viện
pip install -r requirements.txt

# Tạo file cấu hình
copy .env.example .env          # Windows
cp .env.example .env            # Mac / Linux

# Khởi động server backend
uvicorn main:app --reload --port 8000
```

Backend chạy tại: http://localhost:8000

#### Frontend (Next.js)

> **Yêu cầu:** Node.js 18+ ([tải tại nodejs.org](https://nodejs.org))

```bash
# Mở terminal mới, di chuyển vào thư mục frontend
cd apps/web

# Cài thư viện (làm 1 lần)
npm install

# Tạo file cấu hình
copy .env.local.example .env.local   # Windows
cp .env.local.example .env.local     # Mac / Linux

# Điền SUPABASE_URL và SUPABASE_ANON_KEY vào .env.local

# Khởi động frontend
npm run dev
```

Frontend chạy tại: http://localhost:3000

---

### Kiểm tra hoạt động

Sau khi khởi động, truy cập http://localhost:3000 và:

1. **Đăng ký** tài khoản mới
2. **Tạo cuộc họp** — nhập tiêu đề, thời gian, điều kiện họp
3. Nhấn **"Đánh giá AI"** → xem kết quả ngay lập tức

---

## Cấu hình môi trường (file `.env`)

Mở file `.env` và điền theo hướng dẫn:

```env
# ── Bắt buộc (lấy từ Supabase Dashboard → Settings → API) ──
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJxxx...
SUPABASE_SERVICE_ROLE_KEY=eyJxxx...   # Service role key (bí mật)
SUPABASE_JWT_SECRET=xxxxx             # JWT Secret

# ── Tùy chọn (để trống nếu chưa cần) ──
GEMINI_API_KEY=                       # Google Gemini AI (để trống = dùng chế độ không AI)
RESEND_API_KEY=                       # Gửi email thông báo (để trống = tắt email)
```

> 💡 **Chạy không cần API key:** Để trống tất cả, hệ thống vẫn hoạt động đầy đủ với AI fallback tích hợp sẵn.

---

## Triển khai cho công ty (Production)

### Cách nhanh nhất: Vercel + Render

| Dịch vụ | Dùng để | Giá |
|---------|---------|-----|
| [Supabase](https://supabase.com) | Database + Đăng nhập | Miễn phí |
| [Vercel](https://vercel.com) | Chạy frontend (web) | Miễn phí |
| [Render](https://render.com) | Chạy backend (API) | Miễn phí |

**Các bước:**

1. Tạo project trên Supabase → lấy URL + keys
2. Deploy backend lên Render: chọn repo → root dir `apps/api` → Render tự build
3. Deploy frontend lên Vercel: chọn repo → root dir `apps/web` → điền env vars

### Chạy trên máy chủ công ty (VPS/Docker)

```bash
# Trên máy chủ, sau khi đã cài Docker
git clone https://github.com/VietGamer-UIT/meetwise-backend.git
cd meetwise-backend

# Điền thông tin thật vào .env
cp .env.example .env
nano .env  # hoặc dùng editor bất kỳ

# Chạy ở chế độ nền (background)
cd infrastructure/docker
docker-compose up -d --build
```

Tất cả nhân viên trong công ty truy cập qua IP máy chủ, ví dụ: `http://192.168.1.100:3000`

---

## Kiến trúc kỹ thuật (dành cho lập trình viên)

```
apps/
├── api/            # Backend: Python + FastAPI + LangGraph + Z3
│   ├── agent/      # AI Pipeline (LangGraph — KHÔNG SỬA)
│   ├── solver/     # Z3 Theorem Prover (KHÔNG SỬA)
│   ├── api/v1/     # REST API endpoints
│   ├── services/   # Business logic
│   └── tests/      # Test suite (pytest)
│
└── web/            # Frontend: Next.js 14 + TailwindCSS
    ├── app/        # Pages (App Router)
    ├── components/ # React components
    └── lib/        # API client, utilities
```

**Tech Stack:**
- **AI Engine:** LangGraph + Google Gemini + Z3 SMT Solver
- **Backend:** FastAPI (Python 3.11) + Supabase (PostgreSQL)
- **Frontend:** Next.js 14 + TailwindCSS + Framer Motion + Recharts
- **Auth:** Supabase Auth (JWT)
- **DevOps:** Docker + GitHub Actions CI/CD

---

## Chạy tests

```bash
# Backend tests
cd apps/api
python -m pytest tests/ -v

# Chỉ test AI engine
python -m pytest tests/test_api.py tests/test_solver.py -v

# Chỉ test Meeting CRUD
python -m pytest tests/test_meeting_crud.py -v
```

---

## Đóng góp

1. Fork repository
2. Tạo branch mới: `git checkout -b feature/ten-tinh-nang`
3. Commit: `git commit -m "feat: mô tả ngắn"`
4. Push và tạo Pull Request vào `develop`

---

## License

MIT License — Xem [LICENSE](LICENSE) để biết thêm.

---

<div align="center">

*⭐ Star nếu dự án hữu ích với bạn!*

</div>
