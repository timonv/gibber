require_relative '../lib/gibber'
require "minitest/autorun"
require "pry"

class TestGibber < MiniTest::Test
  def test_single_char
    word = 'x'
    result = Gibber.new.replace(word)

    assert(result != "", "Single char should always have a match!")
  end

  def test_single_word
    word = 'word'
    result = Gibber.new.replace(word)
    margin = (Gibber::MARGIN * word.length).to_i
    lbound = word.length - margin
    rbound = word.length + margin

    assert(result.length >= lbound && result.length <= rbound, "Word length not within margin")
    assert(result != word, "Word should not equal result")
  end

  def test_numerics
    word = '1'
    result = Gibber.new.replace(word)

    assert(result == word, "#{result} does not equal #{word}")

    word = '12 342345 677 63454'
    result = Gibber.new.replace(word)

    assert(result == word, "#{result} does not equal #{word}")
  end

  def test_sentence
    sentence = "I'm passionate about bananas."
    result = Gibber.new.replace(sentence)
    margin = (Gibber::MARGIN * sentence.length).to_i
    lbound = sentence.length - margin
    rbound = sentence.length + margin

    assert(result.length >= lbound && result.length <= rbound, "Sentence length not within margin")
    assert(result != sentence, "Sentence should not equal result")
  end

  def test_capitalization
    sentence = "I'm passionate about bananas."
    result = Gibber.new.replace(sentence)

    assert(result[0] == result[0].upcase, "Expected first letter to be uppercase")

    sentence = "i'm passionate about bananas."
    result = Gibber.new.replace(sentence)

    assert(result[0] == result[0].downcase, "Expected first letter to be lowercase")
  end

  def test_always_match_upto_100
    (1..100).each do |i|
      word = 'z' * i
      result = Gibber.new.replace(word)
      
      assert(result != word, 'Expected a match but got nil')
    end
  end

  def test_preserve_trailing
    %w{! ? .}.each do |trailing|
      sentence = "I'm passionate about bananas#{trailing}"
      result = Gibber.new.replace(sentence)

      assert(result[-1] == "#{trailing}", "Expected last char to be #{trailing} but got #{result}")
    end
  end

  def test_finite_recursion
    result = Gibber.new.replace("dskafjlsdknfasljdjfl\nkadsjflkassf23sdvcxcvaefegasdfczcvsafd329857239852jdlkfjasdlfjalksdjflkadjaf")
    assert(result != nil)
  end

  def test_preserve_non_wordy_characters
    sentence = 'I really like playing "God", but I am not a fan'
    result = Gibber.new.replace(sentence)
    
    assert(result =~ /^.+"\w+",.+$/, "Expected result to match original non-wordy chars but got #{result}")
  end

  def test_preserve_html
    sentence = "I'm passionate <a>about</a> bananas"
    result = Gibber.new.replace(sentence)

    assert(result =~ /<a>/, "Expected result to include opening tag <a>")
    assert(result =~ /<\/a>/, "Excpected result to include closing tag </a>")
    assert(result != sentence)
  end

  def test_preserve_complex_html
    sentence = "<p>I'm passionate <br/> <a>about</a> bananas</p>"
    result = Gibber.new.replace(sentence)

    assert(result !~ /bananas/)
    assert(result =~ /<p>.*<br>.*<a>.*<\/a>.*<\/p>/)
  end

  # Quick test for user verifying bigger texts
  # def test_big_text
  #   text = <<-NIETZSCHE
  #     The Madman. Have you ever heard of the madman who on a bright morning lighted a lantern and ran to the market-place calling out unceasingly: "I seek God! I seek God!" As there were many people standing about who did not believe in God, he caused a great deal of amusement. Why? is he lost? said one. Has he strayed away like a child? said another. Or does he keep himself hidden? Is he afraid of us? Has he taken a sea voyage? Has he emigrated? - the people cried out laughingly, all in a hubbub.

  #     The insane man jumped into their midst and transfixed them with his glances. "Where is God gone?" he called out. "I mean to tell you! We have killed him, you and I! We are all his murderers! But how have we done it? How were we able to drink up the sea? Who gave us the sponge to wipe away the whole horizon? What did we do when we loosened this earth from its sun? Whither does it now move? Whither do we move? Away from all suns? Do we not dash on unceasingly? Backwards, sideways, forwards, in all directions? Is there still an above and below? Do we not stray, as through infinite nothingness? Does not empty space breathe upon us? Has it not become colder? Does not night come on continually, darker and darker? Shall we not have to light lanterns in the morning? Do we not hear the noise of the grave-diggers who are burying God? Do we not smell the divine putrefaction? - for even Gods putrify! God is dead! God remains dead! And we have killed him!
      
  #     How shall we console ourselves, the most murderous of all murderers? The holiest and the mightiest that the world has hitherto possessed, has bled to death under our knife - who will wipe the blood from us? With what water could we cleanse ourselves? What lustrums, what sacred games shall we have to devise? Is not the magnitude of this deed too great for us? Shall we not ourselves have to become Gods, merely to seem worthy of it? There never was a greater event - and on account of it, all who are born after us belong to a higher history than any history hitherto!" Here the madman was silent and looked again at his hearers; they also were silent and looked at him in surprise.

  #     At last he threw his lantern on the ground, so that it broke in pieces and was extinguished. "I come too early," he then said. "I am not yet at the right time. This prodigious event is still on its way, and is traveling - it has not yet reached men's ears. Lightning and thunder need time, the light of the stars needs time, deeds need time, even after they are done, to be seen and heard. This deed is as yet further from them than the furthest star - and yet they have done it themselves!" It is further stated that the madman made his way into different churches on the same day, and there intoned his Requiem aeternam deo. When led out and called to account, he always gave the reply: "What are these churches now, if they are not the tombs and monuments of God?"
  #   NIETZSCHE

  #   gibber = Gibber.new
  #   result = text.gsub(/[.?!]/, '\0|').split('|').map { |sentence| gibber.replace(sentence) }.join("")
  #   # no error
  # end
end
