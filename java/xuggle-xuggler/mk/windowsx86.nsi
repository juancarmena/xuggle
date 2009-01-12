# Auto-generated by EclipseNSIS Script Wizard
# Dec 26, 2008 3:15:56 PM

Name Xuggle-Xuggler

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 1.15.66
!define COMPANY Xuggle
!define URL www.xuggle.com

# MultiUser Symbol Definitions
!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_MUI
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_DEFAULT_REGISTRY_VALUENAME MultiUserInstallMode
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR Xuggle
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_KEY "${REGKEY}"
!define MULTIUSER_INSTALLMODE_INSTDIR_REGISTRY_VALUE "Path"

# MUI Symbol Definitions
!define MUI_ICON xuggle.ico
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_CUSTOMFUNCTION_GUIINIT CustomGUIInit
!define MUI_UNICON xuggle.ico
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include MultiUser.nsh
!include Sections.nsh
!include MUI2.nsh
!include EnvVarUpdate.nsh

# Reserved Files
ReserveFile "${NSISDIR}\Plugins\BGImage.dll"
ReserveFile "${NSISDIR}\Plugins\AdvSplash.dll"

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ..\COPYING
!insertmacro MULTIUSER_PAGE_INSTALLMODE
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile ../dist/setup.exe
InstallDir Xuggle
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion 0.0.0.0
VIAddVersionKey ProductName Xuggle-Xuggler
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright "Copyright (c) 2009, Xuggle Inc."
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File /r ..\dist\stage\${XUGGLE_HOME}\*
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
    ${EnvVarUpdate} $0 "XUGGLE_HOME" "R" "HKLM" $INSTDIR
    ${EnvVarUpdate} $0 "XUGGLE_HOME" "A" "HKLM" $INSTDIR
    ${EnvVarUpdate} $0 "PATH" "R" "HKLM" "%XUGGLE_HOME%\bin"
    ${EnvVarUpdate} $0 "PATH" "P" "HKLM" "%XUGGLE_HOME%\bin"
SectionEnd

Section -post SEC0001
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o -un.Main UNSEC0000
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "%XUGGLE_HOME%\bin"
    RmDir /r /REBOOTOK $INSTDIR
    DeleteRegValue HKLM "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $INSTDIR
SectionEnd

# Installer functions
Function CustomGUIInit
    Push $R1
    Push $R2
    BgImage::SetReturn /NOUNLOAD on
    BgImage::SetBg /NOUNLOAD /GRADIENT 0 0 128 0 0 0
    Pop $R1
    Strcmp $R1 success 0 error
    File /oname=$PLUGINSDIR\bgimage.bmp xuggle-logo-background.bmp
    System::call "user32::GetSystemMetrics(i 0)i.R1"
    System::call "user32::GetSystemMetrics(i 1)i.R2"
    IntOp $R1 $R1 - 800
    IntOp $R1 $R1 / 2
    IntOp $R2 $R2 - 480
    IntOp $R2 $R2 / 2
    BGImage::AddImage /NOUNLOAD $PLUGINSDIR\bgimage.bmp $R1 $R2
    CreateFont $R1 "Times New Roman" 26 700 /ITALIC
    BGImage::AddText /NOUNLOAD "$(^SetupCaption)" $R1 255 255 255 16 8 500 100
    Pop $R1
    Strcmp $R1 success 0 error
    BGImage::Redraw /NOUNLOAD
    Goto done
error:
    MessageBox MB_OK|MB_ICONSTOP $R1
done:
    Pop $R2
    Pop $R1
FunctionEnd

Function .onGUIEnd
    BGImage::Destroy
FunctionEnd

Function .onInit
    InitPluginsDir
    Push $R1
    File /oname=$PLUGINSDIR\spltmp.bmp xuggle-logo-splash.bmp
    advsplash::show 1000 600 400 -1 $PLUGINSDIR\spltmp
    Pop $R1
    Pop $R1
    !insertmacro MULTIUSER_INIT
FunctionEnd

# Uninstaller functions
Function un.onInit
    !insertmacro MULTIUSER_UNINIT
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd

