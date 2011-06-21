module YuiCompressor
   def self.compress input_file_name, output_file_name = nil
     output_file_name = input_file_name if output_file_name.blank?
     system("java -jar #{path_to_jar_file} #{input_file_name} -o #{output_file_name}")
   end
end

def all_js_files
  x = File.join(assets_path,"javascripts","**","*.js")
  Dir.glob(x).select{|x| !["compressed.js"].include?(File.basename(x))}
end

def all_css_files
  x = File.join(assets_path,"stylesheets","**","*.css")
  Dir.glob(x).select{|x| !["compressed.css"].include?(File.basename(x))}
end

def assets_path
  ::Rails.root.to_s + "/public"
end

def path_to_jar_file
  File.join(File.dirname(__FILE__), *%w".. lib yuicompressor-2.4.4.jar")
end

namespace :yui do

  desc "Compresses all javascript files form public/javascripts folder"
  task :all_js_compress do

    script = String.new
    all_js_files.each{ |file| script += (IO.read(file) + "\n\n") }
    
    file_name = File.join(assets_path + "/javascripts", 'compressed.js')
    
    File.open(file_name, 'w') {|f|
      f.write(script)
    }

    YuiCompressor.compress file_name
  end
  
  desc "Compresses all stylesheet files from public/stylesheets folder"
  task :all_css_compress do
    script = String.new
    all_css_files.each { |file| script += (IO.read(file) + "\n\n") }
    
    file_name = File.join(assets_path + "/stylesheets", 'compressed.css')
    
    File.open(file_name, 'w') {|f|
      f.write(script)
    }

    YuiCompressor.compress file_name
  end   
end
