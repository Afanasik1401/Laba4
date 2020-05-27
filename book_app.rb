# frozen_string_literal: true

require 'forme'
require 'roda'
require_relative 'models'

# The core class of the web application for managing books
class BookApp < Roda
  opts[:root] = __dir__
  plugin :environments
  plugin :render
  plugin :forme
  configure :development do
    plugin :public
    opts[:serve_static] = true
  end
  opts[:books] = BookList.new([
                                Book.new('Горе от ума', 'Грибоедов', '2020-04-05', '4', 'бумажный'),
                                Book.new('Мастер и Маргарита', 'Булгаков', '2020-04-20', '4', 'электронный'),
                                Book.new('Бородино', 'Лермонтов', '2020-06-20', '3', 'бумажный'),
                                Book.new('Над пропастью во ржи', 'Сэлинджер', '2019-07-21', '5', 'электронный')
                              ])
  route do |r|
    r.public if opts[:serve_static]
    r.on 'books' do
      r.is do
        @params = DryResultFormeAdapter.new(BookFilterFormSchema.call(r.params))
        @books = if @params.success?
                   opts[:books].filter(@params[:format])

                 else

                   opts[:books].all_books.sort_by_date

        end
        view('books')
      end
      r.on 'statistics' do
        r.get do
          @books = opts[:books].sort_by_date
          @years = opts[:books].years
          view('statistics')
        end
      end
      r.get Integer do |year|
        @books = opts[:books].sort_by_date
        @year = year
        view('info')
      end
      r.on 'new' do
        r.get do
          view('new_book')
        end
        r.post do
          @params = InputValidators.check_book(r.params['name'], r.params['date'], r.params['author'], r.params['rating'], r.params['format'], r.params['size'])
          if @params[:errors].empty?
            opts[:books].add_book(Book.new(@params[:name], @params[:author], @params[:date], @params[:rating], @params[:format]))
            opts[:books].sort_by_date
            r.redirect '/books'
          else
            view('new_book')
          end
        end
      end
    end
  end
end
