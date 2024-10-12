param (
    [string]$filePath,
    [string]$url
)

$debug = "false" # CREATES A LOG FILE IN THE LOCATION BELOW
$logFile = "C:\Apps\Redmans-Context-Menu\log-file.txt"

if ($url -eq "QB_LINK") {
    $url = "" #URL FOR POST
}

if ($debug = "true") {
    if ($url -eq "FAILDB_LINK") {
        $url = "https://example.somebodysdatabase.com/upload.php" # this will fail
    }
}

if ($debug -eq "true") {
    if (-Not (Test-Path $logFile)) {
        New-Item -Path $logFile -ItemType File
    }
    "Script started at $(Get-Date)" | Out-File $logFile -Append
    "Received file path: $filePath" | Out-File $logFile -Append
    "Recieved URL: $url" | Out-File $logFile -Append
}

Add-Type -AssemblyName System.Windows.Forms

function Show-CustomInputBox {
    param (
        [string]$message,
        [string]$title,
        [string]$iconPath,
        [array]$options = @()
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $title
    $form.Width = 470
    $form.Height = 200
    $form.StartPosition = "CenterScreen"

    if (Test-Path $iconPath) {
        $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
    }

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $message
    $label.AutoSize = $true
    $label.Font = New-Object System.Drawing.Font("Arial", 14)
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $form.Controls.Add($label)

    if ($options.Count -gt 0) {
        $comboBox = New-Object System.Windows.Forms.ComboBox
        $comboBox.Width = 430
        $comboBox.Location = New-Object System.Drawing.Point(10, 60)
        $comboBox.DropDownStyle = 'DropDownList'
        $comboBox.Items.AddRange($options)
        $form.Controls.Add($comboBox)

        $buttonOK = New-Object System.Windows.Forms.Button
        $buttonOK.Text = "OK"
        $buttonOK.Location = New-Object System.Drawing.Point(200, 100)
        $buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Controls.Add($buttonOK)

        $buttonCancel = New-Object System.Windows.Forms.Button
        $buttonCancel.Text = "Cancel"
        $buttonCancel.Location = New-Object System.Drawing.Point(280, 100)
        $buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $buttonCancel.Add_Click({
            $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
            $form.Close()
        })
        $form.Controls.Add($buttonCancel)

        $form.AcceptButton = $buttonOK
        $form.CancelButton = $buttonCancel

        try {
            $result = $form.ShowDialog()
            if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                return $comboBox.SelectedItem
            } else {
                return $null
            }
        } catch {
            return $null
        }
    } else {
        $textBox = New-Object System.Windows.Forms.TextBox
        $textBox.Width = 430
        $textBox.Location = New-Object System.Drawing.Point(10, 60)
        $form.Controls.Add($textBox)

        $buttonOK = New-Object System.Windows.Forms.Button
        $buttonOK.Text = "OK"
        $buttonOK.Location = New-Object System.Drawing.Point(200, 100)
        $buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Controls.Add($buttonOK)

        $buttonCancel = New-Object System.Windows.Forms.Button
        $buttonCancel.Text = "Cancel"
        $buttonCancel.Location = New-Object System.Drawing.Point(280, 100)
        $buttonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $buttonCancel.Add_Click({
            $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
            $form.Close()
        })
        $form.Controls.Add($buttonCancel)

        $form.AcceptButton = $buttonOK
        $form.CancelButton = $buttonCancel

        try {
            $result = $form.ShowDialog()
            if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                return $textBox.Text
            } else {
                return $null
            }
        } catch {
            return $null
        }
    }
}


$optionsCsvPath = "C:\Apps\Redmans-Context-Menu\FileTypes.csv" # Location to get the dropdown options
$options = @()
if (Test-Path $optionsCsvPath) {
    $options = Import-Csv -Path $optionsCsvPath | Select-Object -ExpandProperty FileType
} else {
    $options = @("Files Types Loaded Unsuccessfully")
}

$iconPath = "C:\Apps\Redmans-Context-Menu\Redmans.ico"
$fileType = Show-CustomInputBox -message "Please select the file type" -title "File Type Entry" -iconPath $iconPath -options $options
if (-not $fileType) { 
    exit
}

$jobId = Show-CustomInputBox -message "Please enter the job ID" -title "Job ID Entry" -iconPath $iconPath
if (-not $jobId) { 
    exit
}

$userComment = Show-CustomInputBox -message "Please enter any comments" -title "Comment Entry" -iconPath $iconPath
if (-not $userComment) { 
    $userComment = ""
}

$username = [Environment]::UserName

if ($debug -eq "true") {
    "File type: $fileType" | Out-File $logFile -Append
    "Job ID: $jobId" | Out-File $logFile -Append
    "Comment: $userComment" | Out-File $logFile -Append
    "Username: $username" | Out-File $logFile -Append
}

if (-Not (Test-Path $filePath)) {
    "Error: The file path does not exist: $filePath" | Out-File $logFile -Append
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show("Error: The file path does not exist: $filePath", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

$fileExtension = [System.IO.Path]::GetExtension($filePath).ToLower()

$contentType = switch ($fileExtension) {
    ".txt" { "text/plain" }
    ".json" { "application/json" }
    ".xml" { "application/xml" }
    ".csv" { "text/csv" }
    ".jpg" { "image/jpeg" }
    ".jpeg" { "image/jpeg" }
    ".png" { "image/png" }
    ".gif" { "image/gif" }
    ".bmp" { "image/bmp" }
    ".tiff" { "image/tiff" }
    ".pdf" { "application/pdf" }
    ".doc" { "application/msword" }
    ".docx" { "application/vnd.openxmlformats-officedocument.wordprocessingml.document" }
    ".xls" { "application/vnd.ms-excel" }
    ".xlsx" { "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
    ".xlsm" { "application/vnd.ms-excel.sheet.macroEnabled.12" }
    ".html" { "text/html" }
    ".htm" { "text/html" }
    ".hthml" { "text/html" }
    ".msg" { "application/vnd.ms-outlook" }
    ".zip" { "application/zip" }
    ".dat" { "application/octet-stream" }
    ".myo" { "application/octet-stream" }
    ".myox" { "application/octet-stream" }
    ".mmap" { "application/octet-stream" }
    ".jng" { "image/x-jng" }
    ".webp" { "image/webp" }
    ".raw" { "image/x-raw" }
    ".cur" { "image/x-win-bitmap" }
    ".psb" { "application/octet-stream" }
    ".xcf" { "image/x-xcf" }
    default { "application/octet-stream" } # Fallback for unsupported types
}

$fileContent = [System.IO.File]::ReadAllBytes($filePath)
$encodedContent = [Convert]::ToBase64String($fileContent)

$body = @{
    "username" = $username
    "jobID" = $jobId
    "userComment" = $userComment
    "fileType" = $fileType
    "fileName" = [System.IO.Path]::GetFileName($filePath)
    "fileContent" = $encodedContent
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body ($body | ConvertTo-Json -Depth 10) -ContentType $contentType

    $successForm = New-Object System.Windows.Forms.Form
    $successForm.Text = "Upload Successful"
    $successForm.Width = 300
    $successForm.Height = 175
    $successForm.StartPosition = "CenterScreen"
    $successForm.TopMost = $true
    $iconPath = "C:\Apps\Redmans-Context-Menu\Redmans.ico"
    $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
    $successForm.Icon = $icon

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Click the link below for the uploaded file:"
    $label.AutoSize = $true
    $label.Font = New-Object System.Drawing.Font($label.Font.FontFamily, 10)
    $label.Location = New-Object System.Drawing.Point(20, 20)
    $label.TextAlign = "MiddleCenter"
    $successForm.Controls.Add($label)

    $linkLabel = New-Object System.Windows.Forms.LinkLabel
    $linkLabel.Text = $response
    $linkLabel.AutoSize = $true
    $linkLabel.Font = New-Object System.Drawing.Font($linkLabel.Font.FontFamily, 8)
    $linkLabel.Location = New-Object System.Drawing.Point(5, 40)
    $linkLabel.TextAlign = "MiddleCenter"

    $linkLabel.Add_LinkClicked({
        param($sender, $e)
        Start-Process $response
    })

    $successForm.Controls.Add($linkLabel)

    $contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
    $copyMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $copyMenuItem.Text = "Copy Link"
    $copyMenuItem.Add_Click({
        [System.Windows.Forms.Clipboard]::SetText($response)
    })
    $contextMenu.Items.Add($copyMenuItem)

    $linkLabel.Add_MouseDown({
        param($sender, $e)
        if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Right) {
            $contextMenu.Show($linkLabel, $e.Location)
            return
        }
    })

    $buttonOK = New-Object System.Windows.Forms.Button
    $buttonOK.Text = "OK"
    $buttonOK.Location = New-Object System.Drawing.Point(107, 80)
    $buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $successForm.Controls.Add($buttonOK)

    $successForm.MaximizeBox = $false
    $successForm.MinimizeBox = $false
    $successForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $successForm.AcceptButton = $buttonOK
    $successForm.ShowDialog()

    "Response (Success): $response" | Out-File $logFile -Append
} catch {
    $errorMessage = $_.Exception.Message
    "Response (Fail): $errorMessage" | Out-File $logFile -Append
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show("Response (Fail): $errorMessage", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}

if ($debug -eq "true") {
    "Script finished at $(Get-Date)" | Out-File $logFile -Append
    "" | Out-File $logFile -Append
}
