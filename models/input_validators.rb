# frozen_string_literal: true

# Validators for the incoming requests
module InputValidators
  def self.check_date_format(date)
    if /\d{4}-\d{2}-\d{2}/ =~ date
      []
    else
      ['Дата должна быть передана в формате ГГГГ-ММ-ДД']
    end
  end

  def self.check_book(raw_name, raw_date, raw_author, raw_rating, raw_format, raw_size)
    name = raw_name || ''
    date = raw_date || ''
    author = raw_author || ''
    rating = raw_rating || ''
    format1 = raw_format || ''
    size = raw_size || ''
    errors = [].concat(check_name(name))
               .concat(check_date(date))
               .concat(check_author(author))
               .concat(check_date_format(date))
               .concat(check_correct_date(date))
               .concat(check_rating(rating))
               .concat(check_format(format1))
               .concat(check_size(size))
               .concat(check_correct_format(format1, size))
    {
      name: name,
      date: date,
      author: author,
      rating: rating,
      format: format1,
      size: size,
      errors: errors
    }
  end

  def self.check_name(name)
    if name.empty?
      ['Название книги  не может быть пустым']
    else
      []
    end
  end

  def self.check_size(size)
    if size.empty?
      ['Размер книги  не может быть пустым']
    else
      []
    end
  end

  def self.check_author(author)
    if author.empty?
      ['Имя автора не может быть пустым']
    else
      []
    end
  end

  def self.check_date(date)
    if date.empty?
      ['Дата не может быть пустой']
    else
      []
    end
  end

  def self.check_format(format1)
    if format1.empty?
      ['Формат книги  не может быть пустым']
    elsif (format1 == 'бумажный') || (format1 == 'электронный') || (format1 == 'аудиокнига')
      []
    else
      ['Допустимые значения поля формат: -бумажный,-электронный,-аудиокнига']
    end
  end

  def self.check_rating(rating)
    if rating.empty?
      ['Оценка не может быть пустой']
    elsif (rating.to_i < 0) || (rating.to_i > 10)
      ['Оценка - число от 0 до 10']
    else
      []
    end
  end

  def self.check_correct_format(format1, size)
    if (format1 == 'бумажный') && (size.to_i > 0) && (size =~ /[0-9]/) || (format1 == 'электронный') && (size.to_i > 0) && (size =~ /[0-9]/) || (format1 == 'аудиокнига') && (/\d{1}:\d{2}:\d{2}/ =~ size)
      []
    else
      ['кол-во страниц для бумажной книги и кол-во символов в электронной книге является натуральным числом, длительность аудиокниги записана в формате h:mm:ss ']
      end
  end

  def self.check_correct_date(date)
    ardate = date.split('-').map(&:to_i)
    if date.empty?
      ['Дата не может быть пустой']
    elsif (ardate[0] > 2020) || (ardate[0] < 1)
      ['Год не может быть больше 2020 или меньше 1']
    elsif (ardate[1] < 1) || (ardate[1] > 12)
      ['Месяц не может быть больше 12 или меньше 1']
    elsif (ardate[2] < 1) || (ardate[2] > 31)
      ['День не может быть больше 31 или меньше 1']
    else
      []
    end
  end
end
