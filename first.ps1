param(
    [string]$msg
)
if ([string]::IsNullOrWhiteSpace($msg)) {
    Write-Output "please input the commit message"
    exit
}

git add .
git commit -m $msg
git push origin main
hexo deploy
Write-Output "deployed blogs successfully!"