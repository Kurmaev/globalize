require 'i18n/backend/simple'

module I18n
  module Backend
    class Pluralizing < Simple
      def pluralize(locale, entry, count)
        return entry unless entry.is_a?(Hash) and count
        key = :zero if count == 0 && entry.has_key?(:zero)
        key ||= pluralizer(locale).call(count)
        raise InvalidPluralizationData.new(entry, count) unless entry.has_key?(key)
        entry[key]
      end
      
      def add_pluralizer(locale, pluralizer)
        pluralizers[locale.to_sym] = pluralizer
      end
      
      def pluralizer(locale)
        pluralizers[locale.to_sym] || default_pluralizer
      end
      
      protected      
        def default_pluralizer
          pluralizers[:en]
        end
      
        def pluralizers
          @pluralizers ||= { :en => lambda{|n| n == 1 ? :one : :other } }
        end
    end
  end
end