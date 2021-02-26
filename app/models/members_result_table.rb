# frozen_string_literal: true

class MembersResultTable < SpreadsheetResultTable
  attr_reader :name, :members

  def initialize(members, spreadsheet)
    @name = spreadsheet.name
    @members = members
    super(spreadsheet)
  end

  ##
  # Rows are collected over member spreadsheets. Hence,
  # all calculations will be based on these rows.
  #
  def rows
    collection = []
    members.each do |member|
      collection << spreadsheet_of(member)&.rows
    end
    collection.compact
  end

  def row_ids
    rows.map(&:ids).flatten
  end

  private

  def spreadsheet_of(member)
    member.spreadsheets.find_by(name: name)
  end
end
