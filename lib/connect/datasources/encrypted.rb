require 'openssl'
require 'base64'
require 'connect/datasources/base'

module Connect
  module Datasources
    ##
    #
    # The `Encrypted` datasource allows you to sue encrypted data in your configs.
    #
    #
    class Encrypted < Base
      ##
      #
      # Creates a Cypher with the specfied code and saves it. The lookup will use the cypher to decrypt
      # data
      #
      # @param _name [String] the name of the datasource. In this case it will always be `yaml`
      # @param password [String] The decryption password used for the cypher
      # @param algorithm [String] The decryption algorithm
      #
      # @return [Datasource::Base] An initialized datasource
      #
      def initialize(_name, password = nil, algorithm = 'AES-128-CBC')
        fail ArgumentError, 'password required as first argument of encrypted datasource' unless password
        super
        @cipher     = OpenSSL::Cipher.new(algorithm)
        @cipher.decrypt
        @cipher.key = password
      end
      ##
      #
      # Decrypt the data in the key and return the values
      #
      # @param encrypted_string [String] the encrypted data
      # @return The decrypted value of the encrypted string
      def lookup(encrypted_string)
        crypted_iv, crypted_value = encrypted_string.split('|')
        fail ArgumentError, 'invalid value for decryption' unless crypted_iv && crypted_value
        iv = Base64.decode64(crypted_iv)
        value = Base64.decode64(crypted_value)
        @cipher.iv = iv
        @cipher.update(value) + @cipher.final
      end
    end
  end
end
