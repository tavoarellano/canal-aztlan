# === RADIO AZTLAN - Estudio casero ===
# Doble clic en estudio.bat para abrir este menu.
# Si creas un archivo clave.txt (junto a este script) con tu SOURCE_PASSWORD
# en la primera linea, ya no te la pedira cada vez. clave.txt NUNCA se sube
# a GitHub (esta en .gitignore).

$ffmpeg   = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\ffmpeg.exe"
$ffplay   = "$env:LOCALAPPDATA\Microsoft\WinGet\Links\ffplay.exe"
$carpeta  = Split-Path -Parent $MyInvocation.MyCommand.Path
$archivo  = Join-Path $carpeta "lectura.mp3"
$claveTxt = Join-Path $carpeta "clave.txt"
$microfono = "Microphone (Realtek(R) Audio)"
$servidor  = "altaria.proxy.rlwy.net:18665"
$pagina    = "https://canal-aztlan-production.up.railway.app"

function Get-Clave {
    if (Test-Path $claveTxt) { return (Get-Content $claveTxt -TotalCount 1).Trim() }
    return Read-Host "Escribe tu SOURCE_PASSWORD (de Railway > Variables)"
}

while ($true) {
    Write-Host ""
    Write-Host "=====================================" -ForegroundColor DarkGreen
    Write-Host "   RADIO AZTLAN - Estudio" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor DarkGreen
    Write-Host " [1] Grabar 1 minuto"
    Write-Host " [2] Grabar (tu eliges cuantos minutos)"
    Write-Host " [3] Escuchar la grabacion"
    Write-Host " [4] Salir al aire (una vez)"
    Write-Host " [5] Salir al aire en bucle (se repite hasta que pulses q)"
    Write-Host " [6] HABLAR EN VIVO al aire (microfono directo, q para cortar)"
    Write-Host " [7] Abrir la pagina de la radio"
    Write-Host " [0] Salir"
    $op = Read-Host "Elige una opcion"

    if ($op -eq "1") {
        Write-Host "Grabando 60 segundos... habla ya. (q para terminar antes)" -ForegroundColor Yellow
        & $ffmpeg -hide_banner -loglevel warning -stats -y -f dshow -i audio="$microfono" -t 60 -c:a libmp3lame -b:a 128k $archivo
        Write-Host "Listo: $archivo" -ForegroundColor Green
    }
    elseif ($op -eq "2") {
        $min = Read-Host "Cuantos minutos"
        $seg = [int]$min * 60
        Write-Host "Grabando $min minuto(s)... habla ya. (q para terminar antes)" -ForegroundColor Yellow
        & $ffmpeg -hide_banner -loglevel warning -stats -y -f dshow -i audio="$microfono" -t $seg -c:a libmp3lame -b:a 128k $archivo
        Write-Host "Listo: $archivo" -ForegroundColor Green
    }
    elseif ($op -eq "3") {
        if (Test-Path $archivo) { & $ffplay -hide_banner -loglevel warning -autoexit -nodisp $archivo }
        else { Write-Host "Todavia no hay grabacion. Usa la opcion 1 o 2." -ForegroundColor Red }
    }
    elseif ($op -eq "4" -or $op -eq "5") {
        if (-not (Test-Path $archivo)) { Write-Host "Todavia no hay grabacion. Usa la opcion 1 o 2." -ForegroundColor Red; continue }
        $clave = Get-Clave
        $bucle = @()
        if ($op -eq "5") { $bucle = @("-stream_loop", "-1") }
        Write-Host "Transmitiendo... abre $pagina para escucharte. (q para cortar)" -ForegroundColor Yellow
        & $ffmpeg -hide_banner -loglevel warning -stats -re @bucle -i $archivo -c:a libmp3lame -b:a 128k -content_type audio/mpeg -f mp3 "icecast://source:${clave}@$servidor/stream"
        Write-Host "Transmision terminada. La radio quedo en silencio." -ForegroundColor Green
    }
    elseif ($op -eq "6") {
        $clave = Get-Clave
        Write-Host "EN VIVO: todo lo que digas esta saliendo al aire. Pulsa q para cortar." -ForegroundColor Red
        & $ffmpeg -hide_banner -loglevel warning -stats -f dshow -i audio="$microfono" -c:a libmp3lame -b:a 128k -content_type audio/mpeg -f mp3 "icecast://source:${clave}@$servidor/stream"
        Write-Host "Fuera del aire." -ForegroundColor Green
    }
    elseif ($op -eq "7") {
        Start-Process $pagina
    }
    elseif ($op -eq "0") {
        exit
    }
}
