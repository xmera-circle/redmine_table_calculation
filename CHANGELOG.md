# Changelog for Redmine Table Calculation

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.0.0 - 2023-04-06

### Changed

* migration for redmine_table_calculation_inheritance to be empty
* data model for table building and rendering
* naming of some tables and columns due to the new data model

### Added

* activation of table module in project type when this type is added in table configuration

### Fixed

* display of custom fields with radiobuttons and checkboxes
* display of second calculation row with other columns than the first row

### Deleted

* permission of spreadsheet results

## 1.0.5 - 2022-12-09

### Fixed

* data set order changes
* exceptions when copying table with certain settings
* table selection field to show only relevant tables

## 1.0.4 - 2022-10-19

### Fixed

* failing unit and system tests

## 1.0.3 - 2022-06-25

### Fixed

* failing SpreadsheetRowControllerTests

### Added

* SpreadsheetRow#visible? to support changes in Redmine 4.2.7

## 1.0.2 - 2022-03-05

### Fixed

* spreadsheet table head spreaded over two rows after adding class 'field-description'

## 1.0.1 - 2021-12-03

### Deleted

* delete tranlsations belonging to redmine_table_calculation_inheritance

## 1.0.0 - 2021-10-11

### Changed

* (breaking change) calculation base for custom field enumerations to position

### Added

* color badges for custom field enumerations
* hook for card view on project overview page

### Fixed

* typos in some translations

### Deleted

* spreadsheet row result permissions

## 0.2.1 - 2021-07-13

### Fixed

* class mismatch of Formula to avoid incompatability with other plugins
* nil errors with spreadsheets having no table assigned

### Added

* tooltip for spreadsheet column headlines
* wikitoolbar to spreadsheet description
* spreadsheet validations for name and table

## 0.2.0 - 2021-05-29

### Added

* spreadsheet selection before copying a project or project type master

### Fixed

* copying spreadsheets

### Changed

* table association for project types
* structure in lib dir

## 0.1.1 - 2021-05-01

### Deleted

* inheritance related views, controller actions, helper methods, and models (they
  are moved into Redmine Table Calculation Inheritance)

### Fixed

* permissions

### Changed

* SpreadsheetsController#index view of spreadsheets without calculations

## 0.1.0 - 2021-04-26

### Changed

* has_and_belongs_to_many :tables and has_many :spreadsheets to ProjectType class
* table selection for project having no project type to select from all tables

### Added

* further permissions in controller and views

## 0.0.5 - 2021-04-08

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
