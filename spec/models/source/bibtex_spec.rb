require 'rails_helper'

describe Source::Bibtex, :type => :model do

  let(:bibtex) { FactoryGirl.build(:source_bibtex) }

  let(:gem_bibtex_entry1) {
    BibTeX::Entry.new(bibtex_type: 'book', title: 'Foos of Bar America', author: 'Smith, James', year: 1921)
  }

  let(:gem_bibtex_entry2) {
    BibTeX::Entry.new(bibtex_type: 'book', title: 'Foos of Bar America', author: 'Smith, James', year: '1921')
  }

  let(:valid_gem_bibtex_book) {
    BibTeX::Entry.new(bibtex_type: 'book', title: 'Valid Bibtex of America', author: 'Smith, James')
  }

  #let(:invalid_gem_bibtex_book) {
  #  BibTeX::Entry.new(bibtex_type: 'book', title: 'InValid Bibtex of America',  author: 'Smith, James', year: 1921)
  #}

  let(:gem_bibtex_bibliography) {
    BibTeX.open(Rails.root + 'spec/files/bibtex/Taenionema.bib')
  }

  let(:simple1_gem_bibtex) {
    BibTeX::Entry.new()
  }

  let(:simple2_gem_bibtex) {
    BibTeX::Entry.new()
  }

  after(:all) {
    Source.destroy_all
  }

  context 'test bibtex-ruby gem capabilities we rely upon' do
    context 'using BibTeX bibliography' do
      specify 'the test file should have 42 records' do
        expect(gem_bibtex_bibliography.size).to eq(42)
      end

      specify 'the first record has 4 fields populated' do
        expect(gem_bibtex_bibliography.first.fields.keys.size).to eq(4)
      end

      specify "title of first record is 'A Monograph of the Plecoptera or Stoneflies of America North of America'" do
        expect(gem_bibtex_bibliography.first.title).to eq('A Monograph of the Plecoptera or Stoneflies of America North of America')
      end

      specify "first record pubtype is 'book'" do
        expect(gem_bibtex_bibliography.first.type).to eq(:book)
      end

      specify "first record address is 'Lafayette, {IN}'" do
        expect(gem_bibtex_bibliography.first.address).to eq('Lafayette, {IN}')
      end

      specify "first record publisher is 'The Thomas Say Foundation'" do
        expect(gem_bibtex_bibliography.first.publisher).to eq('The Thomas Say Foundation')
      end

      specify "first record author is 'Needham, James G. and Claassen, Peter W.'" do
        expect(gem_bibtex_bibliography.first.author).to eq('Needham, James G. and Claassen, Peter W.')
      end

      specify "first record author.last is 'Needham & Claassen'" do
        expect(gem_bibtex_bibliography.first.author[0].last).to eq('Needham')
      end

      specify "second record pubtype is 'article'" do
        expect(gem_bibtex_bibliography[1].type).to eq(:article)
      end

      specify "second record volume is '53'" do
        expect(gem_bibtex_bibliography[1].volume).to eq('53')
      end

      specify "second record issn is '1480-3283'" do
        expect(gem_bibtex_bibliography[1].issn).to eq('1480-3283')
      end

      specify "second record number is '2.'" do
        expect(gem_bibtex_bibliography[1].number).to eq('2')
      end

      specify "second record journal is 'Canadian Journal of Zoology'" do
        expect(gem_bibtex_bibliography[1].journal).to eq('Canadian Journal of Zoology')
      end

      specify "second record year is '1975'" do
        expect(gem_bibtex_bibliography[1].year).to eq('1975')
      end

      specify "second record pages is '132–153'" do
        expect(gem_bibtex_bibliography[1].pages).to eq('132–153')
      end

      specify "fourth record pubtype is 'incollection'" do
        expect(gem_bibtex_bibliography[3].type).to eq(:incollection)
      end

      specify "fourth record booktitle is 'International Advances in the Ecology, Zoogeography, and Systematics of Mayflies and Stoneflies'" do
        expect(gem_bibtex_bibliography[3].booktitle).to eq('International Advances in the Ecology, Zoogeography, and Systematics of Mayflies and Stoneflies')
      end

      specify "last record edition is 'Fourth'" do
        expect(gem_bibtex_bibliography[-1].edition).to eq('Fourth')
      end

      specify "last record url is 'http://www.nhm.ac.uk/hosted-sites/iczn/code/'" do
        expect(gem_bibtex_bibliography[-1].url).to eq('http://www.nhm.ac.uk/hosted-sites/iczn/code/')
      end

      specify "last record urldate is '2010-12-06'" do
        expect(gem_bibtex_bibliography[-1].urldate).to eq('2010-12-06')
      end

      specify 'simple identity' do
        expect(simple1_gem_bibtex).to eq(simple2_gem_bibtex)
      end

      specify 'simple complex entity' do
        expect(gem_bibtex_entry1).to eq(gem_bibtex_entry2)
      end
    end

    skip 'test export from a set of Source::Bibtex to a BibTeX::Bibliography'
  end

  context 'Ruby BibTeX related instance methods' do
    before(:each) do
      @s = Source::Bibtex.new_from_bibtex(gem_bibtex_entry1)
    end

    context 'to_bibtex' do
      specify 'basic features' do
        expect(@s.bibtex_type.to_s).to eq(gem_bibtex_entry1.type.to_s)
        expect(@s.to_bibtex.fields).to eq(gem_bibtex_entry1.fields)
      end

      specify 'a single object note gets converted properly to a bibtex note' do
        n = 'I am a test note'
        expect(@s.notes.size).to eq(0) # @s has no notes
        expect(@s.save).to be_truthy # object has to be saved before adding a note
        expect(@s.notes << Note.new(text: n)).to be_truthy # add note to object (.build() doesn't add user housekeeping.)
        expect(@s.save).to be_truthy
        expect(@s.notes.size).to eq(1)
        b = @s.to_bibtex

        out_note = "#{@s.notes[0].updated_at}: #{User.find($user_id).name}: #{n}"
        expect(b[:note].to_s =~ /#{n}/).to be_truthy
        expect(b[:note].to_s =~ /#{@s.notes.first.creator.name}/).to be_truthy
        expect(b[:note].to_s).to eq(out_note) # should be (<date/time>: <user name>: <note>[on: <title>])
        #"2014-09-08 19:35:05 UTC: Joe Blow: I am a test note"
      end

      specify 'multiple object notes get converted properly' do
        n1 = 'test note1'
        n2 = 'test note2'
        expect(@s.notes.count).to eq(0) # @s has no notes
        expect(@s.save).to be_truthy # object has to be saved before adding a note
        expect(@s.notes << Note.new(text: n1)).to be_truthy # add 1st note to object
        expect(@s.notes << Note.new(text: n2)).to be_truthy # add 2nd note to object
        expect(@s.save).to be_truthy
        expect(@s.notes.count).to eq(2)
        b         = @s.to_bibtex

        # not sure how ordering should be tested? For now note2 always comes out first.
        out_note1 = "#{@s.notes[1].updated_at}: #{User.find($user_id).name}: #{n1}"
        out_note2 = "#{@s.notes[0].updated_at}: #{User.find($user_id).name}: #{n2}"
        expect(b[:note].to_s =~ /#{n1}/).to be_truthy
        expect(b[:note].to_s =~ /#{n2}/).to be_truthy
        expect(b[:note].to_s).to eq(out_note2 + '|' + out_note1) # should be 2 notes or'ed together.
      end

      specify 'a single attribute note gets converted properly' do
        n = 'I am a test attribute note'
        expect(@s.notes.count).to eq(0) # @s has no notes
        expect(@s.save).to be_truthy # object has to be saved before adding a note
        expect(@s.notes.build(text: n, note_object_attribute: 'title', created_by_id: $user_id, updated_by_id: $user_id)).to be_truthy # add note to object
        expect(@s.save).to be_truthy
        expect(@s.notes.count).to eq(1)
        date     = @s.notes.to_a[0].updated_at
        b        = @s.to_bibtex
        out_note = "#{@s.notes[0].updated_at}: #{User.find($user_id).name}: #{n}[on: #{@s.notes[0].note_object_attribute}]"
        expect(b[:note].to_s).to eq(out_note) # should be (<date/time>: <user name>: <note>[on: <title>])
        #"2014-09-08 19:35:05 UTC: Joe Blow: I am a test attribute note[on: title]"

      end

      specify 'multiple attribute notes get converted properly' do
        n1 = 'test note1'
        n2 = 'test note2'
        expect(@s.notes.count).to eq(0) # @s has no notes
        expect(@s.save).to be_truthy # object has to be saved before adding a note
        expect(@s.notes << Note.new(text: n1, note_object_attribute: 'title')).to be_truthy # add 1st note to object
        expect(@s.notes << Note.new(text: n2, note_object_attribute: 'author')).to be_truthy # add 2nd note to object
        expect(@s.save).to be_truthy
        expect(@s.notes.count).to eq(2)
        b         = @s.to_bibtex

        # not sure how ordering should be tested? For now note2 always comes out first.
        out_note1 = "#{@s.notes[1].updated_at}: #{User.find($user_id).name}: #{n1}[on: #{@s.notes[1].note_object_attribute}]"
        out_note2 = "#{@s.notes[0].updated_at}: #{User.find($user_id).name}: #{n2}[on: #{@s.notes[0].note_object_attribute}]"
        expect(b[:note].to_s =~ /#{n1}/).to be_truthy
        expect(b[:note].to_s =~ /#{n2}/).to be_truthy
        expect(b[:note].to_s).to eq(out_note2 + '|' + out_note1) # should be 2 notes or'ed together.
      end

      specify 'mixed attribute & object notes' do
        n1 = 'object note1'
        n2 = 'author note2'
        n3 = 'title note3'
        expect(@s.notes.count).to eq(0) # @s has no notes
        expect(@s.save).to be_truthy # object has to be saved before adding a note
        expect(@s.notes << Note.new(text: n1)).to be_truthy
        expect(@s.notes << Note.new(text: n2, note_object_attribute: 'author')).to be_truthy # add 2nd note to object
        expect(@s.notes << Note.new(text: n3, note_object_attribute: 'title')).to be_truthy # add 1st note to object
        expect(@s.save).to be_truthy
        expect(@s.notes.count).to eq(3)
        b         = @s.to_bibtex

        # not sure how ordering should be tested? For now note3 always comes out first.
        out_note1 = "#{@s.notes[2].updated_at}: #{User.find($user_id).name}: #{n1}"
        out_note2 = "#{@s.notes[1].updated_at}: #{User.find($user_id).name}: #{n2}[on: #{@s.notes[1].note_object_attribute}]"
        out_note3 = "#{@s.notes[0].updated_at}: #{User.find($user_id).name}: #{n3}[on: #{@s.notes[0].note_object_attribute}]"
        expect(b[:note].to_s =~ /#{n1}/).to be_truthy
        expect(b[:note].to_s =~ /#{n2}/).to be_truthy
        expect(b[:note].to_s).to eq(out_note3 + '|' + out_note2 + '|' + out_note1) # should be 3 notes or'ed together.
      end

      skip 'serial gets converted properly to bibtex journal' do

      end
    end

    context 'validate bibtex' do
      specify 'check that valid_bibtex? works (relies on BibTeX::Entry.valid? which is not currently working)' do
        expect(@s.valid_bibtex?).to be_falsey # missing a publisher
      end
      specify 'soft_validate bibtex fields - get error messages' do
        @s.soft_validate(:bibtex_fields)
        expect(@s.soft_validations.messages_on(:publisher).empty?).to be_falsey
        expect(@s.soft_validations.messages).to include 'There is no publisher associated with this source.'
      end
      specify 'make it valid' do
        @s.publisher = 'Silly Books Inc'
        expect(@s.valid_bibtex?).to be_truthy
      end
    end

    specify 'with a note in a BibTeX::Entry, convert it to a Source::Bibtex with an attached Note' do
      note                       = "This is a note.\n With multiple lines."
      valid_gem_bibtex_book.note = note
      s                          = Source::Bibtex.new_from_bibtex(valid_gem_bibtex_book)
      expect(s.notes.to_a.count).to eq(1)
      expect(s.notes.first.text).to eq(note + ' [Created on import from BibTeX.]')
      expect(s.save).to be_truthy
      expect(s.notes.first.id.nil?).to be_falsey
    end

    specify 'with an isbn in a BibTeX::Entry, convert it to an Identifier' do
      identifier                 = '1-84356-028-3'
      valid_gem_bibtex_book.isbn = identifier
      s                          = Source::Bibtex.new_from_bibtex(valid_gem_bibtex_book)
      expect(s.identifiers.to_a.count).to eq(1)
      expect(s.identifiers.first.identifier).to eq(identifier)
      expect(s.save).to be_truthy
      expect(s.identifiers.first.id.nil?).to be_falsey
      expect(s.isbn.to_s).to eq(identifier)
    end

    context 'with an issn in a BibTeX::Entry, convert it to an Identifier' do
      %w{2049-3630 2049-363x 2049-363X}.each do |n|
        specify "ISSN #{n}" do
          identifier                 = "#{n}"
          valid_gem_bibtex_book.issn = identifier
          s                          = Source::Bibtex.new_from_bibtex(valid_gem_bibtex_book)
          expect(s.identifiers.to_a.count).to eq(1)
          expect(s.identifiers.first.identifier).to eq(identifier)
          expect(s.save).to be_truthy
          expect(s.identifiers.first.id.nil?).to be_falsey
          expect(s.issn.to_s).to eq(identifier)
        end
      end
    end

    specify 'with a doi in a BibTeX::Entry, convert it to an Identifier' do
      # per http://www.doi.org/factsheets/DOIIdentifiers.html the following are all valid doi's
      #  Registrant using PII: doi:10.2345/S1384107697000225
      #  Registrant using SICI: doi:10.4567/0361-9230(1997)42:<OaEoSR>2.0.TX;2-B
      #  Registrant using internal scheme: doi:10.6789/JoesPaper56

      identifier                = '10.2345/S1384107697000225'
      valid_gem_bibtex_book.doi = identifier
      s                         = Source::Bibtex.new_from_bibtex(valid_gem_bibtex_book)
      expect(s.identifiers.to_a.count).to eq(1)
      expect(s.identifiers.first.identifier).to eq(identifier)
      expect(s.save).to be_truthy
      expect(s.identifiers.first.id.nil?).to be_falsey
      expect(s.doi.to_s).to eq(identifier)
    end
  end

  context 'validation' do
    specify 'must have a valid bibtex_type' do
      local_src = FactoryGirl.build(:valid_source_bibtex)
      expect(local_src.valid?).to be_truthy
      local_src.bibtex_type = 'test'
      expect(local_src.valid?).to be_falsey
      expect(local_src.errors.include?(:bibtex_type)).to be_truthy
      local_src.bibtex_type = nil
      expect(local_src.valid?).to be_falsey
      expect(local_src.errors.include?(:bibtex_type)).to be_truthy
    end

    specify 'must have one of the following fields: :author, :booktitle, :editor, :journal,
      :title, :year, :url, :stated_year' do
      error_message = 'no core data provided'
      local_src     = Source::Bibtex.new()
      expect(local_src.valid?).to be_falsey
      expect(local_src.errors.messages[:base].include?(error_message)).to be_truthy
      local_src.title = 'Test book'
      local_src.valid?
      expect(local_src.errors.full_messages.include?(error_message)).to be_falsey
    end

    context 'test date related fields' do
      let(:source_bibtex) { FactoryGirl.build(:valid_source_bibtex) }

      specify 'if present year, must be an integer an greater than 999 and no more than 2 years in the future' do
        error_msg          = 'year must be an integer greater than 999 and no more than 2 years in the future'
        source_bibtex.year = 'test'
        expect(source_bibtex.valid?).to be_falsey
        expect(source_bibtex.errors.messages[:year].include?(error_msg)).to be_truthy
        source_bibtex.year = 2000
        expect(source_bibtex.valid?).to be_truthy
        source_bibtex.soft_validate
        expect(source_bibtex.soft_validations.messages_on(:year).empty?).to be_truthy
        source_bibtex.year = 999
        expect(source_bibtex.valid?).to be_falsey
        expect(source_bibtex.errors.messages[:year].include?(error_msg)).to be_truthy
        source_bibtex.soft_validate
        expect(source_bibtex.soft_validations.messages_on(:year).empty?).to be_falsey
        expect(source_bibtex.soft_validations.messages).to include 'This year is prior to the 1700s'
        source_bibtex.year = 1700
        expect(source_bibtex.valid?).to be_truthy
        source_bibtex.soft_validate
        expect(source_bibtex.soft_validations.messages_on(:year).empty?).to be_truthy
        source_bibtex.year = Time.now.year + 3
        expect(source_bibtex.valid?).to be_falsey
        expect(source_bibtex.errors.messages[:year].include?(error_msg)).to be_truthy
        source_bibtex.year = Time.now.year + 2
        expect(source_bibtex.valid?).to be_truthy
        source_bibtex.soft_validate
        expect(source_bibtex.soft_validations.messages_on(:year).empty?).to be_truthy
      end

      specify 'if month is set, there must be a year' do
        error_msg           = 'year is required when month or stated_year is provided'
        source_bibtex.month = 'feb'
        expect(source_bibtex.valid?).to be_falsey
        expect(source_bibtex.errors.messages[:year].include?(error_msg)).to be_truthy
      end

      specify 'if stated_year is set, there must be a year' do
        skip #TODO
      end

      context 'months' do
        before(:each) {
          source_bibtex.year = 1920
        }
        specify 'when passed a symbol, a string is returned' do
          source_bibtex.month = :jan
          expect(source_bibtex.month).to eq('jan')
        end
        specify 'when passed a string, a string is returned' do
          source_bibtex.month = 'jan'
          expect(source_bibtex.month).to eq('jan')
        end

        specify 'month must be in %w{jan feb mar ...}' do
          ::VALID_BIBTEX_MONTHS.each do |m|
            source_bibtex.month = m
            expect(source_bibtex.valid?).to be_truthy
          end
        end

        specify 'handles full month' do
          %w{january January}.each do |m|
            source_bibtex.month = m
            expect(source_bibtex.valid?).to be_truthy
            expect(source_bibtex.month).to eq('jan')
          end
        end

        specify 'handles integer month' do
          source_bibtex.month = 1
          expect(source_bibtex.valid?).to be_truthy
          expect(source_bibtex.month).to eq('jan')
        end

        specify 'generates error on integer month > 12' do
          source_bibtex.month = 45
          expect(source_bibtex.valid?).to be_falsey
          expect(source_bibtex.errors.include?(:month)).to be_truthy
        end

        specify 'handles roman numeral month' do
          source_bibtex.month = 'i'
          expect(source_bibtex.valid?).to be_truthy
          expect(source_bibtex.month).to eq('jan')
        end

        it 'generates error on invalid text month' do
          source_bibtex.month = 'foo'
          expect(source_bibtex.valid?).to be_falsey
          expect(source_bibtex.errors.include?(:month)).to be_truthy
        end
      end

      context 'day validation' do
        before(:each) {
          source_bibtex.year = 1945
        }
        specify 'if day is present there must be a month' do
          error_msg         = 'month is required when day is provided'
          source_bibtex.day = 31
          expect(source_bibtex.valid?).to be_falsey
          expect(source_bibtex.errors.messages[:month].include?(error_msg)).to be_truthy
        end

        specify 'day, if present, must be valid for month' do
          source_bibtex.day   = 30
          source_bibtex.month = 'feb'
          expect(source_bibtex.valid?).to be_falsey
          expect(source_bibtex.errors.messages[:day].include?('30 is not a valid day for the month provided')).to be_truthy
          source_bibtex.day = 4
          expect(source_bibtex.valid?).to be_truthy
        end
      end
    end

    context 'on save set cached values - single author' do
      let(:l_src) { FactoryGirl.create(:soft_valid_bibtex_source_article) }

      specify 'save src' do
        expect(l_src.save).to be_truthy
      end

      context 'after save' do
        before {
          l_src.save
        }

        specify 'src should have a cached value' do
          expect(l_src.cached.blank?).to be_falsey
        end

        specify 'which equals...(currently failing due to problems with citeproc)' do
          expect(l_src.cached).to eq('Person, T. (1000) I am a soft valid article. Journal of Test Articles.')
        end

        specify 'cached author should be set' do
          expect(l_src.cached_author_string.blank?).to be_falsey
        end

        specify 'which equals...' do
          expect(l_src.cached_author_string).to eq('Person')
        end
      end
    end

    context 'before save set cached values - multiple authors' do
      let(:l_src) { FactoryGirl.build(:src_mult_authors) }

      specify 'src should save' do
        expect(l_src.save).to be_truthy
      end

      context 'after save' do
        before {
          l_src.save
        }

        specify 'src should have a cached value' do
          expect(l_src.cached.blank?).to be_falsey
        end

        context 'correctly creates authority_name & cached_author_string' do
          before {
            @source_bibtex = FactoryGirl.build(:valid_source_bibtex)
          }
          context 'with author, but without authors' do
            specify 'single author' do
              @source_bibtex.author = 'Thomas, D.'
              @source_bibtex.save
              expect(@source_bibtex.cached_author_string).to eq('Thomas')
              expect(@source_bibtex.authority_name).to eq('Thomas')
            end
            specify 'multiple authors' do
              @source_bibtex.author ='Thomas, D. and Fowler, Chad and Hunt, Andy'
              @source_bibtex.save
              expect(@source_bibtex.cached_author_string).to eq('Thomas, Fowler & Hunt')
              expect(@source_bibtex.authority_name).to eq('Thomas, Fowler & Hunt')
            end
            specify 'valid Source::Bibtex but not valid BibTex::Entry' do
              l_src.year = nil
              l_src.soft_validate
              expect(l_src.soft_validations.messages_on(:year).empty?).to be_falsey
              expect(l_src.save).to be_truthy
              expect(l_src.cached_author_string).to eq('Thomas, Fowler & Hunt')
            end
          end
        end

        specify 'cached string should be correct' do
          expect(l_src.cached).to eq('Thomas, D., Fowler, C. & Hunt, A. (1920) Article with multiple authors. Journal of Test Articles.')
        end
      end

    end

    specify 'the url must be valid' do
      src = FactoryGirl.build(:valid_source_bibtex)
      err = '] is not a valid URL'
      expect(src.valid?).to be_truthy # nil url is valid
      src.url = 'bad url'
      expect(src.valid?).to be_falsey
      expect(src.errors.messages[:url].include?('['+src.url+err)).to be_truthy
      src.url = 'http://speciesfile.org'
      expect(src.valid?).to be_truthy
      src.url = 'speciesfile.org'
      expect(src.valid?).to be_falsey
      expect(src.errors.messages[:url].include?('['+src.url+err)).to be_truthy
      src.url = 'https://google.com'
      expect(src.valid?).to be_truthy
      src.url = 'ftp://test.edu'
      expect(src.valid?).to be_truthy
    end
  end

  # sanity check for Housekeeping, which is also tested elsewhere 
  context 'roles and houskeeping' do
    let(:bibtex) { Source::Bibtex.create(title: 'Roles', year: 1923, bibtex_type: 'book') }

    specify 'with << and an existing object' do
      expect(bibtex.roles.count).to eq(0)
      # this pattern appears to save off Person before it is added!
      bibtex.authors << Person.new(last_name: "Smith")
      expect(bibtex.save).to be_truthy

      expect(bibtex.authors.first.creator.nil?).to be_falsey
      expect(bibtex.authors.first.updater.nil?).to be_falsey

      expect(bibtex.roles.first.creator.nil?).to be_falsey
      expect(bibtex.roles.first.updater.nil?).to be_falsey
    end

    specify 'with .build and an existing person' do
      expect(bibtex.roles.count).to eq(0)
      p = Person.create(last_name: 'Smith')
      bibtex.author_roles.build(person: p)
      expect(bibtex.save).to be_truthy
      expect(bibtex.roles.first.creator.nil?).to be_falsey
      expect(bibtex.roles.first.updater.nil?).to be_falsey
      expect(bibtex.roles.first.project_id.nil?).to be_truthy # no project_id on author_roles
    end

    context 'with a new object' do
      let(:s) { Source::Bibtex.new(title: 'Roles II', year: 1924, bibtex_type: 'book') }
      specify 'with new object, <<, and existing Person' do
        expect(bibtex.roles.count).to eq(0)
        s.authors << Person.create(last_name: 'Jones')
        expect(s.save).to be_truthy
        expect(s.roles.count).to eq(1)
        expect(s.roles.first.creator.nil?).to be_falsey
        expect(s.roles.first.updater.nil?).to be_falsey
        expect(s.roles.first.project_id.nil?).to be_truthy

        expect(s.authors.first.creator.nil?).to be_falsey
        expect(s.authors.first.updater.nil?).to be_falsey
      end

      specify 'with new object, <<, and new Person' do
        expect(bibtex.roles.count).to eq(0)
        s.authors << Person.new(last_name: 'Jones')
        expect(s.save).to be_truthy
        expect(s.roles.count).to eq(1)
        expect(s.roles.first.creator.nil?).to be_falsey
        expect(s.roles.first.updater.nil?).to be_falsey
        expect(s.roles.first.project_id.nil?).to be_truthy

        expect(s.authors.first.creator.nil?).to be_falsey
        expect(s.authors.first.updater.nil?).to be_falsey
      end

      # A setter solution that approximates nested_attributes_for (which can't be used on polymorphic through)
      specify 'with new and authors_to_create pattern' do
        s.authors_to_create = [{last_name: "Yabbadabbadoo."}]
        expect(s.save).to be_truthy
        expect(s.roles.count).to eq(1)
        expect(s.roles.first.creator.nil?).to be_falsey
        expect(s.roles.first.updater.nil?).to be_falsey
        expect(s.roles.first.project_id.nil?).to be_truthy

        expect(s.authors.first.creator.nil?).to be_falsey
        expect(s.authors.first.updater.nil?).to be_falsey
      end

      specify 'with new and authors_to_create pattern, no person created when parent is !valid' do
        expect(Person.count).to eq(0)
        s.authors_to_create = [{}]
        expect(s.save).to be_falsey
        expect(s.errors.include?(:base)).to be_truthy
        expect(Person.count).to eq(0)
      end
    end
  end

  context 'instance methods - ' do
    before(:each) {
      # this is a TW Source::Bibtex - type article, with just a title
      @source_bibtex = FactoryGirl.build(:valid_source_bibtex)
      #@bibtex_book   = FactoryGirl.build(:valid_bibtex_source_book_title_only)
    }
    context 'with an existing instance of Source::Bibtex' do

      context '.create_related_people_and_roles()' do
        specify 'can not be run when .new_record?' do
          expect(@source_bibtex.new_record?).to be_truthy
          expect(@source_bibtex.valid?).to be_truthy
          @source_bibtex.author = 'Smith, James'
          expect(@source_bibtex.create_related_people_and_roles).to be_falsey
        end

        # NOTE: Be aware of possible translator roles, we don't handle this
        specify 'returns false when author.nil? && editor.nil?' do
          expect(@source_bibtex.create_related_people_and_roles).to be_falsey
        end

        specify 'returns false when instance.valid? is false' do
          s = Source::Bibtex.new()
          expect(s.create_related_people_and_roles).to be_falsey
        end

        %w{author editor}.each do |a|
          context "creates people for #{a}s" do
            let(:source_bibtex) { FactoryGirl.build(:valid_source_bibtex) }
            specify "single #{a}" do
              method = "#{a}s"
              source_bibtex.send("#{a}=".to_sym, 'Smith, Bill')
              source_bibtex.save
              expect(source_bibtex.send(method.to_sym).size).to eq(0)
              expect(source_bibtex.create_related_people_and_roles).to be_truthy
              source_bibtex.reload
              expect(source_bibtex.send(method.to_sym).size).to eq(1)
              #@source_bibtex.reload
              expect(source_bibtex.send(method.to_sym).to_a.count).to eq(1)
              expect((source_bibtex.send(method.to_sym)).first.last_name).to eq('Smith')
              expect((source_bibtex.send(method.to_sym)).first.first_name).to eq('Bill')
            end

            specify "multiple #{a}s" do
              method = "#{a}s"

              source_bibtex.send("#{a}=".to_sym, 'Thomas, D. and Fowler, Chad and Hunt, Andy')
              expect(source_bibtex.save).to be_truthy
              expect(@source_bibtex.send(method.to_sym).size).to eq(0)

              expect(Person.count).to eq(0)
              expect(source_bibtex.create_related_people_and_roles).to be_truthy
              expect(Person.count).to eq(3)

              source_bibtex.reload

              expect(source_bibtex.send(method.to_sym).to_a.count).to eq(3)
              expect(source_bibtex.send(method.to_sym).first.last_name).to eq('Thomas')
              expect(source_bibtex.send(method.to_sym).first.first_name).to eq('D.')
              author1_id = source_bibtex.send(method.to_sym).first.id
              author1    = Person.find(author1_id)
              expect(author1).to be_instance_of(Person::Unvetted)
              expect(Person.where(last_name: 'Thomas', first_name: 'D.').to_a.include?(author1)).to be_truthy

              expect(source_bibtex.send(method.to_sym).last.last_name).to eq('Hunt')
              expect(source_bibtex.send(method.to_sym).last.first_name).to eq('Andy')
            end
          end

          specify "#{a}s returns correctly ordered arrays" do
            method       = "#{a}s"
            method_roles = "#{a}_roles"
            @source_bibtex.send("#{a}=".to_sym, 'Thomas, D. and Fowler, Chad and Hunt, Andy')
            expect(@source_bibtex.save).to be_truthy
            expect(@source_bibtex.send(method.to_sym).size).to eq(0)
            expect(@source_bibtex.create_related_people_and_roles).to be_truthy
            @source_bibtex.reload
            @source_bibtex.authors.reload
            @source_bibtex.editors.reload
            expect(@source_bibtex.send(method.to_sym).to_a.count).to eq(3)

            a_id       = @source_bibtex.send(method.to_sym).first.id
            a_role_obj = @source_bibtex.send(method_roles.to_sym)[0]
            expect(@source_bibtex.send(method.to_sym)[0].last_name).to eq('Thomas')
            expect(@source_bibtex.send(method.to_sym)[0].first_name).to eq('D.')
            expect(a_role_obj.position).to eq(1)
            expect(a_role_obj.person_id).to eq(a_id)

            a_id       = @source_bibtex.send(method.to_sym)[1].id
            a_role_obj = @source_bibtex.send(method_roles.to_sym)[1]
            expect(@source_bibtex.send(method.to_sym)[1].last_name).to eq('Fowler')
            expect(@source_bibtex.send(method.to_sym)[1].first_name).to eq('Chad')
            expect(a_role_obj.position).to eq(2)
            expect(a_role_obj.person_id).to eq(a_id)

            a_id       = @source_bibtex.send(method.to_sym).last.id
            a_role_obj = @source_bibtex.send(method_roles.to_sym)[2]
            expect(@source_bibtex.send(method.to_sym)[2].last_name).to eq('Hunt')
            expect(@source_bibtex.send(method.to_sym)[2].first_name).to eq('Andy')
            expect(a_role_obj.position).to eq(3)
            expect(a_role_obj.person_id).to eq(a_id)
          end
        end

        specify 'successfully creates a combination of authors & editors' do
          @source_bibtex.author = 'Thomas, D. and Fowler, Chad and Hunt, Andy'
          @source_bibtex.editor = 'Smith, Bill'
          @source_bibtex.save
          expect(@source_bibtex.authors.count).to eq(0)
          expect(@source_bibtex.editors.count).to eq(0)
          expect(@source_bibtex.create_related_people_and_roles).to be_truthy
          @source_bibtex.reload

          expect(@source_bibtex.authors.to_a.count).to eq(3)
          expect(@source_bibtex.authors.first.last_name).to eq('Thomas')
          expect(@source_bibtex.authors.first.first_name).to eq('D.')
          author1_id = @source_bibtex.authors.first.id
          author1    = Person.find(author1_id)
          expect(author1).to be_instance_of(Person::Unvetted)
          expect(Person.where(last_name: 'Thomas', first_name: 'D.').to_a.include?(author1)).to be_truthy

          expect(@source_bibtex.authors.last.last_name).to eq('Hunt')
          expect(@source_bibtex.authors.last.first_name).to eq('Andy')

          expect(@source_bibtex.editors.to_a.count).to eq(1)
          expect(@source_bibtex.editors.first.last_name).to eq('Smith')
          expect(@source_bibtex.editors.first.first_name).to eq('Bill')
        end

        context 'can not run on a source with existing roles' do
          %w{author editor}.each do |a|
            specify "can not be run when #{a} exists" do
              @source_bibtex.send("#{a}=".to_sym, 'Smith, Bill and Jones, Jane')
              @source_bibtex.save
              expect(@source_bibtex.create_related_people_and_roles).to be_truthy
              @source_bibtex.reload
              if a == 'author'
                expect(@source_bibtex.valid? && @source_bibtex.authors.count == 2).to be_truthy
                expect(@source_bibtex.editors.count == 0).to be_truthy
              else # editor
                expect(@source_bibtex.valid? && @source_bibtex.editors.count == 2).to be_truthy
                expect(@source_bibtex.authors.count == 0).to be_truthy
              end
              expect(@source_bibtex.create_related_people_and_roles).to be_falsey #roles/people already exist
            end
          end
        end

        # TODO if the bibtex entry has a journal create the Serials
      end

      %w{author editor}.each do |a|
        context ".has_#{a}s? should evaluate both the #{a} attribute & roles" do
          let(:has_method) { "has_#{a}s?" }

          specify "returns false if neither exist" do
            expect(@source_bibtex.send(has_method)).to be_falsey
          end

          specify 'returns true if author attribute populated' do
            @source_bibtex.send("#{a}=".to_sym, 'Smith, Bill')
            expect(@source_bibtex.send(has_method)).to be_truthy
          end

          context 'saved and with .authors.count > 0 and (initially) !.author.nil?' do
            before {
              @source_bibtex.save
              @source_bibtex.send("#{a}=".to_sym, 'Smith, Bill')
              @source_bibtex.create_related_people_and_roles
            }

            specify 'returns true when if !author.nil? AND .authors.count > 0' do
              @source_bibtex.reload
              expect(@source_bibtex.send(has_method)).to be_truthy
            end

            specify 'returns true if, subsequently, .author.nil?' do
              @source_bibtex.send("#{a}=".to_sym, nil)
              @source_bibtex.reload
              expect(@source_bibtex.send(has_method)).to be_truthy
            end
          end
        end
      end

      specify 'test nomenclature_date generation' do
        @source_bibtex.year = 1984
        expect(@source_bibtex.save).to be_truthy
        @source_bibtex.reload
        expect(@source_bibtex.cached_nomenclature_date).to eq(Time.utc(1984, 12, 31))

        @source_bibtex.month = 'feb'
        expect(@source_bibtex.save).to be_truthy
        @source_bibtex.reload
        expect(@source_bibtex.cached_nomenclature_date).to eq(Time.utc(1984, 2, 29))

        @source_bibtex.day = 12
        expect(@source_bibtex.save).to be_truthy
        @source_bibtex.reload
        expect(@source_bibtex.cached_nomenclature_date).to eq(Time.utc(1984, 2, 12))

        # Times before before 1823, or after 2116 are handled differently.
        @source_bibtex.year  = 1775
        @source_bibtex.month = nil
        @source_bibtex.day   = nil
        expect(@source_bibtex.save).to be_truthy
        @source_bibtex.reload
        expect(@source_bibtex.cached_nomenclature_date).to eq(Time.utc(1775, 12, 31))
        @source_bibtex.month = 'feb'
        expect(@source_bibtex.save).to be_truthy
        @source_bibtex.reload
        expect(@source_bibtex.cached_nomenclature_date).to eq(Time.utc(1775, 2, 28))
        @source_bibtex.day = 12
        expect(@source_bibtex.save).to be_truthy
        @source_bibtex.reload
        expect(@source_bibtex.cached_nomenclature_date).to eq(Time.utc(1775, 2, 12))
      end

      specify 'sort an array of source by potentially_validating date' do
        Source.delete_all
        @source_bibtex.year = 2002 # @source_bibtex has no date, title: 'article 1 just title'
        expect(@source_bibtex.save).to be_truthy
        FactoryGirl.create(:valid_bibtex_source_book_title_only) # 'valid book with just a title' : no date
        FactoryGirl.create(:valid_thesis) # 'Bugs by Beth': june 1982
        FactoryGirl.create(:valid_misc) # 'misc source': july 4 2010
        @sources = Source::Bibtex.all
        expect(@sources.count).to eq(4)

        expect(@sources[0].title).to eq('article 1 just title')
        expect(@sources[1].title).to eq('valid book with just a title')
        expect(@sources[2].title).to eq('Bugs by Beth')
        expect(@sources[3].title).to eq('misc source')

        @source2 = @sources.order_by_nomenclature_date
        expect(@source2.count).to eq(4)
        expect(@source2.map(&:title)).to eq(['Bugs by Beth', 'article 1 just title', 'misc source', 'valid book with just a title'])
      end
    end

    context 'attributes' do
      context 'Must facilitate letter annotations on year' do
        specify 'correctly generates year suffix from BibTeX entry' do
          bibtex_entry_year = BibTeX::Entry.new(type: :book, title: 'Foos of Bar America', author: 'Smith, James', year: '1921b')
          src               = Source::Bibtex.new_from_bibtex(bibtex_entry_year)
          expect(src.year.to_s).to eq('1921') # year is an int by default
          expect(src.year_suffix).to eq('b')
          expect(src.year_with_suffix).to eq('1921b')
        end
        specify 'correctly converts year suffix to BibTeX entry' do
          src               = FactoryGirl.create(:valid_source_bibtex)
          src[:year]        = '1922'
          src[:year_suffix] = 'c'
          expect(src.year_with_suffix).to eq('1922c')
          bibtex_entry = src.to_bibtex
          expect(bibtex_entry[:year]).to eq('1922c')
        end
      end
    end

    context 'associations' do
      context 'roles' do
        before(:each) {
          @valid_person = FactoryGirl.create(:valid_person)
        }

        specify 'after create/saved populate author/editor roles' do
          # bs1 was saved in the "before", since the authors already exist in the db,
          # the roles should be automatically set? (Yes)
          skip
        end
=begin
      # cached values are tested above in "after save"
      specify 'after create/saved authors are cached in cached_author_string' do
        # Editors are not cached.
      end
      skip
=end

        specify 'if authors/editors are updated' do
          skip
        end

        context 'on validation' do
          # Force the user to interact through authors first, then back save to author
          skip 'invalidate if authors exist and author has changed, and no longer matches'

          # ditto for editors
          skip 'invalidate if editors exist and editor has changed, and no longer matches'
        end

        %w{author editor}.each do |i|
          specify "#{i}s" do
            method = "#{i}s"
            expect(bibtex).to respond_to(method)
            expect(bibtex.send(method)).to eq([])
            bibtex.title       = 'valid record'
            bibtex.bibtex_type = 'book'
            expect(bibtex.save).to be_truthy # save record to get an ID
            expect(bibtex.send(method) << @valid_person).to be_truthy # assigns author but doesn't save role
            expect(bibtex.save).to be_truthy # saving bibtex also saves role
            expect(bibtex.send(method).first).to eq(@valid_person)
          end

          specify "#{i}_roles" do
            method = "#{i}_roles"
            expect(bibtex).to respond_to(method)
            expect(bibtex.send(method)).to eq([])
            bibtex.title       = 'valid record'
            bibtex.bibtex_type = 'book'
            expect(bibtex.save).to be_truthy
            expect(bibtex.send("#{i}s") << @valid_person).to be_truthy
            expect(bibtex.save).to be_truthy
            expect(bibtex.send(method).size).to eq(1)
          end
        end
      end
    end
  end


  context 'class methods' do
    # create_with_roles(bibtex_entry, opts = {})
    #    opts = {
    #      use_vetted_people: false
    #    }.merge!(opts)

    context '#new_from_bibtex' do
      let(:citation_string) { %Q(@book{international_commission_on_zoological_nomenclature_international_1999,
                                    address = {London},
                                    edition = {Fourth},
                                    title = {International Code of Zoological Nomenclature},
                                    url = {http://www.nhm.ac.uk/hosted-sites/iczn/code/},
                                    urldate = {2010-12-06},
                                    publisher = {International Trust for Zoological Nomenclature},
                                    author = {International Commission on Zoological Nomenclature},
                                    year = {1999}})
      }
      let(:bibtex_entry) { BibTeX.parse(citation_string).first }

      specify 'handles non-recognized keys as ImportAttributes' do
        expect(a = Source::Bibtex.new_from_bibtex(bibtex_entry)).to be_truthy
        expect(a.save).to be_truthy
        a.reload
        expect(a.data_attributes.count).to eq(1)
        expect(a.data_attributes.first.type).to eq('ImportAttribute')
        expect(a.data_attributes.first.import_predicate).to eq('urldate')
        expect(a.data_attributes.first.value).to eq('2010-12-06')
      end

    end

    context 'create_with_roles(BibTeX::Entry instance)' do
      specify 'creates author/editor roles with Person::Unvetted by default' do
        skip
      end

      context 'parameters' do
        specify '{use_vetted_people: true} - uses exactly matching Person::Vetted found, otherwise creates new editors/authors' do
          skip
        end
      end
    end
  end

=begin
  context 'supporting libs' do
    # TODO support for a zotero bibliography
    context 'if I have a zotero bibliography' do
      context 'and I import it to TW' do
        context 'when I update a record in zotero' do
          specify 'then TW should be aware and notify me of discrepancies' do
            skip 'not implemented yet'
          end
        end
      end
    end

    context 'Hackathon requirements' do
      # TODO: code lib/bibtex   - round trip a file?
      # note that we've determined that some fields won't round trip properly (notes)
      skip 'Should be able to round trip data a whole file '
      #(e.g. import a BibTex file, then output a BibTex file and have them be the same.)
    end
  end
=end

  context 'soft validations' do
    let(:source_bibtex) { FactoryGirl.build(:valid_source_bibtex) }

    specify 'missing authors' do
      source_bibtex.soft_validate(:recommended_fields)
      expect(source_bibtex.soft_validations.messages_on(:author).empty?).to be_falsey
      expect(source_bibtex.soft_validations.messages).to include('There is neither an author, nor editor associated with this source.')
      source_bibtex.author = 'Smith, Bill'
      source_bibtex.save
      source_bibtex.soft_validate(:recommended_fields)
      expect(source_bibtex.soft_validations.messages_on(:author).empty?).to be_truthy
    end

    specify 'year is before 1700 (before nomenclature)' do
      source_bibtex.year = 1699
      expect(source_bibtex.valid?).to be_truthy
      source_bibtex.soft_validate()
      expect(source_bibtex.soft_validations.messages_on(:year).empty?).to be_falsey
      expect(source_bibtex.soft_validations.messages).to include 'This year is prior to the 1700s'
      source_bibtex.year = 1700
      source_bibtex.save
      source_bibtex.soft_validate()
      expect(source_bibtex.soft_validations.messages_on(:year).empty?).to be_truthy
    end

    skip 'test sv_has_notes? runs correctly when there is no src_bibtex.note but does have src_bibtex.notes'
  end

  context('Beth') do
=begin
    notes/things to do:
      Document bibtex source using YardTags - se example in root\lib\soft_validation.rb
      Formatting -
        Rendering code will go in a helper
        Check out what formatting is provided by BibTex gem - do we additional formats?
      DONE - Set the cached fields in the bibtex records on save
      Has author role but no author field => bibtex should work
=end

    # from context 'roles'
    #before do
    #  # create & save 3 people
    #  p1 = Person.new(last_name: 'Aus')
    #  p1.save
    #  p2 = Person.new(last_name: 'Bus')
    #  p2.save
    #  p3 = Person.new(last_name: 'Cus')
    #  p3.save
    #  # create 3 bibtex sources
    #  bs1 = Source::Bibtex.new(bibtex_type: 'article', title: 'a1b2c3', author: 'Aus, Bus, Cus')
    #  bs1.save
    #  bs2 = Source::Bibtex.new(bibtex_type: 'article', title: 'a3b1c2', author: 'Bus, Cus, Aus')
    #  bs2.save
    #  bs3 = Source::Bibtex.new(bibtex_type: 'article', title: 'a2b3c1', author: 'Cus, Aus, Bus')
    #  bs3.save
    #end

  end
end
