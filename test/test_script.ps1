# Set adb path
$adbPath = "C:\Users\Salah\AppData\Local\Android\Sdk\platform-tools\adb.exe"

# Check if a video recording already exists on the emulator
Write-Host "Checking for existing recording on the emulator..."
$existingRecording = & $adbPath shell ls /sdcard/recording.mp4
if ($existingRecording -like "No such file") {
    Write-Host "No existing recording found."
} else {
    Write-Host "Existing recording found. Deleting it..."
    & $adbPath shell rm /sdcard/recording.mp4
    Write-Host "Old recording deleted."
}

# Start screen recording in the background
Write-Host "Starting screen recording..."
Start-Process -FilePath $adbPath -ArgumentList "shell screenrecord /sdcard/recording.mp4" -NoNewWindow

# Run the Flutter integration test
Write-Host "Running Flutter integration test..."
flutter drive --driver=test/integration_test.dart --target=test/test.dart
# Wait for 180 seconds to let the recording finish
Write-Host "Waiting for the recording to finish..."
Start-Sleep -Seconds 180

# Pull the recording to the local directory
Write-Host "Pulling the recording to the local directory..."
& $adbPath pull /sdcard/recording.mp4 D:\

Write-Host "Script execution completed."