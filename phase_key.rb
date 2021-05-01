require 'samovar'
require 'colorize'
require_relative "lib/encrypt"
require_relative "lib/decrypt"
require_relative "lib/edfile"



enviroment = {}

class Encrypt < Samovar::Command 

    self.description = "Encrypts a string or a file with phase key"

    options do 

        option '-s/--s <string>', 'the string you wish to encrypt (required)'
        option '-f/--file <path_to_file>', 'the file you wish to encrypt'
        option '-ch/--charset <string/path_to_file>', "the string form of the charset you wish to encrypt with"
        option '-wk/--writekey <path_to_dest>', "the file you wish to write the key too."
        option '-ws/--writestr <path_to_dest>', "the file you wish to write the encrypted string too." 

    end 

    def call 

        if options[:charset].nil? 

            puts "WARNING: No charset specifed...\nYou are using the default, hardcoded charset.\nDo not store critical information with this as it is a major security risk to do so.".colorize(:red)
            alphabet = nil 

        else 

            if File.exists?(options[:charset])

                alphabet = File.open(options[:charset]).read

            else 

                alphabet = options[:charset]
            
            end 

        end 

        if !options[:s].nil? and options[:file].nil? 

            data = encrypt([options[:s]], alphabet)
            
        end 

        if !options[:file].nil? and options[:s].nil?

            data = encrypt_file(options[:file], alphabet)

        end 

        if options[:writekey]

            File.open(options[:writekey], "w").print(data[1]) 
            puts "KEY WRITTEN TO: ".colorize(:green) + "#{options[:writekey]}"

        end 

        if options[:writestr]

            File.open(options[:writestr], "w").print(data[0].join("\n")) 
            puts "ENCRYPTED STRING WRITTEN TO: ".colorize(:green) + "#{options[:writestr]}"

        end 

        

        if options[:writekey].nil? 

            puts "KEY: ".colorize(:green) + "#{data[1]}"

        end 

        if options[:writestr].nil? 

            puts "ENCRYPTED STRING: ".colorize(:green) + "#{data[0]}"

        end 

    end  


end 

class Decrypt < Samovar::Command 
    self.description = "Encrypts a string or a file with phase key"

    options do 


        option '-s/--string <path_to_file>', 'the file you wish to decrypt' 
        option '-f/--file <path_to_file>', 'the file you wish to encrypt'
        option '-k/--key <path_to_key_file/string>', 'the key you wish to decrypt with' 
        option '-ch/--charset <string/path_to_file>', "the string form of the charset you wish to decrypt with"  
        option '-ws/--writestr <path_to_dest>', "the file you wish to write the decrypted string too." 

    end 

    def call 

        if options[:key].nil? 

            puts "No key specified. Aborting.".colorize(:red)
            exit()

        else 

            if File.exists?(options[:key])

                key = File.open(options[:key]).read()

            else 

                key = options[:key]

            end 

        end 
        
        if options[:charset].nil? 

            alphabet = nil 

        else 

            if File.exists?(options[:charset])

                alphabet = File.open(options[:charset]).read

            else 

                alphabet = options[:charset]
            
            end 

        end 

        if !options[:s].nil? and options[:file].nil? 

            data = decrypt([options[:s]], key, alphabet)
            
        end 

        if !options[:file].nil? and options[:s].nil?

            data = decrypt_file(options[:file], key, alphabet)

        end 


        if options[:writestr].nil? 

            puts "DECRYPTED STRING: ".colorize(:green) + "\n#{data.join("\n")}"

        else 

            File.open(options[:writestr], "w").print(data.join("\n")) if options[:writestr]
            puts "DECRYPTED STRING WRITTEN TO: ".colorize(:green) + options[:writestr]
            

        end 
    

    end  


end 

class Application < Samovar::Command
	options do
		option '--help', "prints the man page"
	end

	nested :command, {
        'encrypt' => Encrypt,
        'decrypt' => Decrypt
	}, default: 'encrypt'

		
	def call
		if @options[:help]
			self.print_usage
		else
			@command.call
		end
	end
end

Application.call # Defaults to ARGV.


