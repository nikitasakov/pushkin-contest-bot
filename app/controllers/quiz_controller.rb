class QuizController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    
  end

  def task
    info_string = File.read('database.json')
    info = JSON.parse(info_string)
    answer = ""
    string = params["question"]
    level = params["level"].to_i
    id = params["id"]
    case level
    when 1
      info.size.times do |i|
        if info[i][1].include?(string)
          answer = info[i][0]
          break
        end
      end
    when 2
      string_part = string.split('%WORD%')
      info.size.times do |i|
        answer = nil
        if string_part[0].empty? && info[i][1].include?(string_part[1])
          answer = info[i][1].split(string_part[1])
          answer = answer[0]
        end
        if string_part[1].nil? && info[i][1].include?(string_part[0])
          answer = info[i][1].split(string_part[0])
          answer = answer[1]
        end
        if info[i][1].include?(string_part[0]) && info[i][1].include?(string_part[1])
          answer = info[i][1].split(string_part[0])
          answer = answer[1].split(string_part[1])
          answer = answer[0]
        end
        if answer != nil
          break
        end
      end
    when 3
      string = string.split('\n')
      devited_first = string[0].split('%WORD%')
      devited_second = string[1].split('%WORD%')
      answer1 = nil
      answer2 = nil
      info.size.times do |i|
        devited_info = info[i][1].split("\n")
        devited_info.size.times do |j|
          if devited_info[j].include?(devited_first[0]) && devited_info[j].include?(devited_first[1])
            if devited_info[j+1].include?(devited_second[0]) && devited_info[j+1].include?(devited_second[1])
              string[0] = string[0].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','')
              string[1] = string[1].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','')
              string_with_variable_1 = string[0].split
              string_with_variable_2 = string[1].split
              string_without_variable_1 = devited_info[j].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').split
              string_without_variable_2 = devited_info[j+1].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').split
              string_with_variable_1.size.times do |k|
                if string_with_variable_1[k] == "%WORD%"
                  answer1 = string_without_variable_1[k]
                  break
                end
              end
              string_with_variable_2.size.times do |k|
                if string_with_variable_2[k] == "%WORD%"
                  answer2 = string_without_variable_2[k]
                  break
                end
              end
              answer = "#{answer1},#{answer2}"
            end
            break
          end
        end
        if answer != nil
          break
        end
      end
    when 4
      string = string.split('\n')
      devited_first = string[0].split('%WORD%')
      devited_second = string[1].split('%WORD%')
      devited_third = string[2].split('%WORD%')
      answer1 = nil
      answer2 = nil
      answer3 = nil
      info.size.times do |i|
        devited_info = info[i][1].split("\n")
        devited_info.size.times do |j|
          if devited_info[j].include?(devited_first[0]) && devited_info[j].include?(devited_first[1])
            if devited_info[j+1].include?(devited_second[0]) && devited_info[j+1].include?(devited_second[1])
              if devited_info[j+2].include?(devited_third[0]) && devited_info[j+2].include?(devited_third[1])
                string[0] = string[0].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','')
                string[1] = string[1].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','')
                string[2] = string[2].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','')
                string_with_variable_1 = string[0].split
                string_with_variable_2 = string[1].split
                string_with_variable_3 = string[2].split
                string_without_variable_1 = devited_info[j].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').split
                string_without_variable_2 = devited_info[j+1].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').split
                string_without_variable_3 = devited_info[j+2].tr(',','').tr('!','').tr('.','').tr(';','').tr('—','').tr('?','').tr(':','').split
                string_with_variable_1.size.times do |k|
                  if string_with_variable_1[k] == "%WORD%"
                    answer1 = string_without_variable_1[k]
                    break
                  end
                end
                string_with_variable_2.size.times do |k|
                  if string_with_variable_2[k] == "%WORD%"
                    answer2 = string_without_variable_2[k]
                    break
                  end
                end
                string_with_variable_3.size.times do |k|
                  if string_with_variable_3[k] == "%WORD%"
                    answer3 = string_without_variable_3[k]
                    break
                  end
                end
              end
            end
            break
          end
        end
      end
      answer = "#{answer1},#{answer2},#{answer3}"
    end
    if answer
      uri_app = URI('http://pushkin.rubyroidlabs.com/quiz')

      parameters = {
        answer: answer,
        token: '62a577a09ddc094e97031892510c16fd',
        task_id: id
      }
      Net::HTTP.post_form(uri_app, parameters)
    end
  end
end

