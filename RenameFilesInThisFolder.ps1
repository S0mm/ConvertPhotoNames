$Pattern1 = "^[PV]1\d{4}-\d{6}\.(jpg|mp4)$"   # P11209-111750.jpg, V10916-212436.mp4 (assume 2021)
$Pattern2 = "^(IMG|VID)_\d{8}_\d{6}\.(jpg|mp4)$"   # IMG_20210612_220927.jpg, VID_20210131_160115.mp4
$Pattern3 = "^(IMG|VID)\d{14}\.(jpg|mp4)$"    # IMG20230708152446.jpg, VID20211010203936.mp4
$Pattern4 = "^video_\d{8}_\d{6}\.mp4$"        # video_20230123_120914.mp4

$PatternNew = "^\d{4}-\d{2}-\d{2}-\d{6}\.(jpg|mp4)$"        # 2024-01-13-112849.jpg, 2024-01-13-112849.mp4

$unknownFiles = @()

# Function to handle Pattern1 renaming
function GetNamePattern1 {
    param ($fileName)
    return "2021-$($fileName.Substring(2, 2))-$($fileName.Substring(4, 2))$($fileName.Substring(6))"
}

# Function to handle Pattern2 renaming
function GetNamePattern2 {
    param ($fileName)
    return "$($fileName.Substring(4, 4))-$($fileName.Substring(8, 2))-$($fileName.Substring(10, 2))-$($fileName.Substring(13))"
}

# Function to handle Pattern3 renaming
function GetNamePattern3 {
    param ($fileName)
    return "$($fileName.Substring(3, 4))-$($fileName.Substring(7, 2))-$($fileName.Substring(9, 2))-$($fileName.Substring(11))"
}

# Function to handle Pattern4 renaming
function GetNamePattern4 {
    param ($fileName)
    return "$($fileName.Substring(6, 4))-$($fileName.Substring(10, 2))-$($fileName.Substring(12, 2))-$($fileName.Substring(15))"
}

# Get all files in the current directory
$files = Get-ChildItem -File

foreach ($file in $files) {
    $newName = $null

    if ($file.Name -match $Pattern1) {
        $newName = GetNamePattern1 $file.Name
    } elseif ($file.Name -match $Pattern2) {
        $newName = GetNamePattern2 $file.Name
    } elseif ($file.Name -match $Pattern3) {
        $newName = GetNamePattern3 $file.Name
    } elseif ($file.Name -match $Pattern4) {
        $newName = GetNamePattern4 $file.Name
    } elseif ($file.Name -notmatch $PatternNew) {
        # unknown formats
        $unknownFiles += $file.Name
    }

    if ($newName) {
        Rename-Item $file.FullName -NewName $newName
    }
}

Write-Host "DONE"
Write-Host "Unknown files: $($unknownFiles.Count)"
$unknownFiles | ForEach-Object { Write-Host $_ }

Read-Host "Press Enter to exit"
