begin
  require 'json'

  def set_colors()
    @colors = {
      "std":  "\033[0m",
      "red":  "\033[31m",
      "gre":  "\033[32m",
      "yel":  "\033[33m",
      "pin":  "\033[35m",
      "blu":  "\033[36m"
    }
  end

  def import_json(src)
    JSON.parse(File.read(src))
  end

  def calc_stats(src)
    list = import_json(src)
    list.map { |k,v| v["value"] += rand(1..6) }
    list
  end

  def calc_list(src, stats)
    list = import_json(src)
    result = []
    list.each do |key, elem|
      stats.each_with_index do |stat, i|
        min = elem["min"][i]
        max = elem["max"][i]
        value = stat[1]["value"]
        if value < min || value > max
          break
        elsif i == stats.length - 1
          result.push(elem)
        end
      end
    end
    result
  end

  def header(text, color = @colors[:std])
    line = "====================================="
    spaces = " " * ((line.length - text.length) / 2)
    puts "#{color}#{line}"
    puts "#{spaces}#{text}#{spaces}"
    puts "#{line}#{@colors[:std]}"
  end

  def display_result(stats, origins, metiers)
    header("Statistiques", @colors[:gre])
    stats.each do |key, stat|
      color = @colors[stat["color"].to_sym]
      name =  stat["name"]
      value = stat["value"]
      puts "#{color}#{value}\t#{name}#{@colors[:std]}"
    end
    header("Origines disponibles", @colors[:yel])
    origins.each do |origin|
      puts "=> #{origin["name"]}"
    end
    header("Métiers disponibles", @colors[:blu])
    metiers.each do |metier|
      puts "=> #{metier["name"]}"
    end
    header("Fin !", @colors[:red])
    puts ""
  end

  set_colors
  stats = calc_stats("src/stats.json")
  origins = calc_list("src/origins.json", stats)
  metiers = calc_list("src/metiers.json", stats)
  display_result(stats, origins, metiers)

end
