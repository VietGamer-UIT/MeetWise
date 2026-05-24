# ============================================================
# migrate_to_enterprise.ps1
# MeetWise V2 — Script tái cấu trúc Enterprise SaaS Monorepo
#
# Tác giả: Đoàn Hoàng Việt (Việt Gamer)
# Mục tiêu:
#   • Tổ chức lại thư mục theo chuẩn Monorepo Enterprise
#   • Cô lập AI Core (LangGraph + Z3) vào phân khu riêng
#   • Dọn sạch tàn dư V1 (cache, boilerplate)
#   • Cập nhật import paths Python sau khi di chuyển
#
# Chạy từ thư mục gốc: d:\meetwise-backend
# Cách dùng: .\migrate_to_enterprise.ps1
# ============================================================

$ErrorActionPreference = "Stop"
$ROOT = $PSScriptRoot

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  MeetWise V2 — Enterprise Monorepo Migration" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ─────────────────────────────────────────────────────────────
# BƯỚC 1: Tạo cấu trúc thư mục Enterprise mới
# ─────────────────────────────────────────────────────────────

Write-Host "[1/6] Tạo cấu trúc thư mục Enterprise..." -ForegroundColor Yellow

$dirs = @(
    # === Backend API (Python Root) ===
    "apps\api\ai_engine\agent",           # LangGraph pipeline (cô lập)
    "apps\api\ai_engine\solver",          # Z3 SMT engine (cô lập)
    "apps\api\api\v1",                    # REST API endpoints
    "apps\api\core",                      # Hạ tầng (config, logging, metrics, trace)
    "apps\api\schemas",                   # Pydantic API contracts (LOCKED)
    "apps\api\models",                    # Database models (Supabase)
    "apps\api\services",                  # Business logic layer
    "apps\api\integrations",              # External service clients
    "apps\api\middleware",                # FastAPI middleware (JWT auth)
    "apps\api\storage",                   # Data access layer
    "apps\api\tests",                     # Test suite

    # === Frontend (Next.js — Phase 3) ===
    "apps\web",                           # Sẵn sàng cho Phase 3

    # === Infrastructure & DevOps ===
    "infrastructure\docker",              # Docker compose configurations
    "infrastructure\nginx",              # Nginx reverse proxy config
    "infrastructure\github\workflows",   # GitHub Actions CI/CD pipelines

    # === Database ===
    "database\migrations",               # Supabase SQL migrations (có thứ tự)
    "database\seeds",                    # Dữ liệu mẫu cho môi trường dev/staging

    # === Documentation ===
    "docs\api",                          # Tài liệu API (Swagger, Postman)
    "docs\architecture",                 # Kiến trúc hệ thống, ADR
    "docs\deployment",                   # Hướng dẫn triển khai lên Vercel/Render
    "docs\development"                   # Hướng dẫn phát triển local
)

foreach ($dir in $dirs) {
    $fullPath = Join-Path $ROOT $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "  ✓ Tạo: $dir" -ForegroundColor Green
    } else {
        Write-Host "  → Đã tồn tại: $dir" -ForegroundColor Gray
    }
}

# ─────────────────────────────────────────────────────────────
# BƯỚC 2: Di chuyển AI Core (agent/ + solver/) → ai_engine/
# ─────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "[2/6] Di chuyển AI Core vào phân khu cô lập..." -ForegroundColor Yellow

# Hàm copy toàn bộ thư mục (đệ quy), bỏ qua __pycache__
function Copy-PythonModule {
    param([string]$Source, [string]$Dest)
    if (Test-Path $Source) {
        Get-ChildItem -Path $Source -Recurse | Where-Object {
            $_.FullName -notlike "*__pycache__*" -and
            $_.FullName -notlike "*.pyc"
        } | ForEach-Object {
            $relativePath = $_.FullName.Substring($Source.Length).TrimStart('\')
            $destPath = Join-Path $Dest $relativePath
            if ($_.PSIsContainer) {
                New-Item -ItemType Directory -Path $destPath -Force | Out-Null
            } else {
                Copy-Item -Path $_.FullName -Destination $destPath -Force
            }
        }
        Write-Host "  ✓ Copy: $Source → $Dest" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Không tìm thấy: $Source" -ForegroundColor Red
    }
}

# Di chuyển các module Python vào apps\api\
$moduleMoves = @{
    "agent"        = "apps\api\ai_engine\agent"
    "solver"       = "apps\api\ai_engine\solver"
    "api"          = "apps\api\api"
    "core"         = "apps\api\core"
    "schemas"      = "apps\api\schemas"
    "services"     = "apps\api\services"
    "integrations" = "apps\api\integrations"
    "middleware"   = "apps\api\middleware"
    "models"       = "apps\api\models"
    "storage"      = "apps\api\storage"
    "tests"        = "apps\api\tests"
}

foreach ($entry in $moduleMoves.GetEnumerator()) {
    $src = Join-Path $ROOT $entry.Key
    $dst = Join-Path $ROOT $entry.Value
    Copy-PythonModule -Source $src -Dest $dst
}

# Copy các file đơn lẻ vào apps\api\
$singleFiles = @("main.py", "requirements.txt", "Dockerfile", "pytest.ini")
foreach ($file in $singleFiles) {
    $src = Join-Path $ROOT $file
    $dst = Join-Path $ROOT "apps\api\$file"
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dst -Force
        Write-Host "  ✓ Copy: $file → apps\api\$file" -ForegroundColor Green
    }
}

# Copy .env.example vào apps\api\
Copy-Item -Path (Join-Path $ROOT ".env.example") -Destination (Join-Path $ROOT "apps\api\.env.example") -Force -ErrorAction SilentlyContinue

# ─────────────────────────────────────────────────────────────
# BƯỚC 3: Cập nhật Import Paths Python
# ─────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "[3/6] Cập nhật import paths trong Python files..." -ForegroundColor Yellow

# Các thay thế import cần thiết sau khi di chuyển
# agent/ → ai_engine.agent  |  solver/ → ai_engine.solver
$importReplacements = @(
    # Import từ agent.* → ai_engine.agent.*
    @{ Pattern = "from agent\.graph "; Replace = "from ai_engine.agent.graph " },
    @{ Pattern = "from agent\.nodes "; Replace = "from ai_engine.agent.nodes " },
    @{ Pattern = "from agent\.state "; Replace = "from ai_engine.agent.state " },
    @{ Pattern = "from agent\.tools "; Replace = "from ai_engine.agent.tools " },
    @{ Pattern = "import agent\.";     Replace = "import ai_engine.agent." },

    # Import từ solver.* → ai_engine.solver.*
    @{ Pattern = "from solver\.parser ";          Replace = "from ai_engine.solver.parser " },
    @{ Pattern = "from solver\.z3_engine ";       Replace = "from ai_engine.solver.z3_engine " },
    @{ Pattern = "from solver\.fallback_parser "; Replace = "from ai_engine.solver.fallback_parser " },
    @{ Pattern = "import solver\.";               Replace = "import ai_engine.solver." },

    # Import nội bộ trong ai_engine/agent/ (state.py, nodes.py gọi solver)
    @{ Pattern = "from solver\."; Replace = "from ai_engine.solver." },
    @{ Pattern = "from agent\.";  Replace = "from ai_engine.agent." }
)

# Lấy tất cả .py files trong apps\api\ (trừ __pycache__)
$pyFiles = Get-ChildItem -Path (Join-Path $ROOT "apps\api") -Filter "*.py" -Recurse |
    Where-Object { $_.FullName -notlike "*__pycache__*" }

$updatedCount = 0
foreach ($file in $pyFiles) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    $changed = $false

    foreach ($replacement in $importReplacements) {
        if ($content -match [regex]::Escape($replacement.Pattern) -or $content -match $replacement.Pattern) {
            $content = $content -replace $replacement.Pattern, $replacement.Replace
            $changed = $true
        }
    }

    if ($changed) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $relPath = $file.FullName.Substring((Join-Path $ROOT "apps\api\").Length)
        Write-Host "  ✓ Cập nhật imports: $relPath" -ForegroundColor Green
        $updatedCount++
    }
}

Write-Host "  → Đã cập nhật $updatedCount files" -ForegroundColor Cyan

# ─────────────────────────────────────────────────────────────
# BƯỚC 4: Tạo __init__.py cho ai_engine
# ─────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "[4/6] Khởi tạo Python packages cho ai_engine..." -ForegroundColor Yellow

$initContent = '"""ai_engine — Neuro-Symbolic AI Core (LangGraph + Z3). KHÔNG SỬA."""'
$initPaths = @(
    "apps\api\ai_engine\__init__.py",
    "apps\api\middleware\__init__.py",
    "apps\api\models\__init__.py"
)
foreach ($initFile in $initPaths) {
    $fullPath = Join-Path $ROOT $initFile
    if (-not (Test-Path $fullPath)) {
        Set-Content -Path $fullPath -Value $initContent -Encoding UTF8
        Write-Host "  ✓ Tạo: $initFile" -ForegroundColor Green
    }
}

# ─────────────────────────────────────────────────────────────
# BƯỚC 5: Di chuyển Infrastructure files
# ─────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "[5/6] Di chuyển infrastructure files..." -ForegroundColor Yellow

# docker-compose.yml → infrastructure/docker/
$dcSrc = Join-Path $ROOT "docker-compose.yml"
$dcDst = Join-Path $ROOT "infrastructure\docker\docker-compose.yml"
if (Test-Path $dcSrc) {
    Copy-Item -Path $dcSrc -Destination $dcDst -Force
    Write-Host "  ✓ docker-compose.yml → infrastructure\docker\" -ForegroundColor Green
}

# Docs nội bộ → docs/
$docsSrc = Join-Path $ROOT "docs"
if (Test-Path $docsSrc) {
    Get-ChildItem -Path $docsSrc -Filter "*.md" | ForEach-Object {
        $dst = Join-Path $ROOT "docs\development\$($_.Name)"
        Copy-Item -Path $_.FullName -Destination $dst -Force
        Write-Host "  ✓ docs\$($_.Name) → docs\development\" -ForegroundColor Green
    }
}

# ─────────────────────────────────────────────────────────────
# BƯỚC 6: Dọn dẹp V1 — Xóa tàn dư cũ
# ─────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "[6/6] Dọn sạch tàn dư V1..." -ForegroundColor Yellow

# Danh sách thư mục/file cũ cần xóa (sau khi đã copy thành công)
$oldItems = @(
    "agent",          # Đã chuyển vào apps\api\ai_engine\agent\
    "solver",         # Đã chuyển vào apps\api\ai_engine\solver\
    "api",            # Đã chuyển vào apps\api\api\
    "core",           # Đã chuyển vào apps\api\core\
    "schemas",        # Đã chuyển vào apps\api\schemas\
    "services",       # Đã chuyển vào apps\api\services\
    "integrations",   # Đã chuyển vào apps\api\integrations\
    "middleware",     # Đã chuyển vào apps\api\middleware\
    "models",         # Đã chuyển vào apps\api\models\
    "storage",        # Đã chuyển vào apps\api\storage\
    "tests",          # Đã chuyển vào apps\api\tests\
    "main.py",        # Đã chuyển vào apps\api\main.py
    "requirements.txt",
    "Dockerfile",
    "pytest.ini",
    "docker-compose.yml",  # Đã chuyển vào infrastructure\docker\

    # === Tàn dư V1 thực sự (cache, compiled) ===
    "__pycache__",
    ".pytest_cache",
    ".venv"           # Môi trường ảo — không cần commit
)

foreach ($item in $oldItems) {
    $fullPath = Join-Path $ROOT $item
    if (Test-Path $fullPath) {
        Remove-Item -Path $fullPath -Recurse -Force
        Write-Host "  🗑 Đã xóa: $item" -ForegroundColor Magenta
    }
}

# ─────────────────────────────────────────────────────────────
# HOÀN THÀNH
# ─────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ✅ Migration hoàn thành!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Cấu trúc mới:" -ForegroundColor White
Write-Host "  apps\api\        ← FastAPI backend (chạy uvicorn từ đây)" -ForegroundColor Gray
Write-Host "  apps\web\        ← Next.js frontend (Phase 3)" -ForegroundColor Gray
Write-Host "  infrastructure\  ← Docker, Nginx, GitHub Actions" -ForegroundColor Gray
Write-Host "  database\        ← SQL migrations, seeds" -ForegroundColor Gray
Write-Host "  docs\            ← Tài liệu dự án" -ForegroundColor Gray
Write-Host ""
Write-Host "Bước tiếp theo:" -ForegroundColor Yellow
Write-Host "  1. cd apps\api" -ForegroundColor White
Write-Host "  2. python -m venv .venv" -ForegroundColor White
Write-Host "  3. .venv\Scripts\activate" -ForegroundColor White
Write-Host "  4. pip install -r requirements.txt" -ForegroundColor White
Write-Host "  5. python -m pytest tests/ -v" -ForegroundColor White
Write-Host ""
