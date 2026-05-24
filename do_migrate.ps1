$ROOT = "d:\meetwise-backend"
Set-Location $ROOT

Write-Host "=== Buoc 1: Tao cau truc thu muc Enterprise ===" -ForegroundColor Cyan

$dirs = "apps\api\ai_engine\agent","apps\api\ai_engine\solver","apps\api\api\v1","apps\api\core","apps\api\schemas","apps\api\models","apps\api\services","apps\api\integrations","apps\api\middleware","apps\api\storage","apps\api\tests","apps\web","infrastructure\docker","infrastructure\nginx","infrastructure\github\workflows","database\migrations","database\seeds","docs\api","docs\architecture","docs\deployment","docs\development"

foreach ($d in $dirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $ROOT $d) | Out-Null
    Write-Host "  + $d" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Buoc 2: Copy Python modules ===" -ForegroundColor Cyan

function CopyModule($src, $dst) {
    $srcFull = Join-Path $ROOT $src
    $dstFull = Join-Path $ROOT $dst
    if (Test-Path $srcFull) {
        $items = Get-ChildItem -Path $srcFull -Recurse | Where-Object { $_.FullName -notlike "*__pycache__*" -and $_.FullName -notlike "*.pyc" }
        foreach ($item in $items) {
            $rel = $item.FullName.Substring($srcFull.Length).TrimStart('\')
            $target = Join-Path $dstFull $rel
            if ($item.PSIsContainer) {
                New-Item -ItemType Directory -Force -Path $target | Out-Null
            } else {
                $parentDir = Split-Path $target -Parent
                if (-not (Test-Path $parentDir)) { New-Item -ItemType Directory -Force -Path $parentDir | Out-Null }
                Copy-Item -Path $item.FullName -Destination $target -Force
            }
        }
        Write-Host "  Copied: $src -> $dst" -ForegroundColor Green
    } else {
        Write-Host "  SKIP (not found): $src" -ForegroundColor Yellow
    }
}

CopyModule "agent"        "apps\api\ai_engine\agent"
CopyModule "solver"       "apps\api\ai_engine\solver"
CopyModule "api"          "apps\api\api"
CopyModule "core"         "apps\api\core"
CopyModule "schemas"      "apps\api\schemas"
CopyModule "services"     "apps\api\services"
CopyModule "integrations" "apps\api\integrations"
CopyModule "storage"      "apps\api\storage"
CopyModule "tests"        "apps\api\tests"

# Copy single files
foreach ($f in "main.py","requirements.txt","Dockerfile","pytest.ini") {
    $s = Join-Path $ROOT $f
    $d = Join-Path $ROOT "apps\api\$f"
    if (Test-Path $s) {
        Copy-Item $s $d -Force
        Write-Host "  Copied: $f -> apps\api\$f" -ForegroundColor Green
    }
}

Copy-Item (Join-Path $ROOT ".env.example") (Join-Path $ROOT "apps\api\.env.example") -Force -ErrorAction SilentlyContinue

# Infrastructure
if (Test-Path (Join-Path $ROOT "docker-compose.yml")) {
    Copy-Item (Join-Path $ROOT "docker-compose.yml") (Join-Path $ROOT "infrastructure\docker\docker-compose.yml") -Force
    Write-Host "  Copied: docker-compose.yml -> infrastructure\docker\" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Buoc 3: Tao __init__.py cho ai_engine ===" -ForegroundColor Cyan

$initContent = '"""ai_engine — Neuro-Symbolic AI Core (LangGraph + Z3). KHONG SUA."""'
Set-Content -Path (Join-Path $ROOT "apps\api\ai_engine\__init__.py") -Value $initContent -Encoding UTF8
Set-Content -Path (Join-Path $ROOT "apps\api\middleware\__init__.py") -Value '"""middleware — FastAPI middleware layer."""' -Encoding UTF8
Set-Content -Path (Join-Path $ROOT "apps\api\models\__init__.py") -Value '"""models — Pydantic database models."""' -Encoding UTF8
Write-Host "  Created __init__.py files" -ForegroundColor Green

Write-Host ""
Write-Host "=== Buoc 4: Cap nhat import paths Python ===" -ForegroundColor Cyan

$pyFiles = Get-ChildItem -Path (Join-Path $ROOT "apps\api") -Filter "*.py" -Recurse | Where-Object { $_.FullName -notlike "*__pycache__*" }

$count = 0
foreach ($f in $pyFiles) {
    $txt = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $orig = $txt

    # agent.* -> ai_engine.agent.*
    $txt = $txt -replace 'from agent\.graph ', 'from ai_engine.agent.graph '
    $txt = $txt -replace 'from agent\.nodes ', 'from ai_engine.agent.nodes '
    $txt = $txt -replace 'from agent\.state ', 'from ai_engine.agent.state '
    $txt = $txt -replace 'from agent\.tools ', 'from ai_engine.agent.tools '
    $txt = $txt -replace 'import agent\.', 'import ai_engine.agent.'

    # solver.* -> ai_engine.solver.*
    $txt = $txt -replace 'from solver\.parser ', 'from ai_engine.solver.parser '
    $txt = $txt -replace 'from solver\.z3_engine ', 'from ai_engine.solver.z3_engine '
    $txt = $txt -replace 'from solver\.fallback_parser ', 'from ai_engine.solver.fallback_parser '
    $txt = $txt -replace 'import solver\.', 'import ai_engine.solver.'

    if ($txt -ne $orig) {
        [System.IO.File]::WriteAllText($f.FullName, $txt, [System.Text.Encoding]::UTF8)
        $rel = $f.FullName.Replace((Join-Path $ROOT "apps\api\"), "")
        Write-Host "  Updated imports: $rel" -ForegroundColor Green
        $count++
    }
}
Write-Host "  Tong so files cap nhat: $count" -ForegroundColor Cyan

Write-Host ""
Write-Host "=== Buoc 5: Don dep tai du V1 ===" -ForegroundColor Cyan

$removeList = "agent","solver","api","core","schemas","services","integrations","storage","tests","main.py","requirements.txt","Dockerfile","pytest.ini","docker-compose.yml","__pycache__",".pytest_cache"
foreach ($item in $removeList) {
    $p = Join-Path $ROOT $item
    if (Test-Path $p) {
        Remove-Item -Path $p -Recurse -Force
        Write-Host "  Removed: $item" -ForegroundColor Magenta
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  HOAN THANH! Enterprise Monorepo structure da san sang." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Buoc tiep theo:"
Write-Host "  cd apps\api"
Write-Host "  python -m venv .venv"
Write-Host "  .venv\Scripts\activate"
Write-Host "  pip install -r requirements.txt"
Write-Host "  python -m pytest tests/ -v"
