/*
 * Copyright (c) 2020-2023 Alex Spataru <https://github.com/alex-spataru>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

import SerialStudio

import "../../Widgets" as Widgets


ToolBar {
  id: root

  //
  // Signals for group view widget
  //
  signal groupAdded(var index)

  //
  // Calculate offset based on platform
  //
  property int titlebarHeight: Cpp_NativeWindow.titlebarHeight(projectEditor)
  Connections {
    target: projectEditor
    function onVisibilityChanged() {
      root.titlebarHeight = Cpp_NativeWindow.titlebarHeight(projectEditor)
    }
  }

  //
  // Set toolbar height
  //
  Layout.minimumHeight: titlebarHeight + 76
  Layout.maximumHeight: titlebarHeight + 76

  //
  // Titlebar text
  //
  Label {
    text: projectEditor.title
    visible: root.titlebarHeight > 0
    color: Cpp_ThemeManager.colors["titlebar_text"]
    font: Cpp_Misc_CommonFonts.customUiFont(13, true)

    anchors {
      topMargin: 6
      top: parent.top
      horizontalCenter: parent.horizontalCenter
    }
  }

  //
  // Toolbar background
  //
  background: Rectangle {
    gradient: Gradient {
      GradientStop {
        position: 0
        color: Cpp_ThemeManager.colors["toolbar_top"]
      }

      GradientStop {
        position: 1
        color: Cpp_ThemeManager.colors["toolbar_bottom"]
      }
    }

    Rectangle {
      height: 1
      color: Cpp_ThemeManager.colors["toolbar_border"]

      anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
      }
    }

    DragHandler {
      target: null
      onActiveChanged: {
        if (active)
          projectEditor.startSystemMove()
      }
    }
  }

  //
  // Toolbar controls
  //
  RowLayout {
    spacing: 8

    anchors {
      margins: 2
      left: parent.left
      right: parent.right
      verticalCenter: parent.verticalCenter
      verticalCenterOffset: root.titlebarHeight / 2
    }

    //
    // New project
    //
    Widgets.BigButton {
      text: qsTr("New Project")
      Layout.alignment: Qt.AlignVCenter
      onClicked: Cpp_Project_Model.newJsonFile()
      icon.source: "qrc:/rcc/icons/project-editor/toolbar/new.svg"
    }

    //
    // Separator
    //
    Rectangle {
      width: 1
      Layout.fillHeight: true
      Layout.maximumHeight: 64
      Layout.alignment: Qt.AlignVCenter
      color: Cpp_ThemeManager.colors["toolbar_separator"]
    }

    //
    // Open
    //
    Widgets.BigButton {
      text: qsTr("Load Project")
      Layout.alignment: Qt.AlignVCenter
      onClicked: Cpp_Project_Model.openJsonFile()
      icon.source: "qrc:/rcc/icons/project-editor/toolbar/open.svg"
    }

    //
    // Save
    //
    Widgets.BigButton {
      text: qsTr("Save Project")
      Layout.alignment: Qt.AlignVCenter
      enabled: Cpp_Project_Model.modified
      onClicked: Cpp_Project_Model.saveJsonFile()
      icon.source: "qrc:/rcc/icons/project-editor/toolbar/save.svg"
    }

    //
    // Separator
    //
    Rectangle {
      width: 1
      Layout.fillHeight: true
      Layout.maximumHeight: 64
      Layout.alignment: Qt.AlignVCenter
      color: Cpp_ThemeManager.colors["toolbar_separator"]
    }

    //
    // Add group
    //
    Widgets.BigButton {
      text: qsTr("Custom Group")
      Layout.alignment: Qt.AlignVCenter
      icon.source: "qrc:/rcc/icons/project-editor/toolbar/add-group.svg"
      onClicked: Cpp_Project_Model.addGroup(qsTr("Custom Group"), ProjectModel.CustomGroup)
    }

    //
    // Add multiplot
    //
    Widgets.BigButton {
      text: qsTr("Multiple Plots")
      Layout.alignment: Qt.AlignVCenter
      icon.source: "qrc:/rcc/icons/project-editor/toolbar/add-multiplot.svg"
      onClicked: Cpp_Project_Model.addGroup(qsTr("Multiple Plot"), ProjectModel.MultiPlot)
    }

    //
    // Add accelerometer
    //
    Widgets.BigButton {
      text: qsTr("Accelerometer")
      Layout.alignment: Qt.AlignVCenter
      icon.source: "qrc:/rcc/icons/project-editor/toolbar/add-accelerometer.svg"
      onClicked: Cpp_Project_Model.addGroup(qsTr("Accelerometer"), ProjectModel.Accelerometer)
    }

    //
    // Add gyroscope
    //
    Widgets.BigButton {
      text: qsTr("Gyroscope")
      Layout.alignment: Qt.AlignVCenter
      icon.source: "qrc:/rcc/icons/project-editor/toolbar/add-gyroscope.svg"
      onClicked: Cpp_Project_Model.addGroup(qsTr("Gyroscope"), ProjectModel.Gyroscope)
    }

    //
    // Add map
    //
    Widgets.BigButton {
      text: qsTr("Map")
      Layout.alignment: Qt.AlignVCenter
      icon.source: "qrc:/rcc/icons/project-editor/toolbar/add-gps.svg"
      onClicked: Cpp_Project_Model.addGroup(qsTr("GPS Map"), ProjectModel.GPS)
    }

    //
    // Horizontal spacer
    //
    Item {
      Layout.fillWidth: true
    }
  }
}
