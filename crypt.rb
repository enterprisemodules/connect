require 'openssl'
require 'base64'
require 'digest'

algorithm = 'AES-128-CBC'

password = 'mydirtylittlesecret' 

passwords = {
  :password1 => 'password_1',
  :password2 => 'password_2',
  :password3 => 'password_3',
  :password4 => 'password_4',
}

cipher = OpenSSL::Cipher.new(algorithm)
cipher.encrypt
cipher.key = password

puts "password = '#{password}'"
puts 'import from encryped("${password}") do '
passwords.each do |password, value|
  iv = cipher.random_iv
  encrypted = cipher.update(value) << cipher.final
  puts "  #{password} = #{Base64.strict_encode64(iv)}|#{Base64.strict_encode64(encrypted)}"
end
puts "end"
