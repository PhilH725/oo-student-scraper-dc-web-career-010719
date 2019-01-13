require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)

    index = Nokogiri::HTML(html)

    students = []

    # everything: index.css("div .roster-cards-container .student-card")
    # name: index.css("div .roster-cards-container .student-card a div.card-text-container .student-name").first.text
    # location: index.css("div .roster-cards-container .student-card a div.card-text-container .student-location").first.text
    #profile_url: index.css("div .roster-cards-container .student-card a").attribute("href").value

    index.css("div .roster-cards-container .student-card").each do |student|
      student_info_hash = {
        :name => student.css("a div.card-text-container .student-name").text,
        :location => student.css("a div.card-text-container .student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }

      students << student_info_hash
    end

    students
    # binding.pry

  end

  def self.scrape_profile_page(profile_url)

    html = File.read(profile_url)

    profile = Nokogiri::HTML(html)

    #profile.css("div .social-icon-container a").attribute('href')

    # sites = [profile.css("div .social-icon-container a")[0].attribute("href").value, profile.css("div .social-icon-container a")[1].attribute("href").value,
      # profile.css("div .social-icon-container a")[2].attribute("href").value, profile.css("div .social-icon-container a")[3].attribute("href").value]

    sites = []
    for i in 0..3
      if !profile.css("div .social-icon-container a")[i].nil?
        sites << profile.css("div .social-icon-container a")[i].attribute("href").value
      end
    end

    twitter_url = nil
    linked_in_url = nil
    git_url = nil
    blog_url = nil

    sites.each do |site|
      if site.downcase.include?('twitter')
        twitter_url = site
      elsif site.downcase.include?('linkedin')
        linked_in_url = site
      elsif site.downcase.include?('github')
        git_url = site
      else
        blog_url = site
      end
    end

    #profile.css("div .vitals-text-container .profile-quote").text
    quote = profile.css("div .vitals-text-container .profile-quote").text

    bio = profile.css("div .details-container .description-holder p").text

    profile_hash_keys = []
    if !twitter_url.nil?
      profile_hash_keys << :twitter
    end
    if !linked_in_url.nil?
      profile_hash_keys << :linkedin
    end
    if !git_url.nil?
      profile_hash_keys << :github
    end
    if !blog_url.nil?
      profile_hash_keys << :blog
    end
    profile_hash_keys << :profile_quote
    profile_hash_keys << :bio

    profile_hash = {}
    profile_hash_keys.each do |key|
      if key == :twitter
        profile_hash[key] = twitter_url
      elsif key == :linkedin
        profile_hash[key] = linked_in_url
      elsif key == :github
        profile_hash[key] = git_url
      elsif key == :blog
        profile_hash[key] = blog_url
      elsif key == :profile_quote
        profile_hash[key] = quote
      elsif key == :bio
        profile_hash[key] = bio
      end
    end

    profile_hash






    # binding.pry
  end

end
