$msg = Read-Host "Please input the commit message"
if ([string]::IsNullOrWhiteSpace($msg)) {
    Write-Output "please input the commit message"
    exit
}
# Prompt the user for input
$userInput = Read-Host "Do you want to continue? Please enter 'y' to confirm"

# Check if the user input is 'y' or 'Y'
if ($userInput -eq 'y' -or $userInput -eq 'Y') {
    Write-Host "User confirmed to continue."
    # Place the code you want to execute here
}
else {
    Write-Host "User canceled the execution."
    exit
}
git add .
git commit -m $msg
git push origin main
hexo generate
hexo deploy
Write-Output "deployed blogs successfully!"