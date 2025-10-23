@echo off
setlocal enabledelayedexpansion

rem Prefijo se refiere al los primeros caracteres de los equipos a buscar en AD
set "prefix=PREFIX"
set "activeCount=0"
set "origen=\\SERVER\SOURCE\FOLDER"

echo Buscando "%prefix%" en AD...

for /f "tokens=*" %%i in ('dsquery computer -name %prefix%*') do (
    set "dn=%%i"
    rem Extraer el nombre del equipo desde el DN
    for /f "tokens=2 delims==," %%a in ("!dn!") do (
        set "computer=%%a"
        echo ping !computer!...
        ping -n 1 !computer! | find "TTL=" >nul
        if !errorlevel! == 0 (
            set /a activeCount+=1

            rem Definir ruta destino
            set "destino=\\!computer!\C$\Users\Public\Desktop\PUBLIC_FOLDER_NAME"

            rem Crear carpeta destino si no existe
            echo Verificando carpeta destino en !computer!...
            if not exist "!destino!" (
                echo La carpeta no existe. Creando...
                mkdir "!destino!"
            )

            rem Copiar archivos
            echo Copiando accesos a !computer!...
            xcopy "%origen%\*" "!destino!\" /E /Y /I
        )
    )
)

echo.
echo Total de equipos activos procesados: %activeCount%

endlocal

pause
