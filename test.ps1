#Requires -Version 7
$ErrorActionPreference = "Stop"


# Ensure script execution is permitted for current user (no prompt)
try {
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop | Out-Null
} catch {
  Write-Host "⚠️ Could not set ExecutionPolicy (scope CurrentUser). Continuing..."
}


# ---------------- Config ----------------
$IMG  = "abxglia/speedrun-stylus:0.1"
$NAME = "speedrun-stylus"
$PORT = 3000
# ---------------------------------------


function Say($msg) { Write-Host "`n$msg" }


# 0) Checks
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Host "❌ Docker not found. Install Docker Desktop."; exit 1
}
try { docker info | Out-Null } catch { Write-Host "❌ Docker daemon not running. Start Docker Desktop."; exit 1 }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Host "❌ git not found. Install git."; exit 1
}


# 1) Locate required workspaces anywhere within the current project tree
function Find-RelativeInWorkspace {
  param(
    [Parameter(Mandatory=$true)][string]$relativePath
  )
  $root = Get-Location
  # 1) Try at root
  $candidate = Join-Path $root $relativePath
  if (Test-Path $candidate) { return $candidate }
  # 2) Try all subdirectories
  $dirs = Get-ChildItem -Path $root -Directory -Recurse -ErrorAction SilentlyContinue
  foreach ($d in $dirs) {`
    $p = Join-Path $d.FullName $relativePath
    if (Test-Path $p) { return $p }
  }
  return $null
}


$packagesNextjsPath = Find-RelativeInWorkspace -relativePath "packages/nextjs"
if (-not $packagesNextjsPath) {
  Write-Host "❌ packages/nextjs folder not found in the current project."
  Write-Host "Please follow the required steps mentioned at: https://github.com/purvik6062/session-guide/blob/main/docker/README.md"
  Write-Host "Make sure you have cloned a challenge repository first."
  exit 1
}


Say "✅ Found packages/nextjs at: $packagesNextjsPath"


# Compute container path to the discovered Next.js workspace
$relativeNextjs = Resolve-Path -Relative $packagesNextjsPath
$relativeNextjs = $relativeNextjs -replace '^[.\\/]+',''
$containerNextjs = "/app/" + ($relativeNextjs -replace '\\','/')


# 2) Choose challenge (ask user which repo they cloned)
Write-Host "Which challenge repository did you clone?
1) counter
2) nft
3) vending-machine
4) multi-sig
5) stylus-uniswap"
$sel = Read-Host "Enter 1-5"
switch ($sel) {
  "1" { $branch="counter";         $challenge="counter" }
  "2" { $branch="nft";             $challenge="nft" }
  "3" { $branch="vending-machine"; $challenge="vending_machine" }
  "4" { $branch="multi-sig";       $challenge="multi-sig" }
  "5" { $branch="stylus-uniswap";  $challenge="stylus-uniswap-v2" }
  default { Write-Host "Invalid choice."; exit 1 }
}


# 3) Set working directory to current location (where the cloned repo is)
$WORKDIR = Get-Location
Say "🏠 Working in current directory: $WORKDIR"


# 4) Ensure image present (skip pull if already local)
$null = docker image inspect $IMG 2>$null
if ($LASTEXITCODE -ne 0) {
  Say "🐳 Pulling Docker image (first time only)..."
  docker pull $IMG | Out-Null
} else {
  Say "✅ Docker image present; skipping pull."
}


# 5) Ensure container running (reuse if exists)
$inspect = docker inspect -f '{{.State.Status}}' $NAME 2>$null
if ($LASTEXITCODE -eq 0) {
  $status = $inspect.Trim()
  if ($status -eq 'running') {
    Say "♻️ Container '$NAME' already running; reusing."
  } else {
    Say "▶️ Starting existing container '$NAME'..."
    docker start $NAME | Out-Null
  }
} else {
  # 6) Start new container with caches
  Say "🚀 Starting container..."
  docker run -d --name $NAME `
    -v ${PWD}:/app `
    -v speedrun-yarn-cache:/root/.cache/yarn `
    -v speedrun-cargo-registry:/root/.cargo/registry `
    -v speedrun-cargo-git:/root/.cargo/git `
    -v speedrun-rustup:/root/.rustup `
    -v speedrun-foundry:/root/.foundry `
    -p "$PORT`:3000" `
    $IMG tail -f /dev/null | Out-Null
}


# 7) Ensure deploy script exists
docker exec -it $NAME bash -lc "command -v deploy-contract.sh >/dev/null || { echo 'deploy-contract.sh missing in image'; exit 1; }"


# 8) Install deps (skip if already installed) in the discovered Next.js workspace
Say "📥 Ensuring dependencies are installed..."
docker exec -it $NAME bash -lc "cd '$containerNextjs' && if [ -d node_modules ]; then echo '✔ deps already installed; skipping.'; else yarn install; fi"


# 9) Private key (skip prompt if both .env files already contain keys)
# Discover challenge workspace directory globally
if ($challenge -eq "counter") {
  $challengePath = Find-RelativeInWorkspace -relativePath "packages/stylus-demo"
} else {
  $challengePath = Find-RelativeInWorkspace -relativePath ("packages/cargo-stylus/" + $challenge)
}
if (-not $challengePath) {
  Write-Host "❌ Could not find challenge directory for '$challenge' anywhere in this project."
  Write-Host "Please follow the required steps: https://github.com/purvik6062/session-guide/blob/main/docker/README.md"
  exit 1
}
Say "✅ Found challenge at: $challengePath"


$relativeChallenge = Resolve-Path -Relative $challengePath
$relativeChallenge = $relativeChallenge -replace '^[.\\/]+',''
$containerChallenge = "/app/" + ($relativeChallenge -replace '\\','/')


$pkgEnv = "$containerChallenge/.env"
$nextEnv = "$containerNextjs/.env"


docker exec $NAME bash -lc "test -f '$nextEnv' && grep -q '^NEXT_PUBLIC_PRIVATE_KEY=0x' '$nextEnv'" | Out-Null
$nextOk = ($LASTEXITCODE -eq 0)
docker exec $NAME bash -lc "test -f '$pkgEnv' && grep -q '^PRIVATE_KEY=0x' '$pkgEnv'" | Out-Null
$pkgOk = ($LASTEXITCODE -eq 0)
$skipPkPrompt = ($nextOk -and $pkgOk)


if (-not $skipPkPrompt) {
  $secure = Read-Host -AsSecureString "Enter PRIVATE KEY (hex, no spaces). I will prepend 0x"
  $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  $raw = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
  [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
  $pk = "0x" + ($raw -replace '^0x','')
} else {
  $pk = $null
}


# 10) Write env files
Say "🧩 Writing .env files..."
if ($skipPkPrompt) {
  # Only ensure RPC URL in nextjs .env; do not modify existing keys
  $envCmdNoKey = "set -e; cd '$containerNextjs' || { echo 'nextjs package not found'; exit 1; }; if [ ! -f .env ]; then if [ -f .env.example ]; then cp -n .env.example .env; else touch .env; fi; fi; if grep -q '^NEXT_PUBLIC_RPC_URL=' .env; then sed -i 's^NEXT_PUBLIC_RPC_URL=.*^NEXT_PUBLIC_RPC_URL=https://sepolia-rollup.arbitrum.io/rpc^' .env; else echo 'NEXT_PUBLIC_RPC_URL=https://sepolia-rollup.arbitrum.io/rpc' >> .env; fi"
  docker exec -it $NAME bash -lc $envCmdNoKey
} else {
  # Write both RPC URL and keys
  $envCmd = "set -e; cd '$containerNextjs' || { echo 'nextjs package not found'; exit 1; }; if [ ! -f .env ]; then if [ -f .env.example ]; then cp -n .env.example .env; else touch .env; fi; fi; if grep -q '^NEXT_PUBLIC_RPC_URL=' .env; then sed -i 's^NEXT_PUBLIC_RPC_URL=.*^NEXT_PUBLIC_RPC_URL=https://sepolia-rollup.arbitrum.io/rpc^' .env; else echo 'NEXT_PUBLIC_RPC_URL=https://sepolia-rollup.arbitrum.io/rpc' >> .env; fi; if grep -q '^NEXT_PUBLIC_PRIVATE_KEY=' .env; then sed -i 's^NEXT_PUBLIC_PRIVATE_KEY=.*^NEXT_PUBLIC_PRIVATE_KEY=$pk^' .env; else echo 'NEXT_PUBLIC_PRIVATE_KEY=$pk' >> .env; fi"
  docker exec -it $NAME bash -lc $envCmd
  docker exec -it $NAME bash -lc "set -e; test -d '$containerChallenge' || { echo 'challenge directory not found in container: $containerChallenge'; exit 1; }; echo 'PRIVATE_KEY=$pk' > '$containerChallenge/.env'"
}


# Wait a moment to ensure .env files are fully written
Start-Sleep -Seconds 1


# 11) Always deploy contract fresh (force new deployment every time)
$baseDir = $containerChallenge
$deployLog = "$baseDir/deploy.log"


Say "🛠️ Deploying contract for '$challenge'..."
$deployOut = docker exec $NAME bash -lc "cd /app && deploy-contract.sh $challenge | tee '$deployLog'"
$addr = ($deployOut | Select-String -Pattern '0x[0-9a-fA-F]{40}' -AllMatches).Matches | Select-Object -Last 1 | ForEach-Object { $_.Value }


if ($addr) {
  Say "✅ Contract address: $addr"
  if ($challenge -eq "stylus-uniswap-v2") {
    $target = "$containerNextjs/app/debug/_components/UniswapInterface.tsx"
    $var = "uniswapContractAddress"
  } else {
    $target = "$containerNextjs/app/debug/_components/DebugContracts.tsx"
    $var = "contractAddress"
  }


  # Always inject the new contract address into frontend file
  $js = @"
const fs = require('fs');
const path = process.env.TARGET;
const varName = process.env.VARNAME;
const addr = process.env.ADDR;
if (!fs.existsSync(path)) {
  console.log('⚠️ ' + path + ' not found; please paste manually.');
  process.exit(0);
}
let src = fs.readFileSync(path, 'utf8');
const re = new RegExp(varName + '\\s*=\\s*(?:\"|\')0x[0-9a-fA-F]{40}(?:\"|\')');
if (re.test(src)) {
  src = src.replace(re, varName + '="' + addr + '"');
} else {
  const re2 = new RegExp('(\\\b' + varName + '\\s*=\\s*)(?:\"|\')0x[0-9a-fA-F]{40}(?:\"|\')');
  src = src.replace(re2, '$1"' + addr + '"');
}
fs.writeFileSync(path, src);
console.log('🔧 Injected ' + varName + ' into ' + path);
"@
  $b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($js))
  $inject = "printf '%s' '$b64' | base64 -d > /tmp/inject.js && node /tmp/inject.js && touch '$target'"
  docker exec -e TARGET="$target" -e VARNAME="$var" -e ADDR="$addr" -it $NAME bash -lc $inject
} else {
  Say "⚠️ Could not detect contract address automatically. Copy it from logs and paste manually in the debug UI file."
}


# 12) Start frontend (restart cleanly and run Next directly from discovered packages/nextjs)
Say "🌐 Starting frontend (it may take ~15–30s to be ready)..."
docker exec $NAME bash -lc "pkill -f 'next dev' 2>/dev/null || true; pkill -f 'start-frontend.sh' 2>/dev/null || true"
docker exec -d $NAME bash -lc "cd '$containerNextjs' && yarn dev > /tmp/next-dev.log 2>&1 & disown"
Start-Sleep -Seconds 2
docker exec $NAME bash -lc "command -v curl >/dev/null 2>&1 && curl -sf http://localhost:3000 >/dev/null 2>&1" | Out-Null
if ($LASTEXITCODE -ne 0) { Say "⌛ Waiting for dev server..." }


Say "🎉 All set! Open: http://localhost:$PORT"
Say "Shell inside container:  docker exec -it $NAME bash"
Say "Switch challenge later:  docker rm -f $NAME   # then run this script again"

