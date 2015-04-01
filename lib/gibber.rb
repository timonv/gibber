require_relative "gibber/version"

class Gibber
  MARGIN = 0.3

  def replace(text)
    text
      .gsub(/\W/, '|\0|')
      .split('|')
      .map(&method(:replace_word))
      .join('')
  end

  private

  # recursive if missing translation
  def replace_word(word, tries_left=100)
    return word if blank?(word) || numeric?(word) || !wordy?(word)

    possible_keys = keys_within_margin_for_word(word)
    if translation = translation_at_keys(*possible_keys)
      conditional_capitalize(word, translation)
    else
      tries_left == 0 ? ['I','V','X'].sample : replace_word(word[0..-2], tries_left - 1)
    end
  end

  def blank?(word)
    !word || word == ""
  end

  def numeric?(word)
     word =~ /^\d+$/
  end

  def wordy?(word)
    word =~ /^\w+$/
  end

  def keys_within_margin_for_word(word)
    word_hash.keys.select { |k| word.length >= k[0] && word.length <= k[1]}
  end

  def translation_at_keys(*keys)
    if translation = word_hash
      .values_at(*keys)
      .flatten
      .reject { |t| t == @previous } # Never have two identical translations after each other
      .sample

      @previous = translation
    end
  end

  def conditional_capitalize(original_word, translated_word)
    if original_word[0] == original_word[0].upcase
      translated_word.capitalize 
    else
      translated_word
    end
  end

  def word_hash
    @_word_hash ||= begin
                      text.split(' ').select(&method(:wordy?)).inject({}) do |hash, word|
                        key = generate_key(word)
                        hash[key] ||= []
                        hash[key] = (hash[key] + [word.downcase]).uniq; hash
                      end
                    end
  end

  def generate_key(word)
    margin = (MARGIN * word.length).to_i
    lbound = [word.length - margin, 1].max
    rbound = word.length + margin
    [lbound, rbound]
  end

  def text
    <<-LATIN
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id risus lorem. Fusce in nulla auctor felis viverra suscipit. Sed auctor lobortis massa, euismod varius nulla interdum a. Morbi rhoncus ultrices urna, vitae vulputate dui tempor gravida. Quisque quis diam lorem. Nam non urna posuere, faucibus leo vitae, ullamcorper sem. Donec nec felis ultrices, ultrices augue et, fringilla ante. Etiam lacinia dolor non odio malesuada elementum. Vestibulum vitae risus sollicitudin, lobortis massa eget, auctor ante. Curabitur nec urna quis sapien iaculis hendrerit. Nam scelerisque leo dolor, non pulvinar ipsum tempus nec. Proin volutpat magna eu feugiat egestas. Pellentesque sed massa arcu. Nam vel magna posuere, viverra nunc eu, mollis turpis. Integer ultrices lacus ut velit ullamcorper, ac molestie risus rhoncus. Morbi at ante luctus, dignissim ligula in, ullamcorper elit.

    Aenean vel efficitur lacus. Suspendisse quis nunc libero. Nullam a elit venenatis, porttitor nibh vel, dignissim turpis. Cras luctus arcu vitae velit semper, et convallis eros ultricies. Nunc at risus nec sem scelerisque tincidunt. Suspendisse eu accumsan orci. In hac habitasse platea dictumst. Etiam faucibus odio dui, quis volutpat eros pulvinar at. Donec tristique quam sem, sit amet feugiat felis tincidunt sit amet. In tincidunt lobortis est et euismod. Quisque tempus ex id enim tincidunt scelerisque. Fusce odio tortor, consequat pulvinar molestie interdum, mollis aliquam erat.

    Nam nec augue ornare, laoreet ante et, finibus dolor. Aenean pulvinar felis vel mauris efficitur faucibus. Duis venenatis id nisl eget molestie. In venenatis, sem quis dignissim fermentum, justo risus tempus quam, at venenatis diam ex a massa. Etiam urna diam, placerat ac commodo eget, egestas a urna. Proin vitae malesuada libero, eu porta risus. Nullam congue, magna non ullamcorper lobortis, lorem urna gravida sem, non pellentesque tortor elit nec nisi. Nunc lobortis dui non eros rhoncus volutpat. Nunc imperdiet urna magna, sed blandit purus efficitur aliquam. Morbi mattis, sapien non faucibus aliquam, tortor dui rhoncus diam, vitae aliquam ipsum diam nec ex. Vivamus hendrerit tortor fermentum, pulvinar felis et, porta massa. Nam et ultricies ligula. Nulla vitae augue in odio pulvinar facilisis. Pellentesque purus felis, posuere ullamcorper nibh sit amet, pellentesque pulvinar libero.

    Quisque a mi tellus. Nunc pretium massa in tempor maximus. Vivamus fermentum sapien nec eros ornare molestie. Vestibulum vitae est condimentum, varius nulla et, ornare justo. Vivamus gravida, neque ut faucibus placerat, metus metus lacinia lorem, ac feugiat arcu leo in arcu. Vestibulum eu augue non tellus hendrerit pharetra id a purus. Sed et velit quis leo efficitur rutrum ac eu leo. Maecenas rhoncus est est, vel eleifend arcu pharetra sed. Curabitur ligula enim, dapibus non vulputate id, efficitur ut nisl.

    Nulla facilisi. Integer vulputate ultricies mi id interdum. Sed pharetra risus vitae urna mattis, nec maximus nisl bibendum. Sed in elit sit amet ipsum condimentum commodo. Etiam consequat purus magna, vel malesuada est interdum iaculis. Proin commodo, magna ac vehicula pharetra, tellus urna fermentum dui, in rutrum turpis lacus in sem. Donec in elementum nisi. Etiam fringilla diam vitae nulla varius volutpat. Vivamus at lacus porttitor, luctus dui at, eleifend ligula. Sed ac elit in enim varius vestibulum quis rhoncus arcu. Nullam tristique id nisi non feugiat.
    LATIN
  end
end
