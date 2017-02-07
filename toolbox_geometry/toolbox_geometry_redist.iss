;##############################################################################################################
; Inno Setup Install script for Toolbox_geometry
; http://www.jrsoftware.org/isinfo.php
; This file is released under the 3-clause BSD license. See COPYING-BSD.
;##############################################################################################################
; modify this path where is toolbox_geometry directory
#define BinariesSourcePath "C:\Programs files\scilab-5.0\contrib\toolbox_geometry"
;
#define Toolbox_geometry_version "0.1"
#define CurrentYear "2008"
#define Toolbox_geometryDirFilename "toolbox_geometry"
;##############################################################################################################
[Setup]
; Debut Données de base à renseigner suivant version
SourceDir={#BinariesSourcePath}
AppName=Toolbox geometry
AppVerName=Toolbox geometry version 0.1
DefaultDirName={pf}\{#Toolbox_geometryDirFilename}
InfoAfterfile=readme.txt
LicenseFile=license.txt
WindowVisible=true
AppPublisher=Your Company
BackColorDirection=lefttoright
AppCopyright=Copyright © {#CurrentYear}
Compression=lzma/max
InternalCompressLevel=normal
SolidCompression=true
VersionInfoVersion={#Toolbox_geometry_version}
VersionInfoCompany=Your Company
;##############################################################################################################
[Files]
; Add here files that you want to add
Source: loader.sce; DestDir: {app}
Source: etc\toolbox_geometry.quit; DestDir: {app}\etc
Source: etc\toolbox_geometry.start; DestDir: {app}\etc
Source: macros\buildmacros.sce; DestDir: {app}\macros
Source: macros\lib; DestDir: {app}\macros
;Source: macros\names; DestDir: {app}\macros
Source: macros\*.sci; DestDir: {app}\macros
Source: macros\*.bin; DestDir: {app}\macros
Source: sci_gateway\loader_gateway.sce; DestDir: {app}\sci_gateway
Source: sci_gateway\c\loader.sce; DestDir: {app}\sci_gateway\c
Source: sci_gateway\c\geometry_c.dll; DestDir: {app}\sci_gateway\c
Source: sci_gateway\cpp\loader.sce; DestDir: {app}\sci_gateway\cpp
Source: sci_gateway\cpp\geometry_cpp.dll; DestDir: {app}\sci_gateway\cpp
Source: sci_gateway\fortran\loader.sce; DestDir: {app}\sci_gateway\fortran
Source: sci_gateway\fortran\geometry_fortran.dll; DestDir: {app}\sci_gateway\fortran
Source: src\c\libcsum.dll; DestDir: {app}\src\c
Source: src\c\loader.sce; DestDir: {app}\src\c
Source: src\fortran\libfsum.dll; DestDir: {app}\src\fortran
Source: src\fortran\loader.sce; DestDir: {app}\src\fortran
Source: tests\*.*; DestDir: {app}\tests; Flags: recursesubdirs
;Source: includes\*.h; DestDir: {app}\includes; Flags: recursesubdirs
;Source: locales\*.*; DestDir: {app}\locales; Flags: recursesubdirs
Source: demos\*.*; DestDir: {app}\locales; Flags: recursesubdirs
;
;##############################################################################################################
