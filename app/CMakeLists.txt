#
# Copyright (c) 2024 Alex Spataru <https://github.com/alex-spataru>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#-------------------------------------------------------------------------------
# Project setup
#-------------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.19)
project(app LANGUAGES CXX)

#-------------------------------------------------------------------------------
# C++ options
#-------------------------------------------------------------------------------

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#-------------------------------------------------------------------------------
# Add external dependencies (Qt)
#-------------------------------------------------------------------------------

find_package(
 Qt6 REQUIRED
 COMPONENTS
 Svg
 Gui
 Qml
 Core
 Quick
 Widgets
 Location
 SerialPort
 Bluetooth
 Positioning
 PrintSupport
 QuickControls2
)

qt_standard_project_setup()
qt_policy(SET QTP0001 NEW)

#-------------------------------------------------------------------------------
# Import source code & resources
#-------------------------------------------------------------------------------

include_directories(src)

set(SOURCES
 src/Misc/ThemeManager.cpp
 src/Misc/CommonFonts.cpp
 src/Misc/Utilities.cpp
 src/Misc/Translator.cpp
 src/Misc/ModuleManager.cpp
 src/Misc/TimerEvents.cpp
 src/UI/DashboardWidget.cpp
 src/UI/DeclarativeWidget.cpp
 src/UI/Dashboard.cpp
 src/UI/Widgets/LEDPanel.cpp
 src/UI/Widgets/Gauge.cpp
 src/UI/Widgets/Plot.cpp
 src/UI/Widgets/Compass.cpp
 src/UI/Widgets/Bar.cpp
 src/UI/Widgets/FFTPlot.cpp
 src/UI/Widgets/Accelerometer.cpp
 src/UI/Widgets/Common/AttitudeIndicator.cpp
 src/UI/Widgets/Common/ElidedLabel.cpp
 src/UI/Widgets/Common/KLed.cpp
 src/UI/Widgets/Common/AnalogGauge.cpp
 src/UI/Widgets/Common/BaseWidget.cpp
 src/UI/Widgets/DataGroup.cpp
 src/UI/Widgets/Terminal.cpp
 src/UI/Widgets/Gyroscope.cpp
 src/UI/Widgets/GPS.cpp
 src/UI/Widgets/MultiPlot.cpp
 src/Plugins/Server.cpp
 src/IO/Drivers/Network.cpp
 src/IO/Drivers/Serial.cpp
 src/IO/Drivers/BluetoothLE.cpp
 src/IO/Checksum.cpp
 src/IO/Console.cpp
 src/IO/Manager.cpp
 src/Project/FrameParser.cpp
 src/Project/Model.cpp
 src/JSON/Generator.cpp
 src/JSON/Frame.cpp
 src/JSON/Dataset.cpp
 src/JSON/Group.cpp
 src/CSV/Player.cpp
 src/CSV/Export.cpp
 src/MQTT/Client.cpp
 src/main.cpp
)

set(HEADERS
 src/Misc/ModuleManager.h
 src/Misc/Utilities.h
 src/Misc/CommonFonts.h
 src/Misc/ThemeManager.h
 src/Misc/TimerEvents.h
 src/Misc/Translator.h
 src/UI/Dashboard.h
 src/UI/DashboardWidget.h
 src/UI/DeclarativeWidget.h
 src/UI/Widgets/GPS.h
 src/UI/Widgets/MultiPlot.h
 src/UI/Widgets/Gauge.h
 src/UI/Widgets/Plot.h
 src/UI/Widgets/DataGroup.h
 src/UI/Widgets/FFTPlot.h
 src/UI/Widgets/Gyroscope.h
 src/UI/Widgets/Bar.h
 src/UI/Widgets/Accelerometer.h
 src/UI/Widgets/LEDPanel.h
 src/UI/Widgets/Common/KLed.h
 src/UI/Widgets/Common/AnalogGauge.h
 src/UI/Widgets/Common/AttitudeIndicator.h
 src/UI/Widgets/Common/BaseWidget.h
 src/UI/Widgets/Common/ElidedLabel.h
 src/UI/Widgets/Compass.h
 src/UI/Widgets/Terminal.h
 src/Plugins/Server.h
 src/Platform/NativeWindow.h
 src/IO/Console.h
 src/IO/Drivers/Serial.h
 src/IO/Drivers/Network.h
 src/IO/Drivers/BluetoothLE.h
 src/IO/Manager.h
 src/IO/HAL_Driver.h
 src/IO/Checksum.h
 src/Project/FrameParser.h
 src/Project/Model.h
 src/JSON/Frame.h
 src/JSON/Dataset.h
 src/JSON/Group.h
 src/JSON/Generator.h
 src/CSV/Export.h
 src/CSV/Player.h
 src/MQTT/Client.h
 src/AppInfo.h
)

set(QML_CODE
 qml/MainWindow/Dashboard/WidgetDelegate.qml
 qml/MainWindow/Dashboard/WidgetModel.qml
 qml/MainWindow/Dashboard/ViewOptionsDelegate.qml
 qml/MainWindow/Dashboard/ViewOptions.qml
 qml/MainWindow/Dashboard/WidgetGrid.qml
 qml/MainWindow/Panes/Toolbar.qml
 qml/MainWindow/Panes/Dashboard.qml
 qml/MainWindow/Panes/SetupPanes/Settings.qml
 qml/MainWindow/Panes/SetupPanes/Hardware.qml
 qml/MainWindow/Panes/SetupPanes/Devices/Serial.qml
 qml/MainWindow/Panes/SetupPanes/Devices/BluetoothLE.qml
 qml/MainWindow/Panes/SetupPanes/Devices/Network.qml
 qml/MainWindow/Panes/Console.qml
 qml/MainWindow/Panes/Setup.qml
 qml/MainWindow/Root.qml
 qml/ProjectEditor/Sections/ProjectStructure.qml
 qml/ProjectEditor/Sections/Toolbar.qml
 qml/ProjectEditor/Views/FrameParserView.qml
 qml/ProjectEditor/Views/GroupView.qml
 qml/ProjectEditor/Views/ProjectView.qml
 qml/ProjectEditor/Views/DatasetView.qml
 qml/ProjectEditor/Views/TableDelegate.qml
 qml/ProjectEditor/Root.qml
 qml/Dialogs/Acknowledgements.qml
 qml/Dialogs/About.qml
 qml/Dialogs/CsvPlayer.qml
 qml/Dialogs/Donate.qml
 qml/Dialogs/ExternalConsole.qml
 qml/Dialogs/MQTTConfiguration.qml
 qml/Widgets/Terminal.qml
 qml/Widgets/BigButton.qml
 qml/Widgets/Pane.qml
 qml/Widgets/GpsMap.qml
 qml/Widgets/JSONDropArea.qml
 qml/Widgets/DarkImage.qml
 qml/DialogLoader.qml
 qml/main.qml
)

#-------------------------------------------------------------------------------
# Platform-specific configuration
#-------------------------------------------------------------------------------

if(WIN32)
 set(WIN_RC "${CMAKE_CURRENT_SOURCE_DIR}/deploy/windows/info.rc")
 set(SOURCES ${SOURCES} ${WIN_RC} "src/Platform/NativeWindow_Windows.cpp")
elseif(APPLE)
 set(ICON_MACOSX "${CMAKE_CURRENT_SOURCE_DIR}/deploy/macOS/icon.icns")
 set(INFO_MACOSX "${CMAKE_CURRENT_SOURCE_DIR}/deploy/macOS/info.plist")
 set_source_files_properties(
  ${ICON_MACOSX}
  PROPERTIES MACOSX_PACKAGE_LOCATION "Resources"
 )
set(SOURCES ${SOURCES} ${ICON_MACOSX} "src/Platform/NativeWindow_macOS.mm")
set_source_files_properties(
 "src/Platform/NativeWindow_macOS.mm" PROPERTIES SKIP_UNITY_BUILD_INCLUSION ON
)
elseif(UNIX)
 set(SOURCES ${SOURCES} "src/Platform/NativeWindow_UNIX.cpp")
endif()

#-------------------------------------------------------------------------------
# Generate resources
#-------------------------------------------------------------------------------

qt_add_resources(RES_RCC ${CMAKE_CURRENT_SOURCE_DIR}/rcc/rcc.qrc)

#-------------------------------------------------------------------------------
# Create executable
#-------------------------------------------------------------------------------

qt_add_executable(
 ${PROJECT_EXECUTABLE}
 ${SOURCES}
 ${HEADERS}
 ${QML_RCC}
 ${RES_RCC}
 MANUAL_FINALIZATION
)

qt_add_qml_module(
 ${PROJECT_EXECUTABLE}
 URI app
 VERSION 1.0
 QML_FILES ${QML_CODE}
 RESOURCE_PREFIX "/"
)

target_link_libraries(
 ${PROJECT_EXECUTABLE} PUBLIC

 Qt6::Core
 Qt6::Svg
 Qt6::Gui
 Qt6::Qml
 Qt6::Quick
 Qt6::Widgets
 Qt6::Location
 Qt6::Bluetooth
 Qt6::SerialPort
 Qt6::Positioning
 Qt6::PrintSupport
 Qt6::QuickControls2

 qwt
 qmqtt
 qtcsv
 QRealFourier
 QSimpleUpdater
 QSourceHighlite
)

target_link_openssl(
 ${PROJECT_EXECUTABLE}
 ${CMAKE_CURRENT_SOURCE_DIR}/../lib/OpenSSL
)

#-------------------------------------------------------------------------------
# Deployment options
#-------------------------------------------------------------------------------

if(WIN32)
 target_link_libraries(${PROJECT_EXECUTABLE} PRIVATE Dwmapi.lib)
 set_target_properties(
  ${PROJECT_EXECUTABLE} PROPERTIES
  WIN32_EXECUTABLE TRUE
 )
elseif(APPLE)
 set_target_properties(
  ${PROJECT_EXECUTABLE} PROPERTIES
  MACOSX_BUNDLE TRUE
  MACOSX_BUNDLE_ICON_FILE ${ICON_MACOSX}
  MACOSX_BUNDLE_INFO_PLIST ${INFO_MACOSX}
 )
elseif(UNIX)
 install(TARGETS ${PROJECT_EXECUTABLE} RUNTIME DESTINATION /usr/bin)

 install(
  FILES ${CMAKE_CURRENT_SOURCE_DIR}/deploy/linux/serial-studio.png
  DESTINATION /usr/share/pixmaps
 )

install(
 FILES ${CMAKE_CURRENT_SOURCE_DIR}/deploy/linux/serial-studio.desktop
 DESTINATION /usr/share/applications
)
endif()

#-------------------------------------------------------------------------------
# Configure unity build
#-------------------------------------------------------------------------------

set_target_properties(
 ${PROJECT_EXECUTABLE} PROPERTIES
 UNITY_BUILD OFF
 UNITY_BUILD_MODE BATCH
 UNITY_BUILD_BATCH_SIZE 128
 INTERPROCEDURAL_OPTIMIZATION TRUE
)

#-------------------------------------------------------------------------------
# Qt Deployment
#-------------------------------------------------------------------------------

qt_finalize_executable(${PROJECT_EXECUTABLE})

install(
 TARGETS ${PROJECT_EXECUTABLE}
 BUNDLE  DESTINATION .
 RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_generate_deploy_qml_app_script(
 TARGET ${PROJECT_EXECUTABLE}
 OUTPUT_SCRIPT deploy_script
 MACOS_BUNDLE_POST_BUILD
 NO_UNSUPPORTED_PLATFORM_ERROR
 DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)

install(SCRIPT ${deploy_script})

#-------------------------------------------------------------------------------
# Packaging
#-------------------------------------------------------------------------------

set(CPACK_PACKAGE_NAME                  ${PROJECT_DISPNAME})
set(CPACK_PACKAGE_CONTACT               ${PROJECT_CONTACT})
set(CPACK_PACKAGE_VENDOR                ${PROJECT_VENDOR})
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY   ${PROJECT_DESCRIPTION_SUMMARY})
set(CPACK_PACKAGE_VERSION_MAJOR         ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR         ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH         ${PROJECT_VERSION_PATCH})
set(CPACK_PACKAGE_DESCRIPTION_FILE      ${PROJECT_DESCRIPTION_FILE})
set(CPACK_PACKAGE_FILE_NAME             ${PROJECT_FILE_NAME})
set(CPACK_RESOURCE_FILE_LICENSE         ${PROJECT_FILE_LICENSE})

set(CPACK_MONOLITHIC_INSTALL OFF)

if(WIN32)
 set(CPACK_PACKAGE_ICON              "${CMAKE_CURRENT_SOURCE_DIR}\\\\deploy\\\\windows\\\\icon.ico")
 set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_NAME}")
else()
 set(CPACK_PACKAGE_ICON              "${CMAKE_CURRENT_SOURCE_DIR}/deploy/icon.png")
 set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_NAME}")
endif()

if(NOT CPACK_GENERATOR)
 if(WIN32)
  set(CPACK_GENERATOR                             "NSIS")
  set(CPACK_NSIS_MANIFEST_DPI_AWARE               ON)
  set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL  ON)
  set(CPACK_NSIS_DISPLAY_NAME                     "${CPACK_PACKAGE_NAME}")
  set(CPACK_NSIS_MUI_FINISHPAGE_RUN               "${PROJECT_EXECUTABLE}")
  set(CPACK_NSIS_INSTALLED_ICON_NAME              "$INSTDIR\\\\bin\\\\${PROJECT_EXECUTABLE}.exe")
  set(CPACK_NSIS_MUI_ICON                         "${CMAKE_CURRENT_SOURCE_DIR}\\\\deploy\\\\windows\\\\icon.ico")
  set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS         "Delete '$SMPROGRAMS\\\\${PROJECT_DISPNAME}.lnk'")
  set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS           "CreateShortCut '$SMPROGRAMS\\\\${PROJECT_DISPNAME}.lnk' '$INSTDIR\\\\bin\\\\${PROJECT_EXECUTABLE}.exe'")
 elseif(APPLE)
  set(CPACK_GENERATOR                             "DragNDrop")
 else()
  set(CPACK_GENERATOR                             "TGZ")
 endif()
endif()

include(CPack)
