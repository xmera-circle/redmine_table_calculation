# Changelog for Redmine Table Calculation

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.0.5 - 2021-04-04

### Changed

* project type association for tables to be compatible with Redmine Project
  Type plugin version 4.0.0
* existing tests to be compatible with ProjectType class of Redmine Project 
  Type plugin version 4.0.0
* project_types_table in naming to reflect its usage better

### Added

* administration link for table columns in table configuration
* :de localisation for permissions
* :en localisation at all

## 0.0.4 - 2021-03-07

### Added

* add wikitoolbar for table custom fields

## 0.0.3 - 2021-03-03

### Fixed

* calculation flow of guests of a certain host

## 0.0.2 - 2021-03-02

### Fixed

* presentation of key/value custom field in calculation summary box

### Changed

* SpreadsheetRowResult#comment to be required

## 0.0.1 - 2021-03-01

### Added

* plugin with project module
* custom fields support
* global table configuration
* global calculation definition and assignment to configured tables
* local spreadsheet creation in projects
* aggregated calculation results for linked projects (Redmine Project Types Relations)
