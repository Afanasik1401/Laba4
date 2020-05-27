# frozen_string_literal: true

require 'forwardable'

# The list of tests to manage
class BookList
  extend Forwardable
  def_delegator :@books, :each, :each_book
  def initialize(books = [])
    @books = books
  end

  def add_book(book)
    @books.append(book)
  end

  def all_books
    @books.dup
  end

  def sort_by_date
    @books.sort { |book1, book2| -(book1.date <=> book2.date) }
  end

  def years
    years = []
    @books.each do |book|
      datearray = book.date.split('-').map(&:to_i)
      years.append(datearray[0])
    end
    years.uniq
  end

  def filter(format)
    @books.select do |book|
      next if format && !format.empty? && format != book.format

      true
    end
  end
  # def number_of_books(year)
  #   count=0
  #   @books.each do |book|
  #     datearray=book.date.split("-").map { |s| s.to_i }
  #     if year == datearray[0]
  #       count+=1
  #     end
  #   end
  #   count
  # end
end
