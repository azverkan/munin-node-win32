; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Munin Node for Windows"
!define PRODUCT_VERSION "1.6-dev"
!define PRODUCT_PUBLISHER "Munin"
!define PRODUCT_WEB_SITE "http://github.com/azverkan/munin-node-win32/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\munin-node.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\bird.ico"
!define MUI_UNICON "..\bird.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
;!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED true
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\readme.htm"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "munin-node-win32.exe"
InstallDir "$PROGRAMFILES\Munin Node for Windows"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  EnumRegKey $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\{9A19435C-513C-433E-8E3C-C1718EF14759}" 0
  IfErrors +2
    ExecWait '"$SYSDIR\MsiExec.exe" /x{9A19435C-513C-433E-8E3C-C1718EF14759}'

  ExecWait '"$SYSDIR\net.exe" stop munin-node'

  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  CreateDirectory "$SMPROGRAMS\Munin Node for Windows"
  File "..\bin\Release\munin-node.exe"
  File "..\doc\readme.htm"
  File "..\bin\XEventMessage.dll"
  File "..\munin-node.ini"
SectionEnd

Section "Service"
  ExecWait '"$INSTDIR\munin-node.exe" -install'
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\munin-node.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\munin-node.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  ExecWait '"$INSTDIR\munin-node.exe" -uninstall'

  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\munin-node.ini"
  Delete "$INSTDIR\XEventMessage.dll"
  Delete "$INSTDIR\readme.htm"
  Delete "$INSTDIR\munin-node.exe"

  Delete "$DESKTOP\Munin Node for Windows.lnk"
  Delete "$SMPROGRAMS\Munin Node for Windows\Munin Node for Windows.lnk"

  RMDir "$SMPROGRAMS\Munin Node for Windows"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd