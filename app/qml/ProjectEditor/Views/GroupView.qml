/*
 * Copyright (c) 2020-2024 Alex Spataru <https://github.com/alex-spataru>
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
import QtQuick.Layouts
import QtQuick.Controls

import SerialStudio
import "../../Widgets" as Widgets

Widgets.Pane {
  implicitWidth: 0
  implicitHeight: 0
  icon: Cpp_Project_Model.selectedIcon
  title: Cpp_Project_Model.selectedText

  //
  // User interface elements
  //
  Page {
    palette.mid: Cpp_ThemeManager.colors["mid"]
    palette.dark: Cpp_ThemeManager.colors["dark"]
    palette.text: Cpp_ThemeManager.colors["text"]
    palette.base: Cpp_ThemeManager.colors["base"]
    palette.link: Cpp_ThemeManager.colors["link"]
    palette.light: Cpp_ThemeManager.colors["light"]
    palette.window: Cpp_ThemeManager.colors["window"]
    palette.shadow: Cpp_ThemeManager.colors["shadow"]
    palette.accent: Cpp_ThemeManager.colors["accent"]
    palette.button: Cpp_ThemeManager.colors["button"]
    palette.midlight: Cpp_ThemeManager.colors["midlight"]
    palette.highlight: Cpp_ThemeManager.colors["highlight"]
    palette.windowText: Cpp_ThemeManager.colors["window_text"]
    palette.brightText: Cpp_ThemeManager.colors["bright_text"]
    palette.buttonText: Cpp_ThemeManager.colors["button_text"]
    palette.toolTipBase: Cpp_ThemeManager.colors["tooltip_base"]
    palette.toolTipText: Cpp_ThemeManager.colors["tooltip_text"]
    palette.linkVisited: Cpp_ThemeManager.colors["link_visited"]
    palette.alternateBase: Cpp_ThemeManager.colors["alternate_base"]
    palette.placeholderText: Cpp_ThemeManager.colors["placeholder_text"]
    palette.highlightedText: Cpp_ThemeManager.colors["highlighted_text"]

    anchors {
      fill: parent
      topMargin: -16
      leftMargin: -9
      rightMargin: -9
      bottomMargin: -10
    }

    //
    // Group actions panel
    //
    Rectangle {
      z: 2
      id: header
      height: 64
      color: Cpp_ThemeManager.colors["groupbox_background"]
      anchors {
        top: parent.top
        left: parent.left
        right: parent.right
      }

      //
      // Buttons
      //
      RowLayout {
        spacing: 4

        anchors {
          margins: 8
          left: parent.left
          right: parent.right
          verticalCenter: parent.verticalCenter
        }

        //
        // Add generic dataset
        //
        Widgets.BigButton {
          icon.width: 24
          icon.height: 24
          text: qsTr("Dataset")
          Layout.alignment: Qt.AlignVCenter
          palette.buttonText: Cpp_ThemeManager.colors["button_text"]
          icon.source: "qrc:/rcc/icons/project-editor/actions/add-dataset.svg"
          onClicked: Cpp_Project_Model.addDataset(ProjectModel.DatasetGeneric)
        }

        //
        // Add plot
        //
        Widgets.BigButton {
          icon.width: 24
          icon.height: 24
          text: qsTr("Plot")
          Layout.alignment: Qt.AlignVCenter
          palette.buttonText: Cpp_ThemeManager.colors["button_text"]
          icon.source: "qrc:/rcc/icons/project-editor/actions/add-plot.svg"
          onClicked: Cpp_Project_Model.addDataset(ProjectModel.DatasetPlot)
        }

        //
        // Add FFT plot
        //
        Widgets.BigButton {
          icon.width: 24
          icon.height: 24
          text: qsTr("FFT Plot")
          Layout.alignment: Qt.AlignVCenter
          palette.buttonText: Cpp_ThemeManager.colors["button_text"]
          icon.source: "qrc:/rcc/icons/project-editor/actions/add-fft.svg"
          onClicked: Cpp_Project_Model.addDataset(ProjectModel.DatasetFFT)
        }

        //
        // Add bar
        //
        Widgets.BigButton {
          icon.width: 24
          icon.height: 24
          text: qsTr("Bar/Level")
          Layout.alignment: Qt.AlignVCenter
          palette.buttonText: Cpp_ThemeManager.colors["button_text"]
          icon.source: "qrc:/rcc/icons/project-editor/actions/add-bar.svg"
          onClicked: Cpp_Project_Model.addDataset(ProjectModel.DatasetBar)
        }

        //
        // Add gauge
        //
        Widgets.BigButton {
          icon.width: 24
          icon.height: 24
          text: qsTr("Gauge")
          Layout.alignment: Qt.AlignVCenter
          palette.buttonText: Cpp_ThemeManager.colors["button_text"]
          icon.source: "qrc:/rcc/icons/project-editor/actions/add-gauge.svg"
          onClicked: Cpp_Project_Model.addDataset(ProjectModel.DatasetGauge)
        }

        //
        // Add compass
        //
        Widgets.BigButton {
          icon.width: 24
          icon.height: 24
          text: qsTr("Compass")
          Layout.alignment: Qt.AlignVCenter
          palette.buttonText: Cpp_ThemeManager.colors["button_text"]
          icon.source: "qrc:/rcc/icons/project-editor/actions/add-compass.svg"
          onClicked: Cpp_Project_Model.addDataset(ProjectModel.DatasetCompass)
        }

        //
        // Spacer
        //
        Item {
          Layout.fillWidth: true
        }

        //
        // Duplicate group
        //
        Widgets.BigButton {
          icon.width: 24
          icon.height: 24
          text: qsTr("Duplicate")
          Layout.alignment: Qt.AlignVCenter
          onClicked: Cpp_Project_Model.duplicateCurrentGroup()
          palette.buttonText: Cpp_ThemeManager.colors["button_text"]
          icon.source: "qrc:/rcc/icons/project-editor/actions/duplicate.svg"
        }

        //
        // Delete group
        //
        Widgets.BigButton {
          icon.width: 24
          icon.height: 24
          text: qsTr("Delete")
          Layout.alignment: Qt.AlignVCenter
          onClicked: Cpp_Project_Model.deleteCurrentGroup()
          palette.buttonText: Cpp_ThemeManager.colors["button_text"]
          icon.source: "qrc:/rcc/icons/project-editor/actions/delete.svg"
        }
      }

      //
      // Bottom border
      //
      Rectangle {
        height: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: Cpp_ThemeManager.colors["groupbox_border"]
      }
    }

    //
    // Group model editor
    //
    TableDelegate {
      id: delegate
      anchors.fill: parent
      anchors.topMargin: header.height
      modelPointer: Cpp_Project_Model.groupModel

      footerItem: Image {
        readonly property real aspectRatio: 668 / 300
        readonly property real idealWidth: delegate.width * 0.8
        readonly property real idealHeight: delegate.height - delegate.tableHeight
        readonly property real maxWidth: idealHeight * aspectRatio
        readonly property real maxHeight: idealWidth / aspectRatio
        readonly property real actualWidth: Math.min(idealWidth, maxWidth)
        readonly property real actualHeight: Math.min(idealHeight, maxHeight)

        smooth: true
        antialiasing: true
        source: "qrc:/rcc/diagrams/group-dfd.svg"
        sourceSize: Qt.size(actualWidth, actualHeight)
      }
    }
  }
}
