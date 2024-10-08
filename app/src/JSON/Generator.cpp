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

#include <QFileInfo>
#include <QFileDialog>
#include <QRegularExpression>

#include "Generator.h"
#include "Project/Model.h"
#include "Project/FrameParser.h"

#include "IO/Manager.h"
#include "Misc/Utilities.h"

/**
 * Initializes the JSON Parser class and connects appropiate SIGNALS/SLOTS
 */
JSON::Generator::Generator()
  : m_opMode(kManual)
{
  connect(&IO::Manager::instance(), &IO::Manager::frameReceived, this,
          &JSON::Generator::readData);

  readSettings();
}

/**
 * Returns the only instance of the class
 */
JSON::Generator &JSON::Generator::instance()
{
  static Generator singleton;
  return singleton;
}

/**
 * Returns the file name (e.g. "JsonMap.json") of the loaded JSON map file
 */
QString JSON::Generator::jsonMapFilename() const
{
  if (m_jsonMap.isOpen())
  {
    auto fileInfo = QFileInfo(m_jsonMap.fileName());
    return fileInfo.fileName();
  }

  return "";
}

/**
 * Returns the file path of the loaded JSON map file
 */
QString JSON::Generator::jsonMapFilepath() const
{
  if (m_jsonMap.isOpen())
  {
    auto fileInfo = QFileInfo(m_jsonMap.fileName());
    return fileInfo.filePath();
  }

  return "";
}

/**
 * Returns the JSON map data from the loaded file as a string
 */
const QJsonObject &JSON::Generator::json() const
{
  return m_json;
}

/**
 * Returns the operation mode
 */
JSON::Generator::OperationMode JSON::Generator::operationMode() const
{
  return m_opMode;
}

/**
 * Creates a file dialog & lets the user select the JSON file map
 */
void JSON::Generator::loadJsonMap()
{
  const auto file = QFileDialog::getOpenFileName(
      Q_NULLPTR, tr("Select JSON map file"),
      Project::Model::instance().jsonProjectsPath(),
      tr("JSON files") + QStringLiteral(" (*.json)"));

  if (!file.isEmpty())
    loadJsonMap(file);
}

/**
 * Opens, validates & loads into memory the JSON file in the given @a path.
 */
void JSON::Generator::loadJsonMap(const QString &path)
{
  // Validate path
  if (path.isEmpty())
    return;

  // Close previous file (if open)
  if (m_jsonMap.isOpen())
  {
    m_jsonMap.close();
    m_json = QJsonObject();
    Q_EMIT jsonFileMapChanged();
  }

  // Try to open the file (read only mode)
  m_jsonMap.setFileName(path);
  if (m_jsonMap.open(QFile::ReadOnly))
  {
    // Read data & validate JSON from file
    QJsonParseError error;
    auto data = m_jsonMap.readAll();
    auto document = QJsonDocument::fromJson(data, &error);
    if (error.error != QJsonParseError::NoError)
    {
      m_jsonMap.close();
      writeSettings("");
      Misc::Utilities::showMessageBox(tr("JSON parse error"),
                                      error.errorString());
    }

    // JSON contains no errors, load compacted JSON document & save settings
    else
    {
      // Save settings
      writeSettings(path);

      // Load compacted JSON document
      document.object().remove(QStringLiteral("frameParser"));
      m_json = document.object();
    }

    // Get rid of warnings
    Q_UNUSED(document);
  }

  // Open error
  else
  {
    writeSettings("");
    Misc::Utilities::showMessageBox(
        tr("Cannot read JSON file"),
        tr("Please check file permissions & location"));
    m_jsonMap.close();
  }

  // Update UI
  Q_EMIT jsonFileMapChanged();
}

/**
 * @brief Assigns an instance to the frame parser to be used to split frame
 *        data/elements into individual parts.
 */
void JSON::Generator::setFrameParser(Project::FrameParser *parser)
{
  m_frameParser = parser;
}

/**
 * Changes the operation mode of the JSON parser. There are two possible op.
 * modes:
 *
 * @c kManual serial data only contains the comma-separated values, and we need
 *            to use a JSON map file (given by the user) to know what each value
 *            means. This method is recommended when we need to transfer &
 *            display a large amount of information from the microcontroller
 *            unit to the computer.
 *
 * @c kAutomatic serial data contains the JSON data frame, good for simple
 *               applications or for prototyping.
 */
void JSON::Generator::setOperationMode(const OperationMode mode)
{
  m_opMode = mode;
  Q_EMIT operationModeChanged();
}

/**
 * Loads the last saved JSON map file (if any)
 */
void JSON::Generator::readSettings()
{
  auto path
      = m_settings.value(QStringLiteral("json_map_location"), "").toString();
  if (!path.isEmpty())
    loadJsonMap(path);
}

/**
 * Saves the location of the last valid JSON map file that was opened (if any)
 */
void JSON::Generator::writeSettings(const QString &path)
{
  m_settings.setValue(QStringLiteral("json_map_location"), path);
}

/**
 * Tries to parse the given data as a JSON document according to the selected
 * operation mode.
 *
 * Possible operation modes:
 * - Auto:   serial data contains the JSON data frame
 * - Manual: serial data only contains the comma-separated values, and we need
 *           to use a JSON map file (given by the user) to know what each value
 *           means
 *
 * If JSON parsing is successfull, then the class shall notify the rest of the
 * application in order to process packet data.
 */
void JSON::Generator::readData(const QByteArray &data)
{
  // Data empty, abort
  if (data.isEmpty())
    return;

  // Serial device sends JSON (auto mode)
  QJsonObject jsonData;
  if (operationMode() == JSON::Generator::kAutomatic)
    jsonData = QJsonDocument::fromJson(data).object();

  // Data is separated and parsed by Serial Studio (manual mode)
  else if (m_frameParser)
  {
    // Copy JSON map
    jsonData = m_json;

    // Convert binary frame data to a string
    QString frameData;
    QString separator;
    switch (Project::Model::instance().decoderMethod())
    {
      case Project::Model::Normal:
        frameData = QString::fromUtf8(data);
        separator = IO::Manager::instance().separatorSequence();
        break;
      case Project::Model::Hexadecimal:
        frameData = QString::fromUtf8(data.toHex());
        separator = "";
        break;
      case Project::Model::Base64:
        frameData = QString::fromUtf8(data.toBase64());
        separator = "";
        break;
      default:
        frameData = QString::fromUtf8(data);
        separator = IO::Manager::instance().separatorSequence();
        break;
    }

    // Get fields from frame parser function
    auto fields = m_frameParser->parse(frameData, separator);

    // Replace data in JSON map
    auto groups = jsonData.value(QStringLiteral("groups")).toArray();
    for (int i = 0; i < groups.count(); ++i)
    {
      // Get group & list of datasets
      auto group = groups.at(i).toObject();
      auto datasets = group.value(QStringLiteral("datasets")).toArray();

      // Evaluate each dataset
      for (int j = 0; j < datasets.count(); ++j)
      {
        auto dataset = datasets.at(j).toObject();
        auto index = dataset.value(QStringLiteral("index")).toInt();

        if (index <= fields.count() && index >= 1)
        {
          const auto value = QJsonValue(fields.at(index - 1));

          dataset.remove(QStringLiteral("value"));
          dataset.insert(QStringLiteral("value"), value);
          datasets.removeAt(j);
          datasets.insert(j, dataset);
        }
      }

      // Update datasets in group
      group.remove(QStringLiteral("datasets"));
      group.insert(QStringLiteral("datasets"), datasets);

      // Update group in groups array
      groups.removeAt(i);
      groups.insert(i, group);

      // Update groups array in JSON frame
      jsonData.remove(QStringLiteral("groups"));
      jsonData.insert(QStringLiteral("groups"), groups);
    }
  }

  // Update UI
  if (!jsonData.isEmpty())
    Q_EMIT jsonChanged(jsonData);
}
