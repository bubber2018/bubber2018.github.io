param(
    [string]$Message = '更新站点'
)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)

# 1. 本地先构建一次，有问题立刻暴露，不会把坏内容推上去
Write-Host '[1/3] 本地构建校验' -ForegroundColor Cyan
npx hexo clean
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
npx hexo generate
if ($LASTEXITCODE -ne 0) {
    Write-Host '构建失败，已中止发布。' -ForegroundColor Red
    exit $LASTEXITCODE
}

# 2. 提交源码
Write-Host '[2/3] 提交到 main' -ForegroundColor Cyan
git add -A
$changes = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changes)) {
    Write-Host '没有文件变化，跳过提交。' -ForegroundColor Yellow
}
else {
    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

# 3. 推送，触发 GitHub Actions 构建并发布到 master
Write-Host '[3/3] 推送到 GitHub' -ForegroundColor Cyan
git push origin HEAD:main
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ''
Write-Host '已推送。GitHub Actions 会自动构建（约 1 分钟）：' -ForegroundColor Green
Write-Host '  https://github.com/bubber2018/bubber2018.github.io/actions' -ForegroundColor DarkGray
Write-Host '线上地址：https://bubber2018.github.io/' -ForegroundColor Green
Write-Host 'Pages 有约 10 分钟缓存，急的话用无痕窗口看。' -ForegroundColor DarkGray
